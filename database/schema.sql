-- ============================================
-- JTAC Weapon Catalog Database Schema
-- ============================================

-- Drop existing tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS weapon_target CASCADE;
DROP TABLE IF EXISTS weapon_guidance CASCADE;
DROP TABLE IF EXISTS weapon_aircraft CASCADE;
DROP TABLE IF EXISTS weapons CASCADE;
DROP TABLE IF EXISTS aircraft CASCADE;
DROP TABLE IF EXISTS guidance_types CASCADE;
DROP TABLE IF EXISTS targets CASCADE;

-- Core Tables (Your 4 Entities)
-- ============================================

-- 1. WEAPONS TABLE
-- Stores all air-ground weapons
CREATE TABLE weapons (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,                -- e.g., "GBU-12 Paveway II"
    designation VARCHAR(50),                   -- e.g., "GBU-12"
    weapon_type VARCHAR(50) NOT NULL,          -- MISSILE, BOMB, GUN, etc.
    description TEXT,
    danger_close INTEGER,                      -- meters
    special_notes TEXT,                        -- JTTP notes, limitations, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. AIRCRAFT TABLE
-- Stores aircraft that employ weapons
CREATE TABLE aircraft (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,                -- e.g., "F-16 Fighting Falcon"
    designation VARCHAR(50) NOT NULL,          -- e.g., "F-16"
    service_branch VARCHAR(50),                -- USAF, USN, USMC, USA
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. GUIDANCE TABLE
-- Stores guidance system types
CREATE TABLE guidance_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,          -- e.g., "LGB", "GPS", "INS", "IR"
    full_name VARCHAR(100),                    -- e.g., "Laser Guided Bomb"
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. TARGET TABLE
-- Stores target types for weapon-target pairing
CREATE TABLE targets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,                -- e.g., "Personnel", "Light Vehicle"
    category VARCHAR(50),                      -- PERSONNEL, VEHICLE, STRUCTURE, etc.
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================
-- Junction Tables (Many-to-Many Relationships)
-- ============================================

-- 5. WEAPON-AIRCRAFT JUNCTION
-- Links weapons to aircraft that can employ them
CREATE TABLE weapon_aircraft (
    id SERIAL PRIMARY KEY,
    weapon_id INTEGER NOT NULL REFERENCES weapons(id) ON DELETE CASCADE,
    aircraft_id INTEGER NOT NULL REFERENCES aircraft(id) ON DELETE CASCADE,
    notes TEXT,                                -- Aircraft-specific employment notes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(weapon_id, aircraft_id)             -- Prevents duplicate entries
);

-- 6. WEAPON-GUIDANCE JUNCTION
-- Links weapons to their guidance types
CREATE TABLE weapon_guidance (
    id SERIAL PRIMARY KEY,
    weapon_id INTEGER NOT NULL REFERENCES weapons(id) ON DELETE CASCADE,
    guidance_id INTEGER NOT NULL REFERENCES guidance_types(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT FALSE,          -- Primary guidance type?
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(weapon_id, guidance_id)
);

-- 7. WEAPON-TARGET PAIRING JUNCTION
-- Links weapons to suitable target types (weapon-target pairing rules)
CREATE TABLE weapon_target (
    id SERIAL PRIMARY KEY,
    weapon_id INTEGER NOT NULL REFERENCES weapons(id) ON DELETE CASCADE,
    target_id INTEGER NOT NULL REFERENCES targets(id) ON DELETE CASCADE,
    effectiveness_rating VARCHAR(20),          -- HIGH, MEDIUM, LOW, or NULL
    notes TEXT,                                -- Pairing-specific notes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(weapon_id, target_id)
);

-- ============================================
-- Indexes (For Performance)
-- ============================================

-- Speed up common queries
CREATE INDEX idx_weapons_type ON weapons(weapon_type);
CREATE INDEX idx_weapons_designation ON weapons(designation);
CREATE INDEX idx_aircraft_designation ON aircraft(designation);
CREATE INDEX idx_weapon_aircraft_weapon ON weapon_aircraft(weapon_id);
CREATE INDEX idx_weapon_aircraft_aircraft ON weapon_aircraft(aircraft_id);
CREATE INDEX idx_weapon_guidance_weapon ON weapon_guidance(weapon_id);
CREATE INDEX idx_weapon_target_weapon ON weapon_target(weapon_id);