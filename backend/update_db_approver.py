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
        inspector = inspect(inspector := engine)
        columns = [col['name'] for col in inspector.get_columns('license_requests')]
        
        with engine.connect() as conn:
            # 1. Add approver_id column
            if 'approver_id' not in columns:
                print("Adding approver_id column to license_requests...")
                conn.execute(text("ALTER TABLE license_requests ADD COLUMN approver_id INTEGER, ADD CONSTRAINT fk_approver FOREIGN KEY (approver_id) REFERENCES USER(id)"))
                print("Column added.")
            
            # 2. Add approver_username column
            if 'approver_username' not in columns:
                print("Adding approver_username column to license_requests...")
                conn.execute(text("ALTER TABLE license_requests ADD COLUMN approver_username VARCHAR(255)"))
                print("Column added.")

            conn.commit()
            print("Database update completed successfully.")
            
    except Exception as e:
        print(f"Error during database update: {e}")

if __name__ == "__main__":
    update_db()
