from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.models import models
from app.schemas import schemas
from app.api.deps import get_current_user, get_admin_user, get_super_admin
from app.core import security

router = APIRouter()

# --- User Management ---

def get_all_descendants(user_id: int, db: Session) -> List[int]:
    all_ids = []
    children_ids = db.query(models.User.id).filter(models.User.parent_id == user_id).all()
    children_ids = [cid[0] for cid in children_ids]
    all_ids.extend(children_ids)
    for cid in children_ids:
        all_ids.extend(get_all_descendants(cid, db))
    return all_ids

@router.get("/users", response_model=List[schemas.UserBase])
async def get_users(
    db: Session = Depends(get_db), 
    current_user: models.User = Depends(get_admin_user)
):
    """
    Super Admin sees all users.
    Admin/Sub-Admin sees only their hierarchy.
    """
    users = []
    if current_user.ruleaccess.lower() == "super admin":
        users = db.query(models.User).all()
    else:
        descendant_ids = get_all_descendants(current_user.id, db)
        users = db.query(models.User).filter(models.User.id.in_(descendant_ids)).all()
    
    # Enrichment
    result = []
    for u in users:
        parent = db.query(models.User).filter(models.User.id == u.parent_id).first()
        u_dict = schemas.UserBase.model_validate(u).model_dump()
        u_dict["parent_name"] = parent.username if parent else "System"
        result.append(u_dict)
    
    return result

@router.post("/users")
async def create_sub_user(
    user_data: schemas.UserCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_admin_user)
):
    # Authorization constraints
    curr_role = (current_user.ruleaccess or "").lower()
    new_role = (user_data.ruleaccess or "").lower()

    if curr_role == "admin":
        if new_role not in ["admin", "user"]:
            raise HTTPException(status_code=403, detail="Admins can only create Admins or Users")
    elif curr_role == "super admin":
        if new_role not in ["super admin", "admin", "user"]:
            raise HTTPException(status_code=403, detail="Super Admins can only create Super Admins, Admins, or Users")
    
    # License check: If creating a User OR an Admin (who consumes pool), ensure parent has enough credits
    # Actually, as per user's request: "share the lisneces... share his lisnece"
    # End Users (User) consume 1 license.
    # Admins/Sub-Admins (who can create others) consume the license_limit allocated to them.
    
    if new_role == "user":
        if current_user.license_limit <= current_user.license_consumed:
            raise HTTPException(status_code=400, detail="Insufficient license credits to create user")
        current_user.license_consumed += 1

    # If creating another Admin/Sub-Admin with a limit, check availability
    if new_role in ["admin", "sub-admin", "super admin"] and user_data.license_limit > 0:
        available = current_user.license_limit - current_user.license_consumed
        if user_data.license_limit > available:
            raise HTTPException(status_code=400, detail=f"Insufficient credits. Available: {available}")
        current_user.license_consumed += user_data.license_limit

    new_user = models.User(
        username=user_data.username,
        password=security.get_password_hash(user_data.password),
        emailaddress=user_data.emailaddress,
        phonenumber=user_data.phonenumber,
        state=user_data.state,
        address=user_data.address,
        ruleaccess=user_data.ruleaccess,
        parent_id=current_user.id,
        license_limit=user_data.license_limit if new_role != "user" else 0,
        savedpromptlimit=user_data.savedpromptlimit,
        status="active"
    )
    
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    # Automatically create an approved license request for tracking
    if new_user.license_limit > 0:
        auto_req = models.LicenseRequest(
            requester_id=new_user.id,
            requester_username=new_user.username,
            approver_id=current_user.id,
            approver_username=current_user.username,
            requested_amount=new_user.license_limit,
            status="approved"
        )
        db.add(auto_req)
        db.commit()

    return new_user

@router.patch("/users/{user_id}", response_model=schemas.UserBase)
async def update_user(
    user_id: int,
    user_data: schemas.UserUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_admin_user)
):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Check hierarchy: Admin can manage all descendants
    is_descendant = False
    if current_user.ruleaccess.lower() != 'super admin':
        descendant_ids = get_all_descendants(current_user.id, db)
        if user_id in descendant_ids:
            is_descendant = True
    
    if not is_descendant and current_user.ruleaccess.lower() != 'super admin':
        raise HTTPException(status_code=403, detail="You can only manage users in your hierarchy")

    update_data = user_data.model_dump(exclude_unset=True)
    
    new_role_val = update_data.get("ruleaccess", user.ruleaccess)
    if new_role_val.lower() != user.ruleaccess.lower():
        old_role = user.ruleaccess.lower()
        new_role = new_role_val.lower()
        parent = db.query(models.User).filter(models.User.id == user.parent_id).first()
        
        if parent:
            # Revert old consumption
            if old_role == 'user':
                parent.license_consumed -= 1
            else:
                parent.license_consumed -= user.license_limit
            
            # Apply new consumption
            if new_role == 'user':
                if parent.license_limit - parent.license_consumed < 1:
                    raise HTTPException(status_code=400, detail="Insufficient credits in parent for this role change")
                parent.license_consumed += 1
            else:
                # Use current limit or updated limit
                target_limit = update_data.get("license_limit", user.license_limit)
                if parent.license_limit - parent.license_consumed < target_limit:
                    raise HTTPException(status_code=400, detail=f"Insufficient credits in parent for {new_role} role")
                parent.license_consumed += target_limit

    elif "license_limit" in update_data and user.ruleaccess.lower() != 'user':
        # Limit change for non-user roles (Users always consume 1)
        old_limit = user.license_limit
        new_limit = update_data["license_limit"]
        diff = new_limit - old_limit
        
        if diff != 0:
            parent = db.query(models.User).filter(models.User.id == user.parent_id).first()
            if parent:
                # If increasing, check parent's available pool
                if diff > 0:
                    available = parent.license_limit - parent.license_consumed
                    if diff > available:
                        raise HTTPException(status_code=400, detail=f"Insufficient credits in parent {parent.username}. Available: {available}")
                    parent.license_consumed += diff
                else:
                    # Decreasing, return to parent. 
                    # Ensure they aren't trying to reduce below what the user's children are already consuming
                    if new_limit < user.license_consumed:
                         raise HTTPException(status_code=400, detail=f"Cannot reduce limit below consumed amount ({user.license_consumed})")
                    parent.license_consumed += diff
            
    if "password" in update_data and update_data["password"]:
        from app.core import security
        user.password = security.get_password_hash(update_data["password"])
        del update_data["password"]

    old_username = user.username
    for key, value in update_data.items():
        setattr(user, key, value)
    
    # Sync username in license requests if changed (both as requester and approver)
    if user.username != old_username:
        db.query(models.LicenseRequest).filter(models.LicenseRequest.requester_id == user.id).update(
            {models.LicenseRequest.requester_username: user.username}
        )
        db.query(models.LicenseRequest).filter(models.LicenseRequest.approver_id == user.id).update(
            {models.LicenseRequest.approver_username: user.username}
        )

    # Sync license_limit with requests if changed
    if "license_limit" in update_data:
        latest_req = db.query(models.LicenseRequest).filter(
            models.LicenseRequest.requester_id == user.id,
            models.LicenseRequest.status == "approved"
        ).order_by(models.LicenseRequest.updated_at.desc()).first()
        
        if latest_req:
            latest_req.requested_amount = user.license_limit
    
    db.commit()
    db.refresh(user)
    return user

@router.delete("/users/{user_id}")
async def delete_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_admin_user)
):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Check hierarchy: Admin can delete all descendants
    is_descendant = False
    if current_user.ruleaccess.lower() != 'super admin':
        descendant_ids = get_all_descendants(current_user.id, db)
        if user_id in descendant_ids:
            is_descendant = True
            
    if not is_descendant and current_user.ruleaccess.lower() != 'super admin':
        raise HTTPException(status_code=403, detail="You can only delete users in your hierarchy")

    # Recover licenses to actual parent
    parent = db.query(models.User).filter(models.User.id == user.parent_id).first()
    if parent:
        # 1. Recover the deleted user's own consumption from the parent
        if user.ruleaccess.lower() == 'user':
            parent.license_consumed -= 1
        else:
            parent.license_consumed -= user.license_limit
            
        # 2. Transfer consumption of all reassigning sub-users to the parent
        sub_users = db.query(models.User).filter(models.User.parent_id == user.id).all()
        for sub in sub_users:
            if sub.ruleaccess.lower() == 'user':
                parent.license_consumed += 1
            else:
                parent.license_consumed += sub.license_limit
            sub.parent_id = user.parent_id
        
    db.delete(user)
    db.commit()
    return {"message": "User deleted, sub-users reassigned, and licenses balanced"}

# --- License Management ---

@router.post("/licenses/allocate")
async def allocate_licenses(
    target_user_id: int,
    amount: int,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_admin_user)
):
    target = db.query(models.User).filter(models.User.id == target_user_id, models.User.parent_id == current_user.id).first()
    if not target:
        raise HTTPException(status_code=404, detail="Target user not found in your hierarchy")
    
    target_role = (target.ruleaccess or "").lower()
    if target_role == "user":
        raise HTTPException(status_code=400, detail="Cannot allocate license pool to an end user")

    available = current_user.license_limit - current_user.license_consumed
    if amount > available:
        raise HTTPException(status_code=400, detail=f"Insufficient credits. Available: {available}")

    current_user.license_consumed += amount
    target.license_limit += amount
    
    db.commit()
    return {"message": "Licenses allocated successfully"}

@router.post("/licenses/request")
async def request_licenses(
    request_data: schemas.LicenseRequestCreate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user)
):
    if current_user.ruleaccess == "Super Admin":
        raise HTTPException(status_code=400, detail="Super Admin does not need to request licenses")
    
    new_request = models.LicenseRequest(
        requester_id=current_user.id,
        requester_username=current_user.username,
        requested_amount=request_data.requested_amount,
        status="pending"
    )
    db.add(new_request)
    db.commit()
    return {"message": "License request submitted"}

@router.get("/licenses/requests")
async def get_license_requests(
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_admin_user)
):
    """
    Super Admin sees all requests.
    Admin sees requests made BY their direct sub-users.
    """
    if current_user.ruleaccess.lower() == "super admin":
        reqs = db.query(models.LicenseRequest).all()
    else:
        # Get IDs of all direct sub-users
        sub_user_ids = [u.id for u in db.query(models.User.id).filter(models.User.parent_id == current_user.id).all()]
        reqs = db.query(models.LicenseRequest).filter(models.LicenseRequest.requester_id.in_(sub_user_ids)).all()
    
    # Enrichment
    result = []
    for r in reqs:
        result.append({
            "id": r.id,
            "requester_id": r.requester_id,
            "requester_name": r.requester_username or "Unknown",
            "approver_id": r.approver_id,
            "approver_name": r.approver_username,
            "requested_amount": r.requested_amount,
            "status": r.status,
            "created_at": r.created_at,
            "updated_at": r.updated_at
        })
    return result

@router.patch("/licenses/requests/{req_id}")
async def process_license_request(
    req_id: int,
    process_data: schemas.LicenseRequestUpdate,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_admin_user)
):
    req = db.query(models.LicenseRequest).filter(models.LicenseRequest.id == req_id).first()
    if not req:
        raise HTTPException(status_code=404, detail="Request not found")
    
    if req.status != "pending":
        raise HTTPException(status_code=400, detail="Request has already been processed")

    requester = db.query(models.User).filter(models.User.id == req.requester_id).first()
    if not requester:
        raise HTTPException(status_code=404, detail="Requester not found")

    # Hierarchy check
    if requester.parent_id != current_user.id and current_user.ruleaccess.lower() != 'super admin':
        raise HTTPException(status_code=403, detail="You can only process requests from your direct children")
    
    if process_data.status == "approved":
        # License check (if Super Admin, they have infinite pool conceptually here, 
        # but let's assume they also have a limit they manage)
        available = current_user.license_limit - current_user.license_consumed
        if req.requested_amount > available and current_user.ruleaccess.lower() != 'super admin':
             raise HTTPException(status_code=400, detail=f"Insufficient credits in your pool. Available: {available}")
        
        current_user.license_consumed += req.requested_amount
        requester.license_limit += req.requested_amount
        req.status = "approved"
    else:
        req.status = "rejected"
        
    req.approver_id = current_user.id
    req.approver_username = current_user.username
    db.commit()
    return {"message": f"Request {process_data.status}"}
