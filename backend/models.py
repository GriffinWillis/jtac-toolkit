from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

# Guidance Type Models
class GuidanceType(BaseModel):
    id: int
    name: str
    full_name: Optional[str] = None
    description: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

# Aircraft Models
class Aircraft(BaseModel):
    id: int
    name: str
    designation: str
    service_branch: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

# Target Models
class Target(BaseModel):
    id: int
    name: str
    category: Optional[str] = None
    description: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

# Weapon-Target Pairing
class WeaponTargetPairing(BaseModel):
    target: Target
    effectiveness_rating: Optional[str] = None
    notes: Optional[str] = None

# Weapon Models
class WeaponGuidance(BaseModel):
    guidance: GuidanceType
    is_primary: bool

class WeaponAircraft(BaseModel):
    aircraft: Aircraft
    notes: Optional[str] = None

class Weapon(BaseModel):
    id: int
    name: str
    designation: Optional[str] = None
    weapon_type: str
    description: Optional[str] = None
    danger_close: Optional[int] = None
    special_notes: Optional[str] = None
    created_at: datetime
    updated_at: datetime
    guidance_types: List[WeaponGuidance] = []
    aircraft: List[WeaponAircraft] = []
    targets: List[WeaponTargetPairing] = []

    class Config:
        from_attributes = True