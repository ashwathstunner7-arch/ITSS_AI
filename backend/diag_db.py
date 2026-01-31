import os
import sys
# Add current directory to sys.path to import app
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from sqlalchemy import create_engine, MetaData, Table, inspect
from app.core.config import settings

try:
    db_url = settings.DATABASE_URL
    print(f"Connecting to: {db_url.split('@')[-1]}") # Hide credentials
    engine = create_engine(db_url)
    connection = engine.connect()
    print("Successfully connected to the database.")
    
    inspector = inspect(engine)
    tables = inspector.get_table_names()
    print(f"Tables found: {tables}")
    
    if 'USER' in tables:
        columns = inspector.get_columns('USER')
        column_names = [c['name'] for c in columns]
        print(f"Columns in 'USER' table: {column_names}")
    else:
        print("Error: 'USER' table not found.")
        
    if 'RULES' in tables:
        columns = inspector.get_columns('RULES')
        column_names = [c['name'] for c in columns]
        print(f"Columns in 'RULES' table: {column_names}")
    else:
        print("Error: 'RULES' table not found.")
        
    connection.close()
except Exception as e:
    print(f"Connection failed: {e}")
