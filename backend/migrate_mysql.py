from sqlalchemy import text
from app.core.database import engine

def migrate():
    try:
        with engine.connect() as connection:
            print("Connected to MySQL database. Attempting migration...")
            # Use text() for raw SQL execution in SQLAlchemy 2.0+
            connection.execute(text("ALTER TABLE messages ADD COLUMN attachments JSON;"))
            connection.commit()
            print("Success: Column 'attachments' added to 'messages' table.")
    except Exception as e:
        if "Duplicate column name" in str(e):
            print("Notice: Column 'attachments' already exists.")
        else:
            print(f"Error during migration: {e}")

if __name__ == "__main__":
    migrate()
