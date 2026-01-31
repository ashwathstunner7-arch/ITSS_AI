from sqlalchemy import create_engine, text
from app.core.config import settings

engine = create_engine(settings.DATABASE_URL)

with engine.connect() as connection:
    result = connection.execute(text("SELECT username, password FROM USER WHERE username = 'Ashwath'"))
    row = result.fetchone()
    if row:
        username, password = row
        is_hashed = password.startswith('$2b$') or len(password) > 30 # Simple check for bcrypt
        print(f"Username: {username}, Password Length: {len(password)}, Looks Hashed: {is_hashed}")
    else:
        print("User 'Ashwath' not found.")
