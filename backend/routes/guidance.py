from fastapi import APIRouter
from typing import List
from database import get_pool
from models import GuidanceType

router = APIRouter(prefix="/api/guidance", tags=["guidance"])

@router.get("", response_model=List[GuidanceType])
async def get_guidance_types():
    """Get all guidance types"""
    pool = await get_pool()
    
    async with pool.acquire() as conn:
        rows = await conn.fetch("SELECT * FROM guidance_types ORDER BY name")
        return [GuidanceType(**dict(row)) for row in rows]

@router.get("/{guidance_id}", response_model=GuidanceType)
async def get_guidance_by_id(guidance_id: int):
    """Get a single guidance type by ID"""
    pool = await get_pool()
    
    async with pool.acquire() as conn:
        row = await conn.fetchrow("SELECT * FROM guidance_types WHERE id = $1", guidance_id)
        
        if not row:
            from fastapi import HTTPException
            raise HTTPException(status_code=404, detail="Guidance type not found")
        
        return GuidanceType(**dict(row))