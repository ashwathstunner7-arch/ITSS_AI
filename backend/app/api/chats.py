from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.models import models
from app.schemas import schemas
from app.api.deps import get_current_user

router = APIRouter()

@router.get("/", response_model=List[schemas.Chat])
def get_chats(db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    return db.query(models.Chat).filter(models.Chat.user_id == current_user.username)\
        .order_by(models.Chat.is_pinned.desc(), models.Chat.created_at.desc()).all()

@router.delete("/all")
def delete_all_chats(db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    # Delete all messages from user's chats first to avoid foreign key violations
    db.query(models.Message).filter(models.Message.user_id == current_user.username).delete(synchronize_session=False)
    # Then delete all chats
    db.query(models.Chat).filter(models.Chat.user_id == current_user.username).delete(synchronize_session=False)
    db.commit()
    return {"message": "All chats deleted"}

@router.get("/{chat_id}", response_model=schemas.Chat)
def get_chat(chat_id: int, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    chat = db.query(models.Chat).filter(models.Chat.id == chat_id, models.Chat.user_id == current_user.username).first()
    if not chat:
        raise HTTPException(status_code=404, detail="Chat not found")
    return chat

@router.delete("/{chat_id}")
def delete_chat(chat_id: int, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    chat = db.query(models.Chat).filter(models.Chat.id == chat_id, models.Chat.user_id == current_user.username).first()
    if not chat:
        raise HTTPException(status_code=404, detail="Chat not found")
    db.delete(chat)
    db.commit()
    return {"message": "Chat deleted"}

@router.patch("/{chat_id}", response_model=schemas.Chat)
def update_chat(chat_id: int, chat_update: schemas.ChatUpdate, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    chat = db.query(models.Chat).filter(models.Chat.id == chat_id, models.Chat.user_id == current_user.username).first()
    if not chat:
        raise HTTPException(status_code=404, detail="Chat not found")
    
    if chat_update.title is not None:
        chat.title = chat_update.title
    if chat_update.is_pinned is not None:
        chat.is_pinned = chat_update.is_pinned
        
    db.commit()
    db.refresh(chat)
    return chat
