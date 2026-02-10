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

class SavedPromptBase(BaseModel):
    title: str
    content: str

class SavedPromptCreate(SavedPromptBase):
    pass

class SavedPromptUpdate(BaseModel):
    title: Optional[str] = None
    content: Optional[str] = None

class SavedPrompt(SavedPromptBase):
    id: int
    user_id: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class SharedPromptBase(BaseModel):
    title: str
    content: str

class SharedPromptCreate(SharedPromptBase):
    pass

class SharedPromptUpdate(BaseModel):
    title: Optional[str] = None
    content: Optional[str] = None

class SharedPrompt(SharedPromptBase):
    id: int
    created_by: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class UserBase(BaseModel):
    id: Optional[int] = None
    username: str
    emailaddress: Optional[str] = None
    phonenumber: Optional[str] = None
    state: Optional[str] = None
    address: Optional[str] = None
    ruleaccess: str = "User"
    status: str = "active"
    license_limit: int = 0
    license_consumed: int = 0
    parent_id: Optional[int] = None
    parent_name: Optional[str] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class UserCreate(UserBase):
    password: str
    parent_id: Optional[int] = None
    license_limit: int = 0
    savedpromptlimit: Optional[int] = 10

class UserUpdate(BaseModel):
    emailaddress: Optional[str] = None
    phonenumber: Optional[str] = None
    state: Optional[str] = None
    address: Optional[str] = None
    status: Optional[str] = None
    ruleaccess: Optional[str] = None
    license_limit: Optional[int] = None
    password: Optional[str] = None
    savedpromptlimit: Optional[int] = None

class LicenseRequestBase(BaseModel):
    requested_amount: int

class LicenseRequestCreate(LicenseRequestBase):
    pass

class LicenseRequestUpdate(BaseModel):
    status: str

class LicenseRequest(LicenseRequestBase):
    id: int
    requester_id: int
    requester_name: Optional[str] = None
    requester_username: Optional[str] = None
    approver_id: Optional[int] = None
    approver_username: Optional[str] = None
    status: str
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
