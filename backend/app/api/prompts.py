from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.models import models
from app.schemas import schemas
from app.api.deps import get_current_user, get_admin_user, check_can_add_prompt

router = APIRouter()

# --- My Prompts ---

@router.get("/my", response_model=List[schemas.SavedPrompt])
def get_my_prompts(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    return db.query(models.SavedPrompt).filter(models.SavedPrompt.user_id == current_user.username).all()

@router.post("/my", response_model=schemas.SavedPrompt)
def create_my_prompt(
    prompt: schemas.SavedPromptCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(check_can_add_prompt)
):
    # Check storage limit
    limit = current_user.savedpromptlimit or 10 # Default limit 10 if not set
    current_count = db.query(models.SavedPrompt).filter(models.SavedPrompt.user_id == current_user.username).count()
    
    if current_count >= limit:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Storage limit reached ({limit} prompts allowed)."
        )
    
    db_prompt = models.SavedPrompt(**prompt.model_dump(), user_id=current_user.username)
    db.add(db_prompt)
    db.commit()
    db.refresh(db_prompt)
    return db_prompt

@router.patch("/my/{prompt_id}", response_model=schemas.SavedPrompt)
def update_my_prompt(
    prompt_id: int,
    prompt_update: schemas.SavedPromptUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    db_prompt = db.query(models.SavedPrompt).filter(
        models.SavedPrompt.id == prompt_id,
        models.SavedPrompt.user_id == current_user.username
    ).first()
    
    if not db_prompt:
        raise HTTPException(status_code=404, detail="Prompt not found")
    
    update_data = prompt_update.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_prompt, key, value)
    
    db.commit()
    db.refresh(db_prompt)
    return db_prompt

@router.delete("/my/{prompt_id}")
def delete_my_prompt(
    prompt_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    db_prompt = db.query(models.SavedPrompt).filter(
        models.SavedPrompt.id == prompt_id,
        models.SavedPrompt.user_id == current_user.username
    ).first()
    
    if not db_prompt:
        raise HTTPException(status_code=404, detail="Prompt not found")
    
    db.delete(db_prompt)
    db.commit()
    return {"message": "Prompt deleted"}

# --- Shared Prompts ---

@router.get("/shared", response_model=List[schemas.SharedPrompt])
def get_shared_prompts(db: Session = Depends(get_db)):
    return db.query(models.SharedPrompt).all()

@router.post("/shared", response_model=schemas.SharedPrompt)
def create_shared_prompt(
    prompt: schemas.SharedPromptCreate,
    db: Session = Depends(get_db),
    admin_user: models.User = Depends(get_admin_user)
):
    db_prompt = models.SharedPrompt(**prompt.model_dump(), created_by=admin_user.username)
    db.add(db_prompt)
    db.commit()
    db.refresh(db_prompt)
    return db_prompt

@router.patch("/shared/{prompt_id}", response_model=schemas.SharedPrompt)
def update_shared_prompt(
    prompt_id: int,
    prompt_update: schemas.SharedPromptUpdate,
    db: Session = Depends(get_db),
    admin_user: models.User = Depends(get_admin_user)
):
    db_prompt = db.query(models.SharedPrompt).filter(models.SharedPrompt.id == prompt_id).first()
    
    if not db_prompt:
        raise HTTPException(status_code=404, detail="Shared prompt not found")
    
    update_data = prompt_update.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_prompt, key, value)
    
    db.commit()
    db.refresh(db_prompt)
    return db_prompt

@router.delete("/shared/{prompt_id}")
def delete_shared_prompt(
    prompt_id: int,
    db: Session = Depends(get_db),
    admin_user: models.User = Depends(get_admin_user)
):
    db_prompt = db.query(models.SharedPrompt).filter(models.SharedPrompt.id == prompt_id).first()
    
    if not db_prompt:
        raise HTTPException(status_code=404, detail="Shared prompt not found")
    
    db.delete(db_prompt)
    db.commit()
    return {"message": "Shared prompt deleted"}
