from fastapi import APIRouter, HTTPException
from typing import List
from database import get_connection, release_connection
from models import Aircraft
from psycopg2.extras import RealDictCursor

router = APIRouter(prefix="/api/aircraft", tags=["aircraft"])

@router.get("", response_model=List[Aircraft])
def get_aircraft():
    """Get all aircraft"""
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM aircraft ORDER BY designation")
            rows = cur.fetchall()
            return [Aircraft(**dict(row)) for row in rows]
    finally:
        release_connection(conn)

@router.get("/{aircraft_id}", response_model=Aircraft)
def get_aircraft_by_id(aircraft_id: int):
    """Get a single aircraft by ID"""
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM aircraft WHERE id = %s", (aircraft_id,))
            row = cur.fetchone()

            if not row:
                raise HTTPException(status_code=404, detail="Aircraft not found")

            return Aircraft(**dict(row))
    finally:
        release_connection(conn)
