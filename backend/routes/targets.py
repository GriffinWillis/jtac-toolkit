from fastapi import APIRouter
from typing import List
from database import get_pool
from models import Target

router = APIRouter(prefix="/api/targets", tags=["targets"])

@router.get("", response_model=List[Target])
async def get_targets():
    """Get all targets"""
    pool = await get_pool()
    
    async with pool.acquire() as conn:
        rows = await conn.fetch("SELECT * FROM targets ORDER BY category, name")
        return [Target(**dict(row)) for row in rows]

@router.get("/{target_id}", response_model=Target)
async def get_target_by_id(target_id: int):
    """Get a single target by ID"""
    pool = await get_pool()
    
    async with pool.acquire() as conn:
        row = await conn.fetchrow("SELECT * FROM targets WHERE id = $1", target_id)
        
        if not row:
            from fastapi import HTTPException
            raise HTTPException(status_code=404, detail="Target not found")
        
        return Target(**dict(row))