from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

class RuleBase(BaseModel):
    title: str
    description: str
    rule_content: Optional[str] = None
    created_by: Optional[str] = None
    status: str = "active"
    version: Optional[str] = None
    category: Optional[str] = None
    priority: Optional[str] = "medium"

class RuleCreate(RuleBase):
    pass

class RuleUpdate(BaseModel):
    title: Optional[str] = None
    description: Optional[str] = None
    rule_content: Optional[str] = None
    status: Optional[str] = None
    version: Optional[str] = None
    category: Optional[str] = None
    priority: Optional[str] = None

class Rule(RuleBase):
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class MessageBase(BaseModel):
    role: str
    content: str
    attachments: Optional[List[dict]] = None

class MessageCreate(MessageBase):
    chat_id: int

class Message(MessageBase):
    id: int
    chat_id: int
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
    attachments: Optional[List[dict]] = None
    provider: Optional[str] = "gemini"
    model: Optional[str] = None
