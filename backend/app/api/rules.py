from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.models import models
from app.schemas import schemas
from app.api.deps import get_admin_user

router = APIRouter()

@router.get("/", response_model=List[schemas.Rule])
def get_rules(db: Session = Depends(get_db)):
    return db.query(models.Rule).all()

@router.post("/", response_model=schemas.Rule)
def create_rule(
    rule: schemas.RuleCreate, 
    db: Session = Depends(get_db),
    admin_user: models.User = Depends(get_admin_user)
):
    db_rule = models.Rule(**rule.model_dump())
    db.add(db_rule)
    db.commit()
    db.refresh(db_rule)
    
    # Generate .md file
    import os
    storage_path = "rules_storage"
    if not os.path.exists(storage_path):
        os.makedirs(storage_path)
    
    filename = f"rule_{db_rule.id}.md"
    file_path = os.path.join(storage_path, filename)
    
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(f"# {db_rule.title}\n\n")
        f.write(f"**Category:** {db_rule.category}\n")
        f.write(f"**Version:** {db_rule.version}\n")
        f.write(f"**Priority:** {db_rule.priority}\n")
        f.write(f"**Description:** {db_rule.description}\n\n")
        f.write("## Rule Content\n")
        f.write(db_rule.rule_content or "No content provided.")
        
    return db_rule

@router.patch("/{rule_id}", response_model=schemas.Rule)
def update_rule(
    rule_id: int, 
    rule_update: schemas.RuleUpdate, 
    db: Session = Depends(get_db),
    admin_user: models.User = Depends(get_admin_user)
):
    db_rule = db.query(models.Rule).filter(models.Rule.id == rule_id).first()
    if not db_rule:
        raise HTTPException(status_code=404, detail="Rule not found")
    
    update_data = rule_update.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(db_rule, key, value)
    
    db.commit()
    db.refresh(db_rule)
    return db_rule

@router.delete("/{rule_id}")
def delete_rule(
    rule_id: int, 
    db: Session = Depends(get_db),
    admin_user: models.User = Depends(get_admin_user)
):
    db_rule = db.query(models.Rule).filter(models.Rule.id == rule_id).first()
    if not db_rule:
        raise HTTPException(status_code=404, detail="Rule not found")
    db.delete(db_rule)
    db.commit()
    return {"message": "Rule deleted"}
