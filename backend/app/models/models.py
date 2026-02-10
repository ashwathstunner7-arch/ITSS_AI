from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Text, JSON
from sqlalchemy.orm import relationship
from datetime import datetime
from app.core.database import Base

class User(Base):
    __tablename__ = "USER"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(255), unique=True, index=True)
    password = Column(String(255))
    status = Column(String(50), default="active")
    ruleaccess = Column(String(255), default="User") # Primary field for permissions (Super Admin, Admin, Sub-Admin, User)
    parent_id = Column(Integer, ForeignKey("USER.id"), nullable=True)
    license_limit = Column(Integer, default=0)
    license_consumed = Column(Integer, default=0)
    phonenumber = Column(String(20))
    emailaddress = Column(String(255))
    state = Column(String(100))
    address = Column(Text)
    savedpromptlimit = Column(Integer)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    chats = relationship("Chat", back_populates="owner")
    children = relationship("User", backref="parent", remote_side=[id])

class LicenseRequest(Base):
    __tablename__ = "license_requests"

    id = Column(Integer, primary_key=True, index=True)
    requester_id = Column(Integer, ForeignKey("USER.id", ondelete="CASCADE"))
    requester_username = Column(String(255))
    approver_id = Column(Integer, ForeignKey("USER.id"), nullable=True)
    approver_username = Column(String(255), nullable=True)
    requested_amount = Column(Integer)
    status = Column(String(50), default="pending") # pending, approved, rejected
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    requester = relationship("User", foreign_keys=[requester_id])

class Chat(Base):
    __tablename__ = "chats"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    user_id = Column(String(255), ForeignKey("USER.username"))
    is_pinned = Column(Boolean, default=False)

    owner = relationship("User", back_populates="chats")
    messages = relationship("Message", back_populates="chat", cascade="all, delete-orphan")

class Message(Base):
    __tablename__ = "messages"

    id = Column(Integer, primary_key=True, index=True)
    role = Column(String(50)) # 'user' or 'bot'
    user_id = Column(String(255), ForeignKey("USER.username"))
    content = Column(Text)
    attachments = Column(JSON) # Store as JSON
    created_at = Column(DateTime, default=datetime.utcnow)
    chat_id = Column(Integer, ForeignKey("chats.id"))

    chat = relationship("Chat", back_populates="messages")

class Rule(Base):
    __tablename__ = "RULES"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255))
    description = Column(Text)
    rule_content = Column(Text)
    created_by = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    status = Column(String(50), default="active")
    version = Column(String(20), default="1.0")
    category = Column(String(100))
    priority = Column(String(20))

class SavedPrompt(Base):
    __tablename__ = "SAVED_PROMPTS"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255))
    content = Column(Text)
    user_id = Column(String(255), ForeignKey("USER.username"))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

class SharedPrompt(Base):
    __tablename__ = "SHARED_PROMPTS"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255))
    content = Column(Text)
    created_by = Column(String(255)) # Admin username
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
