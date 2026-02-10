from app.core.database import SessionLocal
from app.models import models
from app.core import security

def create_super_admin():
    db = SessionLocal()
    try:
        username = "tester_super_admin"
        password = "AdminPassword123"
        
        existing = db.query(models.User).filter(models.User.username == username).first()
        if existing:
            print(f"User {username} already exists.")
            return

        new_admin = models.User(
            username=username,
            password=security.get_password_hash(password),
            ruleaccess="Super Admin",
            status="active",
            license_limit=999,
            license_consumed=0,
            emailaddress="tester@example.com"
        )
        db.add(new_admin)
        db.commit()
        print(f"Super Admin created: {username} / {password}")
    finally:
        db.close()

if __name__ == "__main__":
    create_super_admin()
