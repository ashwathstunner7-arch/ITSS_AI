from app.core.database import SessionLocal
from app.models import models

def check_users():
    db = SessionLocal()
    users = db.query(models.User).all()
    print(f"Total users: {len(users)}")
    for u in users:
        pw_start = u.password[:15] if u.password else "None"
        print(f"ID: {u.id} | User: {u.username} | Status: {u.status} | PW Start: {pw_start}...")
    db.close()

if __name__ == "__main__":
    check_users()
