import sqlite3
import os

db_path = r'f:\AI_TOOL\backend\itss_ai.db'
output_path = r'f:\AI_TOOL\backend\database_dump.sql'

if not os.path.exists(db_path):
    print(f"Error: Database file not found at {db_path}")
    exit(1)

try:
    conn = sqlite3.connect(db_path)
    # Using the iterdump() method to get all SQL commands to recreate the database
    with open(output_path, 'w', encoding='utf-8') as f:
        for line in conn.iterdump():
            f.write('%s\n' % line)
    conn.close()
    print(f"Success: Database dump created at {output_path}")
except Exception as e:
    print(f"Error during dump: {e}")
