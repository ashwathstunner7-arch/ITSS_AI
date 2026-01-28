from fastapi import APIRouter

router = APIRouter()

@router.get("/")
async def get_spells():
    return {"message": "Quick Actions list"}
