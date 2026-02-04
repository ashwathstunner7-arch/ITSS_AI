from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.api.deps import get_current_user
from app.models import models
from app.schemas import schemas
from app.services.ai_service import ai_service

router = APIRouter()

@router.post("/", response_model=schemas.Message)
async def invoke_ai(
    request: schemas.InvokeRequest, 
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    from app.core.database import SessionLocal
    # 1. Fetch Chat or create new one
    chat_id = request.chat_id
    if not chat_id:
        new_chat = models.Chat(
            title=request.message[:30] + "...",
            user_id=current_user.username
        )
        db.add(new_chat)
        db.commit()
        db.refresh(new_chat)
        chat_id = new_chat.id
    
    # 2. Add User Message to DB
    user_msg = models.Message(
        role="user", 
        content=request.message, 
        attachments=request.attachments, 
        chat_id=chat_id,
        user_id=current_user.username
    )
    db.add(user_msg)
    
    base_instructions = "You are a helpful AI assistant. You can handle greetings, general conversation, and technical tasks. "
    if request.rules_applied:
        # Fetch Rules and Construct System Prompt
        active_rules = db.query(models.Rule).filter(models.Rule.id.in_(request.rules_applied)).all()
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
    
    full_prompt = f"{base_instructions}\nUser: {request.message}"
    
    # 4. Get AI Response
    # Fetch history for context (excluding the message we just added)
    history_msgs = db.query(models.Message).filter(models.Message.chat_id == chat_id, models.Message.id != user_msg.id).order_by(models.Message.created_at.desc()).limit(10).all()
    history = [{"role": msg.role, "parts": [msg.content]} for msg in reversed(history_msgs)]
    
    if request.stream:
        from fastapi.responses import StreamingResponse
        import json

        async def stream_generator():
            full_content = ""
            # Yield metadata
            yield f"data: {json.dumps({'type': 'metadata', 'chat_id': chat_id})}\n\n"
            
            async for chunk in ai_service.generate_stream(
                prompt=full_prompt,
                provider=request.provider,
                model=request.model,
                history=history,
                attachments=request.attachments
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

    ai_response_text = await ai_service.generate_response(
        prompt=full_prompt, 
        provider=request.provider, 
        model=request.model, 
        history=history,
        attachments=request.attachments
    )
    
    # 5. Add Bot Message to DB
    bot_msg = models.Message(
        role="bot", 
        content=ai_response_text, 
        chat_id=chat_id,
        user_id=current_user.username
    )
    db.add(bot_msg)
    db.commit()
    db.refresh(bot_msg)
    
    return bot_msg
