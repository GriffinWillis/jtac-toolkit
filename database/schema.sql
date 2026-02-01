-- ============================================
-- JTAC Weapon Catalog Database Schema
-- ============================================

-- Drop existing tables if they exist (in reverse dependency order)
DROP TABLE IF EXISTS weapon_target CASCADE;
DROP TABLE IF EXISTS weapon CASCADE;
DROP TABLE IF EXISTS target CASCADE;

-- Drop existing ENUMs if they exist
DROP TYPE IF EXISTS weapon_type_enum CASCADE;
DROP TYPE IF EXISTS effectiveness_enum CASCADE;
DROP TYPE IF EXISTS target_category_enum CASCADE;

-- ============================================
-- ENUM Types (Constrained Values)
-- ============================================

CREATE TYPE target_category_enum AS ENUM ('PERSONNEL', 'VEHICLE', 'STRUCTURE', 'FORTIFICATION', 'OTHER');

-- ============================================
-- Core Tables
-- ============================================

-- WEAPON TYPE TABLE
-- Stores weapon types
CREATE TABLE weapon_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(10) NOT NULL                       -- BOMB, MISSILE, ROCKET, GUN, CLUSTER
);

-- WEAPON SUBTYPE TABLE
-- Stores weapon subtypes
CREATE TABLE weapon_subtype (
    id SERIAL PRIMARY KEY,
    weapon_type_id INTEGER NOT NULL REFERENCES weapon_type(id) ON DELETE CASCADE,
    name VARCHAR(20) NOT NULL,                      -- GP, JDAM, LJDAM, DMLGB, LGB, SDB, HELLFIRE, CBU, FW, RW, ...
    UNIQUE(weapon_type_id, name)
);

-- WEAPON TABLE
-- Stores all air-ground weapons
CREATE TABLE weapon (
    id SERIAL PRIMARY KEY,
    weapon_subtype_id INTEGER NOT NULL REFERENCES weapon_subtype(id) ON DELETE CASCADE,
    name VARCHAR(50) NOT NULL,                      -- e.g., "GBU-12"
    description TEXT,                               -- e.g., "Paveway II"
    variant VARCHAR(10),                            -- e.g., "v1", "A"
    guidance_type VARCHAR(50) NOT NULL,             -- e.g., "LASER", "GPS", "INS", "IR"
    danger_close_contact INTEGER NOT NULL,          -- meters (contact fuse)
    danger_close_airburst INTEGER,                  -- meters (airburst fuse, nullable)
    weight INTEGER,                                 -- pounds (nullable)
    warhead_type VARCHAR(50),                       -- HE, HEAT, Frag, Penetrator (nullable)
    special_notes TEXT                              -- JTTP notes, limitations, etc.
);

-- TARGETS TABLE
-- Stores target types for weapon-target pairing
CREATE TABLE target (
    id SERIAL PRIMARY KEY,
    category target_category_enum,                  -- PERSONNEL, VEHICLE, STRUCTURE, etc.
    name VARCHAR(100) NOT NULL                      -- e.g., "Personnel", "Light Vehicle"
);

-- ============================================
-- Junction Tables (Many-to-Many Relationships)
-- ============================================

-- WEAPON_SUBTYPE-TARGET PAIRING JUNCTION
-- Links weapon subtypes to suitable target types (weapon-target pairing rules)
CREATE TABLE weapon_subtype_target (
    target_id INTEGER NOT NULL REFERENCES target(id) ON DELETE CASCADE,
    weapon_subtype_id INTEGER NOT NULL REFERENCES weapon_subtype(id) ON DELETE CASCADE,
    PRIMARY KEY (target_id, weapon_subtype_id)
);

-- WEAPON-TARGET PAIRING JUNCTION
-- Links weapons to suitable target types (weapon-target pairing rules)
CREATE TABLE weapon_target (
    target_id INTEGER NOT NULL REFERENCES target(id) ON DELETE CASCADE,
    weapon_id INTEGER NOT NULL REFERENCES weapon(id) ON DELETE CASCADE,
    PRIMARY KEY (target_id, weapon_id)
);

-- ============================================
-- Indexes (For Performance)
-- ============================================

-- Weapon table indexes
CREATE INDEX idx_weapon_name ON weapon(name);
CREATE INDEX idx_weapon_weapon_subtype ON weapon(weapon_subtype_id);
CREATE INDEX idx_weapon_guidance_type ON weapon(guidance_type);
CREATE INDEX idx_weapon_subtype_weapon_type ON weapon_subtype(weapon_type_id);

-- Target table indexes
CREATE INDEX idx_target_name ON target(name);

-- Junction table indexes for weapon lookups
CREATE INDEX idx_weapon_target_weapon ON weapon_target(weapon_id);
CREATE INDEX idx_weapon_subtype_target_weapon_subtype ON weapon_subtype_target(weapon_subtype_id);