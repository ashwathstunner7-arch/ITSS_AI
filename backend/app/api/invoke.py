from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models import models
from app.schemas import schemas
from app.services.ai_service import ai_service

router = APIRouter()

@router.post("/", response_model=schemas.Message)
async def invoke_ai(request: schemas.InvokeRequest, db: Session = Depends(get_db)):
    # 1. Fetch Chat or create new one
    chat_id = request.chat_id
    if not chat_id:
        new_chat = models.Chat(title=request.message[:30] + "...")
        db.add(new_chat)
        db.commit()
        db.refresh(new_chat)
        chat_id = new_chat.id
    
    # 2. Add User Message to DB
    user_msg = models.Message(role="user", content=request.message, chat_id=chat_id)
    db.add(user_msg)
    
    # 3. Fetch Rules and Construct System Prompt
    system_instructions = ""
    if request.rules_applied:
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
            system_instructions = f"Follow these rules strictly:\n\n{rules_text}\n\n"
    
    full_prompt = f"{system_instructions}User: {request.message}"
    
    # 4. Get AI Response
    # Fetch history for context
    history_msgs = db.query(models.Message).filter(models.Message.chat_id == chat_id).order_by(models.Message.created_at.desc()).limit(10).all()
    history = [{"role": msg.role, "parts": [msg.content]} for msg in reversed(history_msgs)]
    
    ai_response_text = await ai_service.generate_response(
        prompt=full_prompt, 
        provider=request.provider, 
        model=request.model, 
        history=history
    )
    
    # 5. Add Bot Message to DB
    bot_msg = models.Message(role="bot", content=ai_response_text, chat_id=chat_id)
    db.add(bot_msg)
    db.commit()
    db.refresh(bot_msg)
    
    return bot_msg
