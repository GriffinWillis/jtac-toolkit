from pydantic import BaseModel
from typing import Optional, List

# Target Model
class Target(BaseModel):
    id: int
    category: Optional[str] = None
    name: str

    class Config:
        from_attributes = True

# Weapon-Target Pairing (must be defined before Weapon to avoid forward reference)
class WeaponTargetPairing(BaseModel):
    target: Target

# Weapon Model
class Weapon(BaseModel):
    id: int
    weapon_subtype_id: int
    subtype_name: Optional[str] = None
    name: str
    description: Optional[str] = None
    variant: Optional[str] = None
    guidance_type: str
    danger_close_contact: int
    danger_close_airburst: Optional[int] = None    
    weight: Optional[int] = None
    warhead_type: Optional[str] = None
    special_notes: Optional[str] = None
    targets: List[WeaponTargetPairing] = []

    class Config:
        from_attributes = True

# Weapon Subtype Model
class WeaponSubtype(BaseModel):
    id: int
    weapon_type_id: int
    name: str

# Weapon Type Model
class WeaponType(BaseModel):
    id: int
    name: str