from fastapi import APIRouter, HTTPException, Query
from typing import Optional, List
from database import get_pool
from models import Weapon, WeaponGuidance, WeaponAircraft, WeaponTargetPairing, GuidanceType, Aircraft, Target

router = APIRouter(prefix="/api/weapons", tags=["weapons"])

@router.get("", response_model=List[Weapon])
async def get_weapons(
    weapon_type: Optional[str] = Query(None, description="Filter by weapon type (BOMB, MISSILE, GUN, ROCKET)"),
    aircraft_id: Optional[int] = Query(None, description="Filter by aircraft ID"),
    guidance_id: Optional[int] = Query(None, description="Filter by guidance type ID"),
    target_id: Optional[int] = Query(None, description="Filter by target ID"),
    search: Optional[str] = Query(None, description="Search in name or designation")
):
    """Get all weapons with optional filtering"""
    pool = await get_pool()
    
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
    param_count = 0
    
    if weapon_type:
        param_count += 1
        query += f" AND w.weapon_type = ${param_count}"
        params.append(weapon_type)
    
    if aircraft_id:
        param_count += 1
        query += f" AND wa.aircraft_id = ${param_count}"
        params.append(aircraft_id)
    
    if guidance_id:
        param_count += 1
        query += f" AND wg.guidance_id = ${param_count}"
        params.append(guidance_id)
    
    if target_id:
        param_count += 1
        query += f" AND wt.target_id = ${param_count}"
        params.append(target_id)
    
    if search:
        param_count += 1
        query += f" AND (w.name ILIKE ${param_count} OR w.designation ILIKE ${param_count})"
        search_term = f"%{search}%"
        params.append(search_term)
        params.append(search_term)
    
    query += " ORDER BY w.name"
    
    async with pool.acquire() as conn:
        rows = await conn.fetch(query, *params)
        
        weapons = []
        for row in rows:
            weapon_id = row['id']
            
            # Get guidance types
            guidance_rows = await conn.fetch("""
                SELECT g.*, wg.is_primary
                FROM weapon_guidance wg
                JOIN guidance_types g ON wg.guidance_id = g.id
                WHERE wg.weapon_id = $1
                ORDER BY wg.is_primary DESC, g.name
            """, weapon_id)
            
            guidance_types = [
                WeaponGuidance(
                    guidance=GuidanceType(**dict(g)),
                    is_primary=g['is_primary']
                )
                for g in guidance_rows
            ]
            
            # Get aircraft
            aircraft_rows = await conn.fetch("""
                SELECT a.*, wa.notes
                FROM weapon_aircraft wa
                JOIN aircraft a ON wa.aircraft_id = a.id
                WHERE wa.weapon_id = $1
                ORDER BY a.designation
            """, weapon_id)
            
            aircraft_list = [
                WeaponAircraft(
                    aircraft=Aircraft(**dict(a)),
                    notes=a['notes']
                )
                for a in aircraft_rows
            ]
            
            # Get targets
            target_rows = await conn.fetch("""
                SELECT t.*, wt.effectiveness_rating, wt.notes
                FROM weapon_target wt
                JOIN targets t ON wt.target_id = t.id
                WHERE wt.weapon_id = $1
                ORDER BY t.name
            """, weapon_id)
            
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

@router.get("/{weapon_id}", response_model=Weapon)
async def get_weapon(weapon_id: int):
    """Get a single weapon by ID"""
    pool = await get_pool()
    
    async with pool.acquire() as conn:
        row = await conn.fetchrow("SELECT * FROM weapons WHERE id = $1", weapon_id)
        
        if not row:
            raise HTTPException(status_code=404, detail="Weapon not found")
        
        # Get guidance types
        guidance_rows = await conn.fetch("""
            SELECT g.*, wg.is_primary
            FROM weapon_guidance wg
            JOIN guidance_types g ON wg.guidance_id = g.id
            WHERE wg.weapon_id = $1
            ORDER BY wg.is_primary DESC, g.name
        """, weapon_id)
        
        guidance_types = [
            WeaponGuidance(
                guidance=GuidanceType(**dict(g)),
                is_primary=g['is_primary']
            )
            for g in guidance_rows
        ]
        
        # Get aircraft
        aircraft_rows = await conn.fetch("""
            SELECT a.*, wa.notes
            FROM weapon_aircraft wa
            JOIN aircraft a ON wa.aircraft_id = a.id
            WHERE wa.weapon_id = $1
            ORDER BY a.designation
        """, weapon_id)
        
        aircraft_list = [
            WeaponAircraft(
                aircraft=Aircraft(**dict(a)),
                notes=a['notes']
            )
            for a in aircraft_rows
        ]
        
        # Get targets
        target_rows = await conn.fetch("""
            SELECT t.*, wt.effectiveness_rating, wt.notes
            FROM weapon_target wt
            JOIN targets t ON wt.target_id = t.id
            WHERE wt.weapon_id = $1
            ORDER BY t.name
        """, weapon_id)
        
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