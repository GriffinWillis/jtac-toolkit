from fastapi import APIRouter, HTTPException, Query
from typing import Optional, List
from database import get_connection, release_connection
from models import Weapon, WeaponGuidance, WeaponAircraft, WeaponTargetPairing, GuidanceType, Aircraft, Target
from psycopg2.extras import RealDictCursor

router = APIRouter(prefix="/api/weapons", tags=["weapons"])

@router.get("", response_model=List[Weapon])
def get_weapons(
    weapon_type: Optional[str] = Query(None, description="Filter by weapon type (BOMB, MISSILE, GUN, ROCKET)"),
    aircraft_id: Optional[int] = Query(None, description="Filter by aircraft ID"),
    guidance_id: Optional[int] = Query(None, description="Filter by guidance type ID"),
    target_id: Optional[int] = Query(None, description="Filter by target ID"),
    search: Optional[str] = Query(None, description="Search in name or designation")
):
    """Get all weapons with optional filtering"""
    conn = get_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cur:
            # Build query with filters
            query = """
                SELECT DISTINCT w.*
                FROM weapons w
                LEFT JOIN weapon_aircraft wa ON w.id = wa.weapon_id
                LEFT JOIN weapon_guidance wg ON w.id = wg.weapon_id
                LEFT JOIN weapon_target wt ON w.id = wt.weapon_id
                WHERE 1=1
            """
            params = []

            if weapon_type:
                query += " AND w.weapon_type = %s"
                params.append(weapon_type)

            if aircraft_id:
                query += " AND wa.aircraft_id = %s"
                params.append(aircraft_id)

            if guidance_id:
                query += " AND wg.guidance_id = %s"
                params.append(guidance_id)

            if target_id:
                query += " AND wt.target_id = %s"
                params.append(target_id)

            if search:
                query += " AND (w.name ILIKE %s OR w.designation ILIKE %s)"
                search_term = f"%{search}%"
                params.append(search_term)
                params.append(search_term)

            query += " ORDER BY w.name"

            cur.execute(query, params)
            rows = cur.fetchall()

            weapons = []
            for row in rows:
                weapon_id = row['id']

                # Get guidance types
                cur.execute("""
                    SELECT g.*, wg.is_primary
                    FROM weapon_guidance wg
                    JOIN guidance_types g ON wg.guidance_id = g.id
                    WHERE wg.weapon_id = %s
                    ORDER BY wg.is_primary DESC, g.name
                """, (weapon_id,))
                guidance_rows = cur.fetchall()

                guidance_types = [
                    WeaponGuidance(
                        guidance=GuidanceType(**dict(g)),
                        is_primary=g['is_primary']
                    )
                    for g in guidance_rows
                ]

                # Get aircraft
                cur.execute("""
                    SELECT a.*, wa.notes
                    FROM weapon_aircraft wa
                    JOIN aircraft a ON wa.aircraft_id = a.id
                    WHERE wa.weapon_id = %s
                    ORDER BY a.designation
                """, (weapon_id,))
                aircraft_rows = cur.fetchall()

                aircraft_list = [
                    WeaponAircraft(
                        aircraft=Aircraft(**dict(a)),
                        notes=a['notes']
                    )
                    for a in aircraft_rows
                ]

                # Get targets
                cur.execute("""
                    SELECT t.*, wt.effectiveness_rating, wt.notes
                    FROM weapon_target wt
                    JOIN targets t ON wt.target_id = t.id
                    WHERE wt.weapon_id = %s
                    ORDER BY t.name
                """, (weapon_id,))
                target_rows = cur.fetchall()

                targets = [
                    WeaponTargetPairing(
                        target=Target(**dict(t)),
                        effectiveness_rating=t['effectiveness_rating'],
                        notes=t['notes']
                    )
                    for t in target_rows
                ]

                weapons.append(Weapon(
                    **dict(row),
                    guidance_types=guidance_types,
                    aircraft=aircraft_list,
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
            cur.execute("SELECT * FROM weapons WHERE id = %s", (weapon_id,))
            row = cur.fetchone()

            if not row:
                raise HTTPException(status_code=404, detail="Weapon not found")

            # Get guidance types
            cur.execute("""
                SELECT g.*, wg.is_primary
                FROM weapon_guidance wg
                JOIN guidance_types g ON wg.guidance_id = g.id
                WHERE wg.weapon_id = %s
                ORDER BY wg.is_primary DESC, g.name
            """, (weapon_id,))
            guidance_rows = cur.fetchall()

            guidance_types = [
                WeaponGuidance(
                    guidance=GuidanceType(**dict(g)),
                    is_primary=g['is_primary']
                )
                for g in guidance_rows
            ]

            # Get aircraft
            cur.execute("""
                SELECT a.*, wa.notes
                FROM weapon_aircraft wa
                JOIN aircraft a ON wa.aircraft_id = a.id
                WHERE wa.weapon_id = %s
                ORDER BY a.designation
            """, (weapon_id,))
            aircraft_rows = cur.fetchall()

            aircraft_list = [
                WeaponAircraft(
                    aircraft=Aircraft(**dict(a)),
                    notes=a['notes']
                )
                for a in aircraft_rows
            ]

            # Get targets
            cur.execute("""
                SELECT t.*, wt.effectiveness_rating, wt.notes
                FROM weapon_target wt
                JOIN targets t ON wt.target_id = t.id
                WHERE wt.weapon_id = %s
                ORDER BY t.name
            """, (weapon_id,))
            target_rows = cur.fetchall()

            targets = [
                WeaponTargetPairing(
                    target=Target(**dict(t)),
                    effectiveness_rating=t['effectiveness_rating'],
                    notes=t['notes']
                )
                for t in target_rows
            ]

            return Weapon(
                **dict(row),
                guidance_types=guidance_types,
                aircraft=aircraft_list,
                targets=targets
            )
    finally:
        release_connection(conn)
