from fastapi import APIRouter, HTTPException, Query
from typing import Optional, List
from database import get_connection, release_connection
from models import Weapon, WeaponTargetPairing, Target
from psycopg2.extras import RealDictCursor

router = APIRouter(prefix="/api/weapons", tags=["weapons"])

@router.get("", response_model=List[Weapon])
def get_weapons(
    weapon_type: Optional[str] = Query(None, description="Filter by weapon type (BOMB, MISSILE, GUN, ROCKET)"),
    guidance_type: Optional[str] = Query(None, description="Filter by guidance type (e.g., LGB, GPS, INS)"),
    target_id: Optional[int] = Query(None, description="Filter by target ID"),
    search: Optional[str] = Query(None, description="Search in weapon name")
):
    """Get all weapons with optional filtering"""
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Build query with filters
            query = """
                SELECT DISTINCT w.*
                FROM weapon w
                LEFT JOIN weapon_target wt ON w.id = wt.weapon_id
                WHERE 1=1
            """
            params = []

            if weapon_type:
                query += " AND w.weapon_type = %s"
                params.append(weapon_type)

            if guidance_type:
                query += " AND w.guidance_type = %s"
                params.append(guidance_type)

            if target_id:
                query += " AND wt.target_id = %s"
                params.append(target_id)

            if search:
                query += " AND w.name ILIKE %s"
                params.append(f"%{search}%")

            query += " ORDER BY w.name"

            cur.execute(query, params)
            rows = cur.fetchall()

            weapons = []
            for row in rows:
                weapon_id = row['id']

                # Get targets
                cur.execute("""
                    SELECT t.*, wt.effectiveness_rating, wt.notes
                    FROM weapon_target wt
                    JOIN target t ON wt.target_id = t.id
                    WHERE wt.weapon_id = %s
                    ORDER BY t.name
                """, (weapon_id,))
                target_rows = cur.fetchall()

                targets = [
                    WeaponTargetPairing(
                        target=Target(
                            id=t['id'],
                            name=t['name'],
                            category=t['category'],
                            description=t['description']
                        ),
                        effectiveness_rating=t['effectiveness_rating'],
                        notes=t['notes']
                    )
                    for t in target_rows
                ]

                weapons.append(Weapon(
                    **dict(row),
                    targets=targets
                ))

            return weapons
    finally:
        release_connection(conn)

@router.get("/{weapon_id}", response_model=Weapon)
def get_weapon(weapon_id: int):
    """Get a single weapon by ID"""
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            cur.execute("SELECT * FROM weapon WHERE id = %s", (weapon_id,))
            row = cur.fetchone()

            if not row:
                raise HTTPException(status_code=404, detail="Weapon not found")

            # Get targets
            cur.execute("""
                SELECT t.*, wt.effectiveness_rating, wt.notes
                FROM weapon_target wt
                JOIN target t ON wt.target_id = t.id
                WHERE wt.weapon_id = %s
                ORDER BY t.name
            """, (weapon_id,))
            target_rows = cur.fetchall()

            targets = [
                WeaponTargetPairing(
                    target=Target(
                        id=t['id'],
                        name=t['name'],
                        category=t['category'],
                        description=t['description']
                    ),
                    effectiveness_rating=t['effectiveness_rating'],
                    notes=t['notes']
                )
                for t in target_rows
            ]

            return Weapon(
                **dict(row),
                targets=targets
            )
    finally:
        release_connection(conn)
