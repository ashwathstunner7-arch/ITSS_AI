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
    user_id: str

class Message(MessageBase):
    id: int
    chat_id: int
    user_id: str
    created_at: datetime

    class Config:
        from_attributes = True

class ChatBase(BaseModel):
    title: str

class ChatCreate(ChatBase):
    user_id: Optional[str] = None

class ChatUpdate(BaseModel):
    title: Optional[str] = None
    is_pinned: Optional[bool] = None

class MessageUpdate(BaseModel):
    content: str
    stream: Optional[bool] = False
    provider: Optional[str] = "gemini"
    model: Optional[str] = None
    rules_applied: List[int] = []

class Chat(ChatBase):
    id: int
    is_pinned: bool = False
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
    stream: Optional[bool] = False
