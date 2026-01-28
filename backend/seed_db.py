from app.core.database import SessionLocal, engine, Base
from app.models import models

def seed():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    
    # Check if rules already exist
    if db.query(models.Rule).count() == 0:
        rules = [
            models.Rule(title="Strict Typing", description="Ensure all code generation uses strict type definitions.", enabled=True, type="logic"),
            models.Rule(title="Modern Clean CSS", description="Prefer vanilla CSS with modern features over libraries.", enabled=True, type="style"),
            models.Rule(title="Security First", description="Avoid using unsafe functions and validate all inputs.", enabled=False, type="security")
        ]
        db.add_all(rules)
        db.commit()
        print("Database seeded with default rules.")
    else:
        print("Database already contains rules.")
    db.close()

if __name__ == "__main__":
    seed()
