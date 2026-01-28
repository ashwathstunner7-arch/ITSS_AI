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
    user = db.query(models.User).filter(models.User.UserName.ilike(form_data.username)).first()
    
    if not user:
        print(f"DEBUG: User {form_data.username} not found in database.")
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    
    print(f"DEBUG: User found: {user.UserName}, Status: {user.status}")
    
    # Verify password (try hashed first, if it fails, check plain if that's what's in DB)
    is_valid = False
    try:
        is_valid = security.verify_password(form_data.password, user.password)
        print(f"DEBUG: Hashed password verification: {is_valid}")
    except Exception as e:
        print(f"DEBUG: Hashed verification failed/errored: {e}")
        # Fallback for plain text if migration is in progress
        is_valid = (form_data.password == user.password)
        print(f"DEBUG: Plain text password verification: {is_valid}")

    if not is_valid:
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    
    # Check active status (case-insensitive)
    if user.status.lower() != "active":
        print(f"DEBUG: User account {user.UserName} is {user.status}, not active.")
        raise HTTPException(status_code=400, detail="User account is inactive")
    
    print(f"DEBUG: Login successful for {user.UserName}")
    access_token = security.create_access_token(subject=user.id)
    return {"access_token": access_token, "token_type": "bearer"}

@router.get("/me")
async def get_me(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    try:
        payload = jwt.decode(token, settings.JWT_SECRET, algorithms=[settings.JWT_ALGORITHM])
        user_id = payload.get("sub")
        if user_id is None:
            raise HTTPException(status_code=401, detail="Invalid token")
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    user = db.query(models.User).filter(models.User.id == int(user_id)).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    return {
        "id": user.id,
        "UserName": user.UserName,
        "status": user.status
    }
