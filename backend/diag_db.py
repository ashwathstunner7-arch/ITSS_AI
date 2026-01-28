import os
from sqlalchemy import create_engine, MetaData, Table, inspect
from dotenv import load_dotenv

load_dotenv()

db_url = "sqlite:///./itss_ai.db"

try:
    engine = create_engine(db_url)
    connection = engine.connect()
    print("Successfully connected to the database.")
    
    inspector = inspect(engine)
    tables = inspector.get_table_names()
    print(f"Tables found: {tables}")
    
    if 'user' in tables:
        columns = inspector.get_columns('user')
        column_names = [c['name'] for c in columns]
        print(f"Columns in 'user' table: {column_names}")
    else:
        print("Error: 'user' table not found.")
        
    connection.close()
except Exception as e:
    print(f"Connection failed: {e}")
