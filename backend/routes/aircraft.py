from fastapi import APIRouter
from typing import List
from database import get_pool
from models import Aircraft

router = APIRouter(prefix="/api/aircraft", tags=["aircraft"])

@router.get("", response_model=List[Aircraft])
async def get_aircraft():
    """Get all aircraft"""
    pool = await get_pool()
    
    async with pool.acquire() as conn:
        rows = await conn.fetch("SELECT * FROM aircraft ORDER BY designation")
        return [Aircraft(**dict(row)) for row in rows]

@router.get("/{aircraft_id}", response_model=Aircraft)
async def get_aircraft_by_id(aircraft_id: int):
    """Get a single aircraft by ID"""
    pool = await get_pool()
    
    async with pool.acquire() as conn:
        row = await conn.fetchrow("SELECT * FROM aircraft WHERE id = $1", aircraft_id)
        
        if not row:
            from fastapi import HTTPException
            raise HTTPException(status_code=404, detail="Aircraft not found")
        
        return Aircraft(**dict(row))