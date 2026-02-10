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

def update_db():
    print(f"Connecting to {DB_HOST}:{DB_PORT}/{DB_NAME}...")
    engine = create_engine(DATABASE_URL)
    
    try:
        inspector = inspect(engine)
        columns = [col['name'] for col in inspector.get_columns('license_requests')]
        
        with engine.connect() as conn:
            # 1. Add requester_username column
            if 'requester_username' not in columns:
                print("Adding requester_username column to license_requests...")
                conn.execute(text("ALTER TABLE license_requests ADD COLUMN requester_username VARCHAR(255)"))
                print("Column added.")
            
            # 2. Backfill requester_username
            print("Backfilling requester_username...")
            conn.execute(text("""
                UPDATE license_requests lr
                INNER JOIN USER u ON lr.requester_id = u.id
                SET lr.requester_username = u.username
                WHERE lr.requester_username IS NULL
            """))
            print("Backfill complete.")

            # 3. Update Foreign Key for Cascade Delete
            print("Checking foreign keys on license_requests...")
            fks = inspector.get_foreign_keys('license_requests')
            fk_name = None
            for fk in fks:
                if fk['constrained_columns'] == ['requester_id']:
                    fk_name = fk['name']
                    # Check if it already has cascade delete (MySQL specific check might be hard via inspector)
                    # We'll just drop and recreate it to be sure
                    break
            
            if fk_name:
                print(f"Dropping existing foreign key {fk_name}...")
                conn.execute(text(f"ALTER TABLE license_requests DROP FOREIGN KEY {fk_name}"))
            
            print("Adding foreign key with ON DELETE CASCADE...")
            conn.execute(text("""
                ALTER TABLE license_requests 
                ADD CONSTRAINT fk_license_requests_requester 
                FOREIGN KEY (requester_id) REFERENCES USER(id) 
                ON DELETE CASCADE
            """))
            print("Foreign key updated.")

            conn.commit()
            print("Database update completed successfully.")
            
    except Exception as e:
        print(f"Error during database update: {e}")

if __name__ == "__main__":
    update_db()
