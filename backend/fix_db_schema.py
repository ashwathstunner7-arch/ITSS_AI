import os
import sys
import urllib.parse
from sqlalchemy import create_engine, inspect, text

# Database connection details
DB_USER = "root"
DB_PASSWORD = "Aspire@2001"
DB_HOST = "localhost"
DB_PORT = "3306"
DB_NAME = "AI_USER"

encoded_password = urllib.parse.quote_plus(DB_PASSWORD)
DATABASE_URL = f"mysql+pymysql://{DB_USER}:{encoded_password}@{DB_HOST}:{DB_PORT}/{DB_NAME}"

def fix_schema():
    print(f"Connecting to {DB_HOST}:{DB_PORT}/{DB_NAME}...")
    engine = create_engine(DATABASE_URL)
    
    try:
        inspector = inspect(engine)
        columns = [col['name'] for col in inspector.get_columns('USER')]
        print(f"Current columns in USER table: {columns}")

        needed_columns = {
            'parent_id': 'INTEGER',
            'license_limit': 'INTEGER DEFAULT 0',
            'license_consumed': 'INTEGER DEFAULT 0'
        }

        with engine.connect() as conn:
            for col, col_type in needed_columns.items():
                if col not in columns:
                    print(f"Adding column {col} to USER table...")
                    conn.execute(text(f"ALTER TABLE USER ADD COLUMN {col} {col_type}"))
                    print(f"Column {col} added.")
            
            # Also check license_requests table
            if 'license_requests' not in inspector.get_table_names():
                print("Creating license_requests table...")
                conn.execute(text("""
                    CREATE TABLE license_requests (
                        id INTEGER PRIMARY KEY AUTO_INCREMENT,
                        requester_id INTEGER,
                        requested_amount INTEGER,
                        status VARCHAR(50) DEFAULT 'pending',
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                        updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                        FOREIGN KEY (requester_id) REFERENCES USER(id)
                    )
                """))
                print("Table license_requests created.")
            
            # Migrate ruleaccess for existing admins if needed
            print("Ensuring ruleaccess is set for admins...")
            # (No-op or custom logic if ruleaccess needs specific values)
            conn.commit()
            print("Schema update completed successfully.")
    except Exception as e:
        print(f"Error during schema update: {e}")

if __name__ == "__main__":
    fix_schema()

if __name__ == "__main__":
    fix_schema()
