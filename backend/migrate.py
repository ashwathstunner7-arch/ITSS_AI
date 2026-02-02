import sqlite3
import os

db_path = r'f:\AI_TOOL\backend\itss_ai.db'
if os.path.exists(db_path):
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        cursor.execute("ALTER TABLE messages ADD COLUMN attachments JSON;")
        conn.commit()
        conn.close()
        print("Success: Column 'attachments' added to 'messages' table.")
    except sqlite3.OperationalError as e:
        if "duplicate column name" in str(e):
            print("Notice: Column 'attachments' already exists.")
        else:
            print(f"Error: {e}")
    except Exception as e:
        print(f"Unexpected Error: {e}")
else:
    print("Notice: Database file not found. It will be created with the new schema on next start.")
