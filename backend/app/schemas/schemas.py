from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

class RuleBase(BaseModel):
    title: str
    description: str
    enabled: bool = True
    type: str

class RuleCreate(RuleBase):
    pass

class Rule(RuleBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

class MessageBase(BaseModel):
    role: str
    content: str

class MessageCreate(MessageBase):
    chat_id: int

class Message(MessageBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

class ChatBase(BaseModel):
    title: str

class ChatCreate(ChatBase):
    user_id: Optional[int] = None

class ChatUpdate(BaseModel):
    title: str

class Chat(ChatBase):
    id: int
    created_at: datetime
    messages: List[Message] = []

    class Config:
        from_attributes = True

class InvokeRequest(BaseModel):
    message: str
    chat_id: Optional[int] = None
    rules_applied: List[int] = []
    provider: Optional[str] = "gemini"
    model: Optional[str] = None
