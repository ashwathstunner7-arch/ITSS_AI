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
    active_rules = db.query(models.Rule).filter(models.Rule.enabled == True).all()
    system_instructions = "\n".join([f"- {r.title}: {r.description}" for r in active_rules])
    
    full_prompt = f"Follow these rules:\n{system_instructions}\n\nUser: {request.message}"
    
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
