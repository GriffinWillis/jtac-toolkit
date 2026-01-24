-- ============================================
-- JTAC Weapon Catalog - Sample Seed Data
-- ============================================
-- IMPORTANT: Run schema.sql FIRST, then this file
-- Order matters due to foreign key constraints

-- ============================================
-- STEP 1: Insert Guidance Types (No dependencies)
-- ============================================
INSERT INTO guidance_types (name, full_name, description) VALUES
('LGB', 'Laser Guided Bomb', 'Weapon guided by laser designator'),
('GPS', 'GPS Guided', 'Weapon guided by GPS coordinates'),
('INS', 'Inertial Navigation System', 'Weapon guided by inertial navigation'),
('IR', 'Infrared', 'Weapon guided by infrared seeker'),
('EO', 'Electro-Optical', 'Weapon guided by electro-optical seeker'),
('Unguided', 'Unguided', 'Free-fall or unguided weapon');

-- ============================================
-- STEP 2: Insert Aircraft (No dependencies)
-- ============================================
INSERT INTO aircraft (name, designation, service_branch) VALUES
('F-16 Fighting Falcon', 'F-16', 'USAF'),
('A-10 Thunderbolt II', 'A-10', 'USAF'),
('F/A-18 Super Hornet', 'F/A-18', 'USN'),
('F-35 Lightning II', 'F-35', 'USAF'),
('F-15E Strike Eagle', 'F-15E', 'USAF'),
('AV-8B Harrier II', 'AV-8B', 'USMC');

-- ============================================
-- STEP 3: Insert Targets (No dependencies)
-- ============================================
INSERT INTO targets (name, category, description) VALUES
('Personnel', 'PERSONNEL', 'Enemy personnel in the open'),
('Light Vehicle', 'VEHICLE', 'Unarmored or lightly armored vehicles'),
('Heavy Vehicle', 'VEHICLE', 'Armored vehicles, tanks, APCs'),
('Structure', 'STRUCTURE', 'Buildings, bunkers, fixed positions'),
('Soft Target', 'OTHER', 'Unprotected targets, equipment'),
('Hardened Target', 'STRUCTURE', 'Reinforced structures, bunkers');

-- ============================================
-- STEP 4: Insert Weapons (No dependencies)
-- ============================================
INSERT INTO weapons (name, designation, weapon_type, description, danger_close, special_notes) VALUES
('GBU-12 Paveway II', 'GBU-12', 'BOMB', '500lb laser-guided bomb', 100, 'Requires continuous laser designation until impact'),
('GBU-38 JDAM', 'GBU-38', 'BOMB', '500lb GPS-guided bomb', 75, 'No laser required, weather independent, can be used in all conditions'),
('GBU-54 Laser JDAM', 'GBU-54', 'BOMB', '500lb dual-mode GPS/laser-guided bomb', 75, 'Can use GPS or laser guidance, flexible employment'),
('AGM-65 Maverick', 'AGM-65', 'MISSILE', 'Air-to-surface missile', 150, 'Multiple seeker variants (IR, EO, laser), effective against vehicles'),
('AGM-114 Hellfire', 'AGM-114', 'MISSILE', 'Air-to-surface missile', 200, 'Primarily used by helicopters, can be employed by fixed-wing'),
('Hydra 70 Rocket', 'Hydra 70', 'ROCKET', '2.75 inch unguided rocket', 200, 'Various warhead options, typically used in volleys'),
('30mm GAU-8', 'GAU-8', 'GUN', '30mm cannon', 50, 'A-10 specific, high rate of fire, effective against light armor'),
('20mm M61 Vulcan', 'M61', 'GUN', '20mm rotary cannon', 50, 'Standard aircraft cannon, high rate of fire');

-- ============================================
-- STEP 5: Link Weapons to Guidance Types
-- ============================================
INSERT INTO weapon_guidance (weapon_id, guidance_id, is_primary) VALUES
(
    (SELECT id FROM weapons WHERE designation = 'GBU-12'),
    (SELECT id FROM guidance_types WHERE name = 'LGB'),
    TRUE
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-38'),
    (SELECT id FROM guidance_types WHERE name = 'GPS'),
    TRUE
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-54'),
    (SELECT id FROM guidance_types WHERE name = 'GPS'),
    TRUE
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-54'),
    (SELECT id FROM guidance_types WHERE name = 'LGB'),
    FALSE
),
(
    (SELECT id FROM weapons WHERE designation = 'AGM-65'),
    (SELECT id FROM guidance_types WHERE name = 'IR'),
    TRUE
),
(
    (SELECT id FROM weapons WHERE designation = 'AGM-114'),
    (SELECT id FROM guidance_types WHERE name = 'LGB'),
    TRUE
),
(
    (SELECT id FROM weapons WHERE designation = 'Hydra 70'),
    (SELECT id FROM guidance_types WHERE name = 'Unguided'),
    TRUE
),
(
    (SELECT id FROM weapons WHERE designation = 'GAU-8'),
    (SELECT id FROM guidance_types WHERE name = 'Unguided'),
    TRUE
),
(
    (SELECT id FROM weapons WHERE designation = 'M61'),
    (SELECT id FROM guidance_types WHERE name = 'Unguided'),
    TRUE
);

-- ============================================
-- STEP 6: Link Weapons to Aircraft
-- ============================================
INSERT INTO weapon_aircraft (weapon_id, aircraft_id, notes) VALUES
-- GBU-12
(
    (SELECT id FROM weapons WHERE designation = 'GBU-12'),
    (SELECT id FROM aircraft WHERE designation = 'F-16'),
    NULL
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-12'),
    (SELECT id FROM aircraft WHERE designation = 'A-10'),
    NULL
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-12'),
    (SELECT id FROM aircraft WHERE designation = 'F/A-18'),
    NULL
),
-- GBU-38
(
    (SELECT id FROM weapons WHERE designation = 'GBU-38'),
    (SELECT id FROM aircraft WHERE designation = 'F-16'),
    NULL
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-38'),
    (SELECT id FROM aircraft WHERE designation = 'F-15E'),
    NULL
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-38'),
    (SELECT id FROM aircraft WHERE designation = 'F/A-18'),
    NULL
),
-- GBU-54
(
    (SELECT id FROM weapons WHERE designation = 'GBU-54'),
    (SELECT id FROM aircraft WHERE designation = 'F-16'),
    NULL
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-54'),
    (SELECT id FROM aircraft WHERE designation = 'F-15E'),
    NULL
),
-- AGM-65
(
    (SELECT id FROM weapons WHERE designation = 'AGM-65'),
    (SELECT id FROM aircraft WHERE designation = 'A-10'),
    NULL
),
(
    (SELECT id FROM weapons WHERE designation = 'AGM-65'),
    (SELECT id FROM aircraft WHERE designation = 'F-16'),
    NULL
),
-- GAU-8 (A-10 only)
(
    (SELECT id FROM weapons WHERE designation = 'GAU-8'),
    (SELECT id FROM aircraft WHERE designation = 'A-10'),
    'A-10 specific weapon system'
),
-- M61 (multiple aircraft)
(
    (SELECT id FROM weapons WHERE designation = 'M61'),
    (SELECT id FROM aircraft WHERE designation = 'F-16'),
    NULL
),
(
    (SELECT id FROM weapons WHERE designation = 'M61'),
    (SELECT id FROM aircraft WHERE designation = 'F/A-18'),
    NULL
);

-- ============================================
-- STEP 7: Link Weapons to Targets (Weapon-Target Pairing)
-- ============================================
INSERT INTO weapon_target (weapon_id, target_id, effectiveness_rating, notes) VALUES
-- GBU-12 pairings
(
    (SELECT id FROM weapons WHERE designation = 'GBU-12'),
    (SELECT id FROM targets WHERE name = 'Structure'),
    'HIGH',
    'Highly effective against fixed structures'
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-12'),
    (SELECT id FROM targets WHERE name = 'Light Vehicle'),
    'MEDIUM',
    'Can be used but may be overkill for unarmored vehicles'
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-12'),
    (SELECT id FROM targets WHERE name = 'Hardened Target'),
    'HIGH',
    'Effective against reinforced structures'
),
-- GBU-38 pairings
(
    (SELECT id FROM weapons WHERE designation = 'GBU-38'),
    (SELECT id FROM targets WHERE name = 'Structure'),
    'HIGH',
    'Weather-independent, precise GPS guidance'
),
(
    (SELECT id FROM weapons WHERE designation = 'GBU-38'),
    (SELECT id FROM targets WHERE name = 'Hardened Target'),
    'MEDIUM',
    'May require multiple impacts for heavily reinforced targets'
),
-- AGM-65 pairings
(
    (SELECT id FROM weapons WHERE designation = 'AGM-65'),
    (SELECT id FROM targets WHERE name = 'Heavy Vehicle'),
    'HIGH',
    'Designed specifically for armored targets'
),
(
    (SELECT id FROM weapons WHERE designation = 'AGM-65'),
    (SELECT id FROM targets WHERE name = 'Light Vehicle'),
    'HIGH',
    'Very effective against vehicles'
),
-- GAU-8 pairings
(
    (SELECT id FROM weapons WHERE designation = 'GAU-8'),
    (SELECT id FROM targets WHERE name = 'Light Vehicle'),
    'HIGH',
    'High rate of fire, effective against light armor'
),
(
    (SELECT id FROM weapons WHERE designation = 'GAU-8'),
    (SELECT id FROM targets WHERE name = 'Personnel'),
    'HIGH',
    'Area suppression capability'
),
-- M61 pairings
(
    (SELECT id FROM weapons WHERE designation = 'M61'),
    (SELECT id FROM targets WHERE name = 'Personnel'),
    'HIGH',
    'Area suppression, high rate of fire'
),
(
    (SELECT id FROM weapons WHERE designation = 'M61'),
    (SELECT id FROM targets WHERE name = 'Light Vehicle'),
    'MEDIUM',
    'Effective but limited penetration'
);