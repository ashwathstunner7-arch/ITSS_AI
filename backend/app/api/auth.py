from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models import models
from app.schemas import schemas
from app.core import security
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import jwt, JWTError
from app.core.config import settings

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="auth/login")

@router.post("/login")
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    print(f"DEBUG: Login attempt for username: {form_data.username}")
    
    # Try case-insensitive lookup
    user = db.query(models.User).filter(models.User.username.ilike(form_data.username)).first()
    
    if not user:
        print(f"DEBUG: User {form_data.username} not found in database.")
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    
    print(f"DEBUG: User found: {user.username}, Status: {user.status}")
    
    # Verify password
    is_valid = False
    try:
        is_valid = security.verify_password(form_data.password, user.password)
        print(f"DEBUG: Hashed password verification: {is_valid}")
    except Exception as e:
        print(f"DEBUG: Hashed verification failed/errored: {e}")
        # Fallback for plain text
        is_valid = (form_data.password == user.password)
        print(f"DEBUG: Plain text password verification: {is_valid}")

    if not is_valid:
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    
    # Check active status
    if user.status.lower() != "active":
        print(f"DEBUG: User account {user.username} is {user.status}, not active.")
        raise HTTPException(status_code=400, detail="User account is inactive")
    
    print(f"DEBUG: Login successful for {user.username}")
    access_token = security.create_access_token(subject=user.username)
    return {"access_token": access_token, "token_type": "bearer"}

from app.api.deps import get_current_user

@router.get("/me")
async def get_me(user: models.User = Depends(get_current_user)):
    return {
        "id": user.id,
        "username": user.username,
        "status": user.status,
        "ruleaccess": user.ruleaccess,
        "emailaddress": user.emailaddress
    }
