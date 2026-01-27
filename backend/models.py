from pydantic import BaseModel
from typing import Optional, List

# Target Model
class Target(BaseModel):
    id: int
    name: str
    category: Optional[str] = None
    description: Optional[str] = None

    class Config:
        from_attributes = True

# Weapon-Target Pairing (must be defined before Weapon to avoid forward reference)
class WeaponTargetPairing(BaseModel):
    target: Target
    effectiveness_rating: Optional[str] = None
    notes: Optional[str] = None

# Weapon Model
class Weapon(BaseModel):
    id: int
    name: str
    description: Optional[str] = None
    weapon_type: str
    danger_close_contact: int
    danger_close_airburst: Optional[int] = None
    warhead_weight: Optional[int] = None
    warhead_type: Optional[str] = None
    guidance_type: str
    special_notes: Optional[str] = None
    targets: List[WeaponTargetPairing] = []

    class Config:
        from_attributes = True
