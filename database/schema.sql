-- ============================================
-- JTAC Weapon Catalog Database Schema
-- ============================================

-- Drop existing tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS weapon_target CASCADE;
DROP TABLE IF EXISTS weapon_guidance CASCADE;
DROP TABLE IF EXISTS weapon_aircraft CASCADE;
DROP TABLE IF EXISTS weapons CASCADE;
DROP TABLE IF EXISTS weapon_families CASCADE;
DROP TABLE IF EXISTS aircraft CASCADE;
DROP TABLE IF EXISTS guidance_types CASCADE;
DROP TABLE IF EXISTS targets CASCADE;

-- Drop existing ENUMs if they exist
DROP TYPE IF EXISTS weapon_type_enum CASCADE;
DROP TYPE IF EXISTS service_branch_enum CASCADE;
DROP TYPE IF EXISTS effectiveness_enum CASCADE;
DROP TYPE IF EXISTS target_category_enum CASCADE;

-- ============================================
-- ENUM Types (Constrained Values)
-- ============================================

CREATE TYPE weapon_type_enum AS ENUM ('BOMB', 'MISSILE', 'ROCKET', 'GUN');
CREATE TYPE service_branch_enum AS ENUM ('USAF', 'USN', 'USMC', 'USA', 'MULTI');
CREATE TYPE effectiveness_enum AS ENUM ('HIGH', 'MEDIUM', 'LOW');
CREATE TYPE target_category_enum AS ENUM ('PERSONNEL', 'VEHICLE', 'STRUCTURE', 'FORTIFICATION', 'OTHER');

-- ============================================
-- Core Tables
-- ============================================

-- WEAPON TABLE
-- Stores all air-ground weapons
CREATE TABLE weapon (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,               -- e.g., "GBU-12"
    description TEXT,                        -- e.g., "Paveway II"
    weapon_type weapon_type_enum NOT NULL,   -- BOMB, MISSILE, ROCKET, GUN --> UPDATE TO JDAM, LJDAM, A-G MISSILE, ETC.
    danger_close_contact INTEGER NOT NULL,   -- meters (contact fuse)
    danger_close_airburst INTEGER,           -- meters (airburst fuse, nullable)
    warhead_weight INTEGER,                  -- pounds (nullable)
    warhead_type VARCHAR(50),                -- HE, HEAT, Frag, Penetrator (nullable)
    guidance_type VARCHAR(50) NOT NULL,      -- e.g., "LGB", "GPS", "INS", "IR" --> Possibly move LGB to weapon type and use "Laser Guided" instead
    special_notes TEXT                       -- JTTP notes, limitations, etc.
);

-- TARGETS TABLE
-- Stores target types for weapon-target pairing
CREATE TABLE target (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,              -- e.g., "Personnel", "Light Vehicle"
    category target_category_enum,           -- PERSONNEL, VEHICLE, STRUCTURE, etc.
    description TEXT
);

-- ============================================
-- Junction Tables (Many-to-Many Relationships)
-- ============================================

-- WEAPON-TARGET PAIRING JUNCTION
-- Links weapons to suitable target types (weapon-target pairing rules)
CREATE TABLE weapon_target (
    id SERIAL PRIMARY KEY,
    weapon_id INTEGER NOT NULL REFERENCES weapon(id) ON DELETE CASCADE,
    target_id INTEGER NOT NULL REFERENCES target(id) ON DELETE CASCADE,
    effectiveness_rating effectiveness_enum, -- HIGH, MEDIUM, LOW
    notes TEXT,                              -- Pairing-specific notes
    UNIQUE(weapon_id, target_id)
);

-- ============================================
-- Indexes (For Performance)
-- ============================================

-- Weapon table indexes
CREATE INDEX idx_weapon_name ON weapon(name);
CREATE INDEX idx_weapon_weapon_type ON weapon(weapon_type);
CREATE INDEX idx_weapon_guidance_type ON weapon(guidance_type);

-- Target table indexes
CREATE INDEX idx_target_category ON target(category);

-- Junction table indexes for weapon lookups
CREATE INDEX idx_weapon_target_weapon ON weapon_target(weapon_id);
CREATE INDEX idx_weapon_target_target ON weapon_target(target_id);