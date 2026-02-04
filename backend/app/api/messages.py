from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.api.deps import get_current_user
from app.models import models
from app.schemas import schemas
from app.services.ai_service import ai_service
import os

router = APIRouter()

@router.patch("/{message_id}", response_model=schemas.Message)
async def edit_message(
    message_id: int,
    message_update: schemas.MessageUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    from app.core.database import SessionLocal
    # 1. Fetch message and verify ownership
    message = db.query(models.Message).filter(models.Message.id == message_id, models.Message.user_id == current_user.username).first()
    if not message:
        raise HTTPException(status_code=404, detail="Message not found")
    
    if message.role != 'user':
        raise HTTPException(status_code=400, detail="Cannot edit bot messages")

    chat_id = message.chat_id

    # 2. Update message content
    message.content = message_update.content
    
    # 3. Delete all subsequent messages in this chat
    db.query(models.Message).filter(
        models.Message.chat_id == chat_id,
        models.Message.created_at > message.created_at
    ).delete(synchronize_session=False)
    
    db.commit()
    db.refresh(message)

    # 4. Regenerate AI response
    # Fetch rules applied to this chat (or we can assume rules are passed from frontend if needed, 
    # but for now let's get history and rules are usually handled in invoke.py)
    # We'll replicate some logic from invoke.py for now
    
    # Construct base instructions (we might want a central place for this)
    base_instructions = "You are a helpful AI assistant. You can handle greetings, general conversation, and technical tasks. "
    if message_update.rules_applied:
        # Fetch Rules and Construct System Prompt
        active_rules = db.query(models.Rule).filter(models.Rule.id.in_(message_update.rules_applied)).all()
        if active_rules:
            import os
            rules_content_list = []
            for r in active_rules:
                file_path = f"rules_storage/rule_{r.id}.md"
                if os.path.exists(file_path):
                    with open(file_path, "r", encoding="utf-8") as f:
                        rules_content_list.append(f.read())
                else:
                    rules_content_list.append(f"### {r.title}\n{r.description}")
            
            rules_text = "\n\n---\n\n".join(rules_content_list)
            base_instructions += f"\n\nAdditionally, follow these specific project rules strictly when applicable:\n\n{rules_text}\n\n"
    
    # Fetch history for context
    history_msgs = db.query(models.Message).filter(models.Message.chat_id == chat_id).order_by(models.Message.created_at.asc()).all()
    history = [{"role": msg.role, "parts": [msg.content]} for msg in history_msgs[:-1]] # excludes the updated message for history
    full_prompt = f"{base_instructions}\nUser: {message.content}"

    from fastapi.responses import StreamingResponse
    import json

    async def stream_generator():
        full_content = ""
        # Yield metadata
        metadata = {"chat_id": chat_id, "role": "bot"}
        yield f"data: {json.dumps({'type': 'metadata', 'chat_id': chat_id})}\n\n"
        
        async for chunk in ai_service.generate_stream(
            prompt=full_prompt,
            provider=message_update.provider,
            model=message_update.model, 
            history=history,
            attachments=message.attachments
        ):
            full_content += chunk
            yield f"data: {json.dumps({'type': 'content', 'delta': chunk})}\n\n"
        
        # Save to DB after stream finish using a fresh session
        async_db = SessionLocal()
        try:
            bot_msg = models.Message(
                role="bot", 
                content=full_content, 
                chat_id=chat_id,
                user_id=current_user.username
            )
            async_db.add(bot_msg)
            async_db.commit()
            async_db.refresh(bot_msg)
            # Yield final ID
            yield f"data: {json.dumps({'type': 'message_id', 'id': bot_msg.id})}\n\n"
        finally:
            async_db.close()

    return StreamingResponse(stream_generator(), media_type="text/event-stream")
