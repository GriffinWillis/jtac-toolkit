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
                JOIN weapon_subtype ws ON w.weapon_subtype_id = ws.id
                JOIN weapon_type wty ON ws.weapon_type_id = wty.id
                LEFT JOIN weapon_subtype_target wst ON ws.id = wst.weapon_subtype_id
                WHERE 1=1
            """
            params = []

            if weapon_type:
                query += " AND wty.name = %s"
                params.append(weapon_type)

            if guidance_type:
                query += " AND w.guidance_type = %s"
                params.append(guidance_type)

            if target_id:
                query += " AND wst.target_id = %s"
                params.append(target_id)

            if search:
                query += " AND w.name ILIKE %s"
                params.append(f"%{search}%")

            query += " ORDER BY w.name"

            cur.execute(query, params)
            rows = cur.fetchall()

            weapons = []
            for row in rows:
                weapon_subtype_id = row['weapon_subtype_id']

                # Get targets from weapon_subtype_target table
                cur.execute("""
                    SELECT t.*
                    FROM weapon_subtype_target wst
                    JOIN target t ON wst.target_id = t.id
                    WHERE wst.weapon_subtype_id = %s
                    ORDER BY t.name
                """, (weapon_subtype_id,))
                target_rows = cur.fetchall()

                targets = [
                    WeaponTargetPairing(
                        target=Target(
                            id=t['id'],
                            name=t['name'],
                            category=t['category']
                        )
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

            # Get targets from weapon_subtype_target table
            cur.execute("""
                SELECT t.*
                FROM weapon_subtype_target wst
                JOIN target t ON wst.target_id = t.id
                WHERE wst.weapon_subtype_id = %s
                ORDER BY t.name
            """, (row['weapon_subtype_id'],))
            target_rows = cur.fetchall()

            targets = [
                WeaponTargetPairing(
                    target=Target(
                        id=t['id'],
                        name=t['name'],
                        category=t['category']
                    )
                )
                for t in target_rows
            ]

            return Weapon(
                **dict(row),
                targets=targets
            )
    finally:
        release_connection(conn)
