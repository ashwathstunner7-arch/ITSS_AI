from sqlalchemy import create_engine, text
from app.core.config import settings

engine = create_engine(settings.DATABASE_URL)

with engine.connect() as connection:
    result = connection.execute(text("SELECT id, username, status FROM USER"))
    print("Users in 'USER' table:")
    for row in result:
        print(row)
