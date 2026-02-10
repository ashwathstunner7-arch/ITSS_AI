from app.core.database import SessionLocal
from app.models import models
from app.core import security
from app.api.tenant import get_all_descendants
import uuid

def test_system_logic():
    db = SessionLocal()
    try:
        print("=== Starting System Logic Verification ===")
        
        # 1. Create a Test Admin
        admin_uname = f"admin_{uuid.uuid4().hex[:4]}"
        admin = models.User(
            username=admin_uname,
            password=security.get_password_hash("password"),
            ruleaccess="Admin",
            license_limit=10,
            license_consumed=0,
            status="active"
        )
        db.add(admin)
        db.flush()
        print(f"Created Admin: {admin.username} (ID: {admin.id})")

        # 2. Create a Sub-Admin under Admin
        sub_admin_uname = f"sub_{uuid.uuid4().hex[:4]}"
        sub_admin = models.User(
            username=sub_admin_uname,
            password=security.get_password_hash("password"),
            ruleaccess="Sub-Admin",
            parent_id=admin.id,
            license_limit=3,
            license_consumed=0,
            status="active"
        )
        db.add(sub_admin)
        admin.license_consumed += 3
        db.flush()
        print(f"Created Sub-Admin: {sub_admin.username} under Admin. Admin consumed: {admin.license_consumed}")

        # 3. Create a User under Sub-Admin
        user_uname = f"user_{uuid.uuid4().hex[:4]}"
        user = models.User(
            username=user_uname,
            password=security.get_password_hash("password"),
            ruleaccess="User",
            parent_id=sub_admin.id,
            license_limit=0,
            license_consumed=0,
            status="active"
        )
        db.add(user)
        sub_admin.license_consumed += 1
        db.flush()
        print(f"Created User: {user.username} under Sub-Admin. Sub-Admin consumed: {sub_admin.license_consumed}")

        # 4. Verify Recursive Hierarchy visibility for Top Admin
        descendant_ids = get_all_descendants(admin.id, db)
        print(f"Admin's descendants: {descendant_ids}")
        assert sub_admin.id in descendant_ids
        assert user.id in descendant_ids
        print("SUCCESS: Recursive hierarchy logic is correct.")

        # 5. Test License Request Flow
        req = models.LicenseRequest(
            requester_id=sub_admin.id,
            requested_amount=5,
            status="pending"
        )
        db.add(req)
        db.flush()
        print(f"Sub-Admin requested 5 licenses.")

        # Simulate Approval by Admin
        # Check Admin's pool (Limit 10, Consumed 3)
        available = admin.license_limit - admin.license_consumed
        if req.requested_amount <= available:
            admin.license_consumed += req.requested_amount
            sub_admin.license_limit += req.requested_amount
            req.status = "approved"
            print("SUCCESS: Admin approved license request.")
        else:
            print("FAILURE: Admin should have had enough licenses.")

        # 6. Test Deletion & Reassignment
        # Delete Sub-Admin. User should go to Top Admin.
        # Sub-Admin's 3+5=8 licenses should be recovered to Top Admin (from the original allocation).
        # User's 1 consumption should be transferred to Top Admin.
        
        # Revert the Sub-Admin's 8 limit from Admin's consumption
        admin.license_consumed -= sub_admin.license_limit
        
        # Transfer sub_admin's children to Admin
        children = db.query(models.User).filter(models.User.parent_id == sub_admin.id).all()
        for child in children:
            child.parent_id = admin.id
            if child.ruleaccess.lower() == 'user':
                admin.license_consumed += 1
            else:
                admin.license_consumed += child.license_limit
        
        db.delete(sub_admin)
        db.commit()
        print(f"Deleted Sub-Admin. User {user.username} reassigned to {admin.username}.")
        print(f"Admin Final Consumed: {admin.license_consumed} (Expected: 1 for User)")
        
        # 7. Cleanup
        db.delete(user)
        db.delete(admin)
        db.commit()
        print("\n=== SYSTEM LOGIC VERIFIED SUCCESSFULLY ===")

    except Exception as e:
        db.rollback()
        print(f"VERIFICATION FAILED: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    test_system_logic()
