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

-- WEAPON FAMILIES TABLE
-- Groups weapons by family (JDAM, Paveway, Maverick, etc.)
CREATE TABLE weapon_families (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,       -- e.g., "JDAM", "Paveway II", "Maverick"
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- WEAPONS TABLE
-- Stores all air-ground weapons
CREATE TABLE weapons (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,              -- e.g., "GBU-12 Paveway II"
    designation VARCHAR(50),                 -- e.g., "GBU-12"
    weapon_type weapon_type_enum NOT NULL,   -- BOMB, MISSILE, ROCKET, GUN
    family_id INTEGER REFERENCES weapon_families(id),
    description TEXT,
    danger_close_contact INTEGER,            -- meters (contact fuse)
    danger_close_airburst INTEGER,           -- meters (airburst fuse, nullable)
    warhead_weight INTEGER,                  -- pounds (nullable)
    warhead_type VARCHAR(50),                -- HE, HEAT, Frag, Penetrator (nullable)
    special_notes TEXT,                      -- JTTP notes, limitations, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- AIRCRAFT TABLE
-- Stores aircraft that employ weapons
CREATE TABLE aircraft (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,              -- e.g., "F-16 Fighting Falcon"
    designation VARCHAR(50) NOT NULL,        -- e.g., "F-16"
    service_branch service_branch_enum,      -- USAF, USN, USMC, USA, MULTI
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- GUIDANCE TABLE
-- Stores guidance system types
CREATE TABLE guidance_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,        -- e.g., "LGB", "GPS", "INS", "IR"
    full_name VARCHAR(100),                  -- e.g., "Laser Guided Bomb"
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- TARGETS TABLE
-- Stores target types for weapon-target pairing
CREATE TABLE targets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,              -- e.g., "Personnel", "Light Vehicle"
    category target_category_enum,           -- PERSONNEL, VEHICLE, STRUCTURE, etc.
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Junction Tables (Many-to-Many Relationships)
-- ============================================

-- WEAPON-AIRCRAFT JUNCTION
-- Links weapons to aircraft that can employ them
CREATE TABLE weapon_aircraft (
    id SERIAL PRIMARY KEY,
    weapon_id INTEGER NOT NULL REFERENCES weapons(id) ON DELETE CASCADE,
    aircraft_id INTEGER NOT NULL REFERENCES aircraft(id) ON DELETE CASCADE,
    notes TEXT,                              -- Aircraft-specific employment notes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(weapon_id, aircraft_id)           -- Prevents duplicate entries
);

-- WEAPON-GUIDANCE JUNCTION
-- Links weapons to their guidance types
CREATE TABLE weapon_guidance (
    id SERIAL PRIMARY KEY,
    weapon_id INTEGER NOT NULL REFERENCES weapons(id) ON DELETE CASCADE,
    guidance_id INTEGER NOT NULL REFERENCES guidance_types(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT FALSE,        -- Primary guidance type?
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(weapon_id, guidance_id)
);

-- WEAPON-TARGET PAIRING JUNCTION
-- Links weapons to suitable target types (weapon-target pairing rules)
CREATE TABLE weapon_target (
    id SERIAL PRIMARY KEY,
    weapon_id INTEGER NOT NULL REFERENCES weapons(id) ON DELETE CASCADE,
    target_id INTEGER NOT NULL REFERENCES targets(id) ON DELETE CASCADE,
    effectiveness_rating effectiveness_enum, -- HIGH, MEDIUM, LOW
    notes TEXT,                              -- Pairing-specific notes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(weapon_id, target_id)
);

-- ============================================
-- Indexes (For Performance)
-- ============================================

-- Weapons table indexes
CREATE INDEX idx_weapons_type ON weapons(weapon_type);
CREATE INDEX idx_weapons_designation ON weapons(designation);
CREATE INDEX idx_weapons_family ON weapons(family_id);

-- Aircraft table indexes
CREATE INDEX idx_aircraft_designation ON aircraft(designation);

-- Targets table indexes
CREATE INDEX idx_targets_category ON targets(category);

-- Junction table indexes for weapon lookups
CREATE INDEX idx_weapon_aircraft_weapon ON weapon_aircraft(weapon_id);
CREATE INDEX idx_weapon_aircraft_aircraft ON weapon_aircraft(aircraft_id);
CREATE INDEX idx_weapon_guidance_weapon ON weapon_guidance(weapon_id);
CREATE INDEX idx_weapon_target_weapon ON weapon_target(weapon_id);

-- Junction table indexes for filtering (target type and guidance filtering priorities)
CREATE INDEX idx_weapon_target_target ON weapon_target(target_id);
CREATE INDEX idx_weapon_guidance_guidance ON weapon_guidance(guidance_id);
