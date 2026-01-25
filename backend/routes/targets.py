from fastapi import APIRouter, HTTPException
from typing import List
from database import get_connection, release_connection
from models import Target
from psycopg2.extras import RealDictCursor

router = APIRouter(prefix="/api/targets", tags=["targets"])

@router.get("", response_model=List[Target])
def get_targets():
    """Get all targets"""
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM targets ORDER BY category, name")
            rows = cur.fetchall()
            return [Target(**dict(row)) for row in rows]
    finally:
        release_connection(conn)

@router.get("/{target_id}", response_model=Target)
def get_target_by_id(target_id: int):
    """Get a single target by ID"""
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM targets WHERE id = %s", (target_id,))
            row = cur.fetchone()

            if not row:
                raise HTTPException(status_code=404, detail="Target not found")

            return Target(**dict(row))
    finally:
        release_connection(conn)
