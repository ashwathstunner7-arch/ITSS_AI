from fastapi import FastAPI
from app.api import auth, tenant, manifest, spell, invoke, rules, chats, messages

from app.core.database import engine, Base
from app.models import models

from fastapi.middleware.cors import CORSMiddleware

Base.metadata.create_all(bind=engine)

app = FastAPI(title="ITSS AI", version="1.0.0")

origins = [
    "http://localhost",
    "http://localhost:5173",
    "http://localhost:4173",
    "http://localhost:4174",
    "*",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include Routers
app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(tenant.router, prefix="/tenant", tags=["Tenants"])
app.include_router(manifest.router, prefix="/manifest", tags=["Manifests"])
app.include_router(spell.router, prefix="/spell", tags=["Quick Actions"])
app.include_router(invoke.router, prefix="/invoke", tags=["AI Execution"])
app.include_router(rules.router, prefix="/rules", tags=["Rule Management"])
app.include_router(chats.router, prefix="/chats", tags=["Chat History"])
app.include_router(messages.router, prefix="/messages", tags=["Message Operations"])

@app.get("/")
async def root():
    return {"message": "Welcome to ITSS AI API"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
