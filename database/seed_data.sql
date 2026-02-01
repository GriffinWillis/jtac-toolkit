-- ============================================
-- JTAC Weapon Catalog - Sample Seed Data
-- ============================================
--
-- DISCLAIMER: This is SAMPLE DATA for demonstration purposes only.
-- All values are approximate and derived from publicly available sources.
-- This is NOT operational data and should NOT be used for real-world
-- fire support coordination. Consult official publications (JFIRE, etc.)
-- for authoritative weapon employment data.
--
-- ============================================
-- IMPORTANT: Run schema.sql FIRST, then this file
-- Order matters due to foreign key constraints

-- ============================================
-- STEP 1: Insert Weapon Types
-- ============================================
INSERT INTO weapon_type (name) VALUES
('BOMB'),
('MISSILE'),
('ROCKET'),
('GUN');

-- ============================================
-- STEP 2: Insert Weapon Subtypes (JFIRE categories)
-- ============================================
INSERT INTO weapon_subtype (weapon_type_id, name) VALUES
-- BOMB subtypes
((SELECT id FROM weapon_type WHERE name = 'BOMB'), 'GP'),
((SELECT id FROM weapon_type WHERE name = 'BOMB'), 'JDAM'),
((SELECT id FROM weapon_type WHERE name = 'BOMB'), 'LJDAM'),
((SELECT id FROM weapon_type WHERE name = 'BOMB'), 'LGB'),
((SELECT id FROM weapon_type WHERE name = 'BOMB'), 'SDB'),
-- MISSILE subtypes
((SELECT id FROM weapon_type WHERE name = 'MISSILE'), 'HELLFIRE'),
((SELECT id FROM weapon_type WHERE name = 'MISSILE'), 'MAVERICK'),
-- ROCKET subtypes
((SELECT id FROM weapon_type WHERE name = 'ROCKET'), 'GUIDED'),
((SELECT id FROM weapon_type WHERE name = 'ROCKET'), 'UNGUIDED'),
-- GUN subtypes
((SELECT id FROM weapon_type WHERE name = 'GUN'), 'FW'),
((SELECT id FROM weapon_type WHERE name = 'GUN'), 'RW');

-- ============================================
-- STEP 3: Insert Targets
-- ============================================
INSERT INTO target (name, category) VALUES
('Radars', 'OTHER'),
('Soft Targets, Static Vehicles, Aircraft in the Open', 'VEHICLE'),
('Moving Vehicles', 'VEHICLE'),
('Armored Vehicles: Tanks, APCs', 'VEHICLE'),
('Personnel: Individuals/Small Groups', 'PERSONNEL'),
('Personnel: Large Group', 'PERSONNEL'),
('Buildings', 'STRUCTURE'),
('Artillery Fixed AAA in Open', 'OTHER'),
('Hardened Position - Targets in Revetments', 'FORTIFICATION'),
('Self-Propelled SAM and AAA', 'OTHER');

-- ============================================
-- STEP 4: Insert Weapons
-- ============================================
INSERT INTO weapon (weapon_subtype_id, name, description, guidance_type, danger_close_contact, danger_close_airburst, weight, warhead_type, special_notes) VALUES
-- Laser Guided Bombs (Paveway II)
(
    (SELECT id FROM weapon_subtype WHERE name = 'LGB'),
    'GBU-12',
    'Paveway II 500lb laser-guided bomb',
    'LASER',
    100,    -- danger close contact (meters)
    175,    -- danger close airburst (meters)
    500,    -- weight (lbs)
    'HE',
    'Requires continuous laser designation until impact. Terminal guidance only.'
),
(
    (SELECT id FROM weapon_subtype WHERE name = 'LGB'),
    'GBU-10',
    'Paveway II 2000lb laser-guided bomb',
    'LASER',
    200,    -- danger close contact (meters)
    350,    -- danger close airburst (meters)
    2000,   -- weight (lbs)
    'HE',
    'Requires continuous laser designation. Large blast radius - use caution near friendly forces.'
),
(
    (SELECT id FROM weapon_subtype WHERE name = 'LGB'),
    'GBU-16',
    'Paveway II 1000lb laser-guided bomb',
    'LASER',
    150,    -- danger close contact (meters)
    250,    -- danger close airburst (meters)
    1000,   -- weight (lbs)
    'HE',
    'Requires continuous laser designation until impact.'
),

-- JDAM (GPS Guided)
(
    (SELECT id FROM weapon_subtype WHERE name = 'JDAM'),
    'GBU-38',
    'JDAM 500lb GPS-guided bomb',
    'GPS/INS',
    75,     -- danger close contact (meters)
    150,    -- danger close airburst (meters)
    500,    -- weight (lbs)
    'HE',
    'No laser required. Weather independent. Requires accurate target coordinates.'
),
(
    (SELECT id FROM weapon_subtype WHERE name = 'JDAM'),
    'GBU-31',
    'JDAM 2000lb GPS-guided bomb',
    'GPS/INS',
    200,    -- danger close contact (meters)
    400,    -- danger close airburst (meters)
    2000,   -- weight (lbs)
    'HE',
    'No laser required. Weather independent. Large blast radius.'
),
(
    (SELECT id FROM weapon_subtype WHERE name = 'JDAM'),
    'GBU-32',
    'JDAM 1000lb GPS-guided bomb',
    'GPS/INS',
    150,    -- danger close contact (meters)
    275,    -- danger close airburst (meters)
    1000,   -- weight (lbs)
    'HE',
    'No laser required. Weather independent.'
),

-- Laser JDAM (Dual-mode)
(
    (SELECT id FROM weapon_subtype WHERE name = 'LJDAM'),
    'GBU-54',
    'Laser JDAM 500lb dual-mode GPS/laser-guided bomb',
    'GPS/INS + LASER',
    75,     -- danger close contact (meters)
    150,    -- danger close airburst (meters)
    500,    -- weight (lbs)
    'HE',
    'Can engage moving targets with laser guidance or stationary targets with GPS. Flexible employment.'
),
(
    (SELECT id FROM weapon_subtype WHERE name = 'LJDAM'),
    'GBU-56',
    'Laser JDAM 2000lb dual-mode GPS/laser-guided bomb',
    'GPS/INS + LASER',
    200,    -- danger close contact (meters)
    400,    -- danger close airburst (meters)
    2000,   -- weight (lbs)
    'HE',
    'Dual-mode guidance. Large warhead for hardened targets.'
),

-- Small Diameter Bomb
(
    (SELECT id FROM weapon_subtype WHERE name = 'SDB'),
    'GBU-39',
    'Small Diameter Bomb',
    'GPS/INS',
    25,     -- danger close contact (meters)
    50,     -- danger close airburst (meters)
    250,    -- weight (lbs)
    'HE',
    'Low collateral damage option. Precision strike in urban environments.'
),

-- General Purpose Bombs (Unguided)
(
    (SELECT id FROM weapon_subtype WHERE name = 'GP'),
    'Mk-82',
    '500lb general purpose bomb',
    'UNGUIDED',
    300,    -- danger close contact (meters)
    400,    -- danger close airburst (meters)
    500,    -- weight (lbs)
    'HE',
    'Unguided free-fall bomb. Area weapon. Requires accurate delivery parameters.'
),
(
    (SELECT id FROM weapon_subtype WHERE name = 'GP'),
    'Mk-84',
    '2000lb general purpose bomb',
    'UNGUIDED',
    400,    -- danger close contact (meters)
    600,    -- danger close airburst (meters)
    2000,   -- weight (lbs)
    'HE',
    'Unguided free-fall bomb. Large blast radius. Area weapon.'
),

-- Hellfire Missiles
(
    (SELECT id FROM weapon_subtype WHERE name = 'HELLFIRE'),
    'AGM-114K',
    'Hellfire II laser-guided missile',
    'LASER',
    200,    -- danger close contact (meters)
    NULL,   -- no airburst option
    100,    -- weight (lbs)
    'HEAT',
    'SALH guidance. Highly accurate. Can be used in LOBL or LOAL modes.'
),
(
    (SELECT id FROM weapon_subtype WHERE name = 'HELLFIRE'),
    'AGM-114R',
    'Hellfire Romeo multi-purpose missile',
    'LASER',
    200,    -- danger close contact (meters)
    NULL,   -- no airburst option
    100,    -- weight (lbs)
    'Multi-purpose',
    'Multi-purpose warhead effective against personnel, vehicles, and structures.'
),

-- Maverick Missiles
(
    (SELECT id FROM weapon_subtype WHERE name = 'MAVERICK'),
    'AGM-65E',
    'Maverick laser-guided air-to-surface missile',
    'LASER',
    150,    -- danger close contact (meters)
    NULL,   -- no airburst option
    670,    -- weight (lbs)
    'Penetrator',
    'Laser Maverick. Requires continuous laser designation. Effective against vehicles and structures.'
),
(
    (SELECT id FROM weapon_subtype WHERE name = 'MAVERICK'),
    'AGM-65G',
    'Maverick IR-guided air-to-surface missile',
    'IR',
    150,    -- danger close contact (meters)
    NULL,   -- no airburst option
    670,    -- weight (lbs)
    'HE',
    'Infrared Maverick. Lock-on before launch. Day/night capability.'
),

-- Guided Rockets
(
    (SELECT id FROM weapon_subtype WHERE name = 'GUIDED'),
    'APKWS',
    'Advanced Precision Kill Weapon System (laser-guided Hydra)',
    'LASER',
    100,    -- danger close contact (meters)
    NULL,   -- contact only
    32,     -- weight (lbs)
    'HE',
    'Precision guided 2.75 inch rocket. Low collateral damage option.'
),

-- Unguided Rockets
(
    (SELECT id FROM weapon_subtype WHERE name = 'UNGUIDED'),
    'Hydra 70 HE',
    '2.75 inch unguided rocket with HE warhead',
    'UNGUIDED',
    200,    -- danger close contact (meters)
    275,    -- danger close airburst (meters)
    24,     -- weight (lbs)
    'HE',
    'Typically employed in volleys. Area weapon.'
),

-- Fixed-Wing Guns
(
    (SELECT id FROM weapon_subtype WHERE name = 'FW'),
    'GAU-8/A',
    '30mm Avenger cannon (A-10)',
    'UNGUIDED',
    50,     -- danger close contact (meters)
    NULL,   -- no airburst
    NULL,   -- N/A for guns
    'AP/HEI',
    'A-10 specific. 3,900 rounds/min. Highly effective against light armor and personnel.'
),
(
    (SELECT id FROM weapon_subtype WHERE name = 'FW'),
    'M61A1',
    '20mm Vulcan rotary cannon',
    'UNGUIDED',
    50,     -- danger close contact (meters)
    NULL,   -- no airburst
    NULL,   -- N/A for guns
    'HEI',
    'Standard fighter cannon. 6,000 rounds/min. Strafe attacks.'
),

-- Rotary-Wing Guns
(
    (SELECT id FROM weapon_subtype WHERE name = 'RW'),
    'GAU-21',
    '.50 cal door gun',
    'UNGUIDED',
    50,     -- danger close contact (meters)
    NULL,   -- no airburst
    NULL,   -- N/A for guns
    'AP/Ball',
    'Helicopter door-mounted heavy machine gun. Suppression and personnel targets.'
);

-- ============================================
-- STEP 5: Insert Weapon Subtype-Target Pairings
-- Default effectiveness based on JFIRE guidance
-- ============================================

-- LGB effective targets
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'LGB'), (SELECT id FROM target WHERE name = 'Buildings')),
((SELECT id FROM weapon_subtype WHERE name = 'LGB'), (SELECT id FROM target WHERE name = 'Armored Vehicles: Tanks, APCs')),
((SELECT id FROM weapon_subtype WHERE name = 'LGB'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'LGB'), (SELECT id FROM target WHERE name = 'Hardened Position - Targets in Revetments')),
((SELECT id FROM weapon_subtype WHERE name = 'LGB'), (SELECT id FROM target WHERE name = 'Artillery Fixed AAA in Open')),
((SELECT id FROM weapon_subtype WHERE name = 'LGB'), (SELECT id FROM target WHERE name = 'Self-Propelled SAM and AAA')),
((SELECT id FROM weapon_subtype WHERE name = 'LGB'), (SELECT id FROM target WHERE name = 'Radars'));

-- JDAM effective targets
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'JDAM'), (SELECT id FROM target WHERE name = 'Buildings')),
((SELECT id FROM weapon_subtype WHERE name = 'JDAM'), (SELECT id FROM target WHERE name = 'Armored Vehicles: Tanks, APCs')),
((SELECT id FROM weapon_subtype WHERE name = 'JDAM'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'JDAM'), (SELECT id FROM target WHERE name = 'Hardened Position - Targets in Revetments')),
((SELECT id FROM weapon_subtype WHERE name = 'JDAM'), (SELECT id FROM target WHERE name = 'Artillery Fixed AAA in Open')),
((SELECT id FROM weapon_subtype WHERE name = 'JDAM'), (SELECT id FROM target WHERE name = 'Self-Propelled SAM and AAA')),
((SELECT id FROM weapon_subtype WHERE name = 'JDAM'), (SELECT id FROM target WHERE name = 'Radars'));

-- LJDAM effective targets (same as JDAM + moving vehicles)
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'LJDAM'), (SELECT id FROM target WHERE name = 'Buildings')),
((SELECT id FROM weapon_subtype WHERE name = 'LJDAM'), (SELECT id FROM target WHERE name = 'Armored Vehicles: Tanks, APCs')),
((SELECT id FROM weapon_subtype WHERE name = 'LJDAM'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'LJDAM'), (SELECT id FROM target WHERE name = 'Moving Vehicles')),
((SELECT id FROM weapon_subtype WHERE name = 'LJDAM'), (SELECT id FROM target WHERE name = 'Hardened Position - Targets in Revetments')),
((SELECT id FROM weapon_subtype WHERE name = 'LJDAM'), (SELECT id FROM target WHERE name = 'Artillery Fixed AAA in Open')),
((SELECT id FROM weapon_subtype WHERE name = 'LJDAM'), (SELECT id FROM target WHERE name = 'Self-Propelled SAM and AAA')),
((SELECT id FROM weapon_subtype WHERE name = 'LJDAM'), (SELECT id FROM target WHERE name = 'Radars'));

-- SDB effective targets (low collateral, precision)
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'SDB'), (SELECT id FROM target WHERE name = 'Buildings')),
((SELECT id FROM weapon_subtype WHERE name = 'SDB'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'SDB'), (SELECT id FROM target WHERE name = 'Artillery Fixed AAA in Open')),
((SELECT id FROM weapon_subtype WHERE name = 'SDB'), (SELECT id FROM target WHERE name = 'Radars'));

-- GP (unguided bombs) effective targets (area weapons)
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'GP'), (SELECT id FROM target WHERE name = 'Buildings')),
((SELECT id FROM weapon_subtype WHERE name = 'GP'), (SELECT id FROM target WHERE name = 'Personnel: Large Group')),
((SELECT id FROM weapon_subtype WHERE name = 'GP'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'GP'), (SELECT id FROM target WHERE name = 'Hardened Position - Targets in Revetments')),
((SELECT id FROM weapon_subtype WHERE name = 'GP'), (SELECT id FROM target WHERE name = 'Artillery Fixed AAA in Open'));

-- HELLFIRE effective targets
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'HELLFIRE'), (SELECT id FROM target WHERE name = 'Armored Vehicles: Tanks, APCs')),
((SELECT id FROM weapon_subtype WHERE name = 'HELLFIRE'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'HELLFIRE'), (SELECT id FROM target WHERE name = 'Moving Vehicles')),
((SELECT id FROM weapon_subtype WHERE name = 'HELLFIRE'), (SELECT id FROM target WHERE name = 'Buildings')),
((SELECT id FROM weapon_subtype WHERE name = 'HELLFIRE'), (SELECT id FROM target WHERE name = 'Self-Propelled SAM and AAA')),
((SELECT id FROM weapon_subtype WHERE name = 'HELLFIRE'), (SELECT id FROM target WHERE name = 'Radars'));

-- MAVERICK effective targets
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'MAVERICK'), (SELECT id FROM target WHERE name = 'Armored Vehicles: Tanks, APCs')),
((SELECT id FROM weapon_subtype WHERE name = 'MAVERICK'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'MAVERICK'), (SELECT id FROM target WHERE name = 'Moving Vehicles')),
((SELECT id FROM weapon_subtype WHERE name = 'MAVERICK'), (SELECT id FROM target WHERE name = 'Buildings')),
((SELECT id FROM weapon_subtype WHERE name = 'MAVERICK'), (SELECT id FROM target WHERE name = 'Hardened Position - Targets in Revetments')),
((SELECT id FROM weapon_subtype WHERE name = 'MAVERICK'), (SELECT id FROM target WHERE name = 'Self-Propelled SAM and AAA'));

-- GUIDED rockets (APKWS) effective targets
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'GUIDED'), (SELECT id FROM target WHERE name = 'Personnel: Individuals/Small Groups')),
((SELECT id FROM weapon_subtype WHERE name = 'GUIDED'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'GUIDED'), (SELECT id FROM target WHERE name = 'Moving Vehicles')),
((SELECT id FROM weapon_subtype WHERE name = 'GUIDED'), (SELECT id FROM target WHERE name = 'Artillery Fixed AAA in Open'));

-- UNGUIDED rockets effective targets (area suppression)
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'UNGUIDED'), (SELECT id FROM target WHERE name = 'Personnel: Individuals/Small Groups')),
((SELECT id FROM weapon_subtype WHERE name = 'UNGUIDED'), (SELECT id FROM target WHERE name = 'Personnel: Large Group')),
((SELECT id FROM weapon_subtype WHERE name = 'UNGUIDED'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'UNGUIDED'), (SELECT id FROM target WHERE name = 'Artillery Fixed AAA in Open'));

-- FW (fixed-wing guns) effective targets
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'FW'), (SELECT id FROM target WHERE name = 'Personnel: Individuals/Small Groups')),
((SELECT id FROM weapon_subtype WHERE name = 'FW'), (SELECT id FROM target WHERE name = 'Personnel: Large Group')),
((SELECT id FROM weapon_subtype WHERE name = 'FW'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open')),
((SELECT id FROM weapon_subtype WHERE name = 'FW'), (SELECT id FROM target WHERE name = 'Moving Vehicles')),
((SELECT id FROM weapon_subtype WHERE name = 'FW'), (SELECT id FROM target WHERE name = 'Armored Vehicles: Tanks, APCs'));

-- RW (rotary-wing guns) effective targets
INSERT INTO weapon_subtype_target (weapon_subtype_id, target_id) VALUES
((SELECT id FROM weapon_subtype WHERE name = 'RW'), (SELECT id FROM target WHERE name = 'Personnel: Individuals/Small Groups')),
((SELECT id FROM weapon_subtype WHERE name = 'RW'), (SELECT id FROM target WHERE name = 'Personnel: Large Group')),
((SELECT id FROM weapon_subtype WHERE name = 'RW'), (SELECT id FROM target WHERE name = 'Soft Targets, Static Vehicles, Aircraft in the Open'));

-- ============================================
-- STEP 6: Insert Weapon-Target Pairings (Weapon-Specific Overrides)
-- Only needed when a specific weapon differs from its subtype defaults
-- ============================================

-- GAU-8/A (A-10 gun) is particularly effective against armor due to 30mm AP rounds
-- Already covered by FW subtype, but this is an example of how to add weapon-specific pairings
-- No overrides needed for initial data - subtype pairings are sufficient
