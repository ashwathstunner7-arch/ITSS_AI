import os
import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from app.core.config import settings
from app.models.models import User

engine = create_engine(settings.DATABASE_URL)
SessionLocal = sessionmaker(bind=engine)
db = SessionLocal()

try:
    users = db.query(User).all()
    print(f"Found {len(users)} users:")
    for user in users:
        print(f"ID: {user.id}, Username: {user.username}, Status: {user.status}")
except Exception as e:
    print(f"Error: {e}")
finally:
    db.close()
