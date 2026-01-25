from fastapi import APIRouter, HTTPException
from typing import List
from database import get_connection, release_connection
from models import GuidanceType
from psycopg2.extras import RealDictCursor

router = APIRouter(prefix="/api/guidance", tags=["guidance"])

@router.get("", response_model=List[GuidanceType])
def get_guidance_types():
    """Get all guidance types"""
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM guidance_types ORDER BY name")
            rows = cur.fetchall()
            return [GuidanceType(**dict(row)) for row in rows]
    finally:
        release_connection(conn)

@router.get("/{guidance_id}", response_model=GuidanceType)
def get_guidance_by_id(guidance_id: int):
    """Get a single guidance type by ID"""
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM guidance_types WHERE id = %s", (guidance_id,))
            row = cur.fetchone()

            if not row:
                raise HTTPException(status_code=404, detail="Guidance type not found")

            return GuidanceType(**dict(row))
    finally:
        release_connection(conn)
