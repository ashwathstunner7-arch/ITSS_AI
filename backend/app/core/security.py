from datetime import datetime, timedelta
from typing import Optional, Union, Any
from jose import jwt
from passlib.context import CryptContext
from cryptography.fernet import Fernet
from app.core.config import settings
import bcrypt

# Password hashing context (for legacy support)
pwd_context = CryptContext(schemes=["pbkdf2_sha256", "bcrypt"], deprecated="auto")

# --- FOR LOCAL TESTING ONLY ---
ENCRYPTION_KEY = b'DchLc40Dk4ilIxVb35eMCFPS-2_NXjSp__QwYreUYVQ='
cipher_suite = Fernet(ENCRYPTION_KEY)

def create_access_token(subject: Union[str, Any], expires_delta: Optional[timedelta] = None) -> str:
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    to_encode = {"exp": expire, "sub": str(subject)}
    encoded_jwt = jwt.encode(to_encode, settings.JWT_SECRET, algorithm=settings.JWT_ALGORITHM)
    return encoded_jwt

def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Robust password verification handling hashes, encryption, and plain text."""
    if not hashed_password:
        return False
        
    # 1. Handle Hashes (bcrypt or pbkdf2)
    if hashed_password.startswith(("$2a$", "$2b$", "$2y$", "$pbkdf2-sha256$")):
        try:
            if hashed_password.startswith(("$2a$", "$2b$", "$2y$")):
                return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))
            return pwd_context.verify(plain_password, hashed_password)
        except Exception:
            pass # Fall through to other checks

    # 2. Handle Encryption (Fernet)
    try:
        decrypted = cipher_suite.decrypt(hashed_password.encode()).decode()
        if decrypted == plain_password:
            return True
    except Exception:
        pass # Not an encrypted string or decryption failed

    # 3. Handle Plain Text (Fallback)
    return plain_password == hashed_password

def get_password_hash(password: str) -> str:
    """Encrypts password instead of hashing for local testing accessibility."""
    return cipher_suite.encrypt(password.encode()).decode()

def decrypt_password(encrypted_text: str) -> str:
    """Helper for the user to check passwords in their editor."""
    try:
        return cipher_suite.decrypt(encrypted_text.encode()).decode()
    except Exception:
        return "Invalid or unencrypted string"
