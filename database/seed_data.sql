-- ============================================
-- JTAC Weapon Catalog - Sample Seed Data
-- ============================================
-- IMPORTANT: Run schema.sql FIRST, then this file
-- Order matters due to foreign key constraints

-- ============================================
-- STEP 1: Insert Targets (No dependencies)
-- ============================================
INSERT INTO target (name, category, description) VALUES
('Personnel', 'PERSONNEL', 'Enemy personnel in the open'),
('Personnel in Defilade', 'PERSONNEL', 'Enemy personnel in covered or concealed positions'),
('Light Vehicle', 'VEHICLE', 'Unarmored or lightly armored vehicles (trucks, technicals)'),
('Armored Vehicle', 'VEHICLE', 'Armored personnel carriers, IFVs'),
('Main Battle Tank', 'VEHICLE', 'Heavy armored vehicles with reactive armor'),
('Structure', 'STRUCTURE', 'Buildings, compounds, fixed positions'),
('Bridge', 'STRUCTURE', 'Bridge spans and supports'),
('Bunker', 'FORTIFICATION', 'Reinforced concrete bunkers'),
('Fighting Position', 'FORTIFICATION', 'Dug-in defensive positions, trenches'),
('Radar/SAM Site', 'OTHER', 'Air defense systems and radar installations'),
('Ammunition Cache', 'OTHER', 'Weapons and ammunition storage');

-- ============================================
-- STEP 2: Insert Weapons
-- ============================================
INSERT INTO weapon (name, description, weapon_type, danger_close_contact, danger_close_airburst, warhead_weight, warhead_type, guidance_type, special_notes) VALUES
-- Laser Guided Bombs (Paveway II)
(
    'GBU-12',
    'Paveway II 500lb laser-guided bomb',
    'BOMB',
    100,    -- danger close contact (meters)
    175,    -- danger close airburst (meters)
    192,    -- warhead weight (lbs)
    'HE',
    'LGB',
    'Requires continuous laser designation until impact. Terminal guidance only.'
),
(
    'GBU-10',
    'Paveway II 2000lb laser-guided bomb',
    'BOMB',
    200,    -- danger close contact (meters)
    350,    -- danger close airburst (meters)
    945,    -- warhead weight (lbs)
    'HE',
    'LGB',
    'Requires continuous laser designation. Large blast radius - use caution near friendly forces.'
),
(
    'GBU-16',
    'Paveway II 1000lb laser-guided bomb',
    'BOMB',
    150,    -- danger close contact (meters)
    250,    -- danger close airburst (meters)
    450,    -- warhead weight (lbs)
    'HE',
    'LGB',
    'Requires continuous laser designation until impact.'
),

-- JDAM (GPS Guided)
(
    'GBU-38',
    'JDAM 500lb GPS-guided bomb',
    'BOMB',
    75,     -- danger close contact (meters)
    150,    -- danger close airburst (meters)
    192,    -- warhead weight (lbs)
    'HE',
    'GPS/INS',
    'No laser required. Weather independent. Requires accurate target coordinates.'
),
(
    'GBU-31',
    'JDAM 2000lb GPS-guided bomb',
    'BOMB',
    200,    -- danger close contact (meters)
    400,    -- danger close airburst (meters)
    945,    -- warhead weight (lbs)
    'HE',
    'GPS/INS',
    'No laser required. Weather independent. Large blast radius.'
),
(
    'GBU-32',
    'JDAM 1000lb GPS-guided bomb',
    'BOMB',
    150,    -- danger close contact (meters)
    275,    -- danger close airburst (meters)
    450,    -- warhead weight (lbs)
    'HE',
    'GPS/INS',
    'No laser required. Weather independent.'
),

-- Laser JDAM (Dual-mode)
(
    'GBU-54',
    'Laser JDAM 500lb dual-mode GPS/laser-guided bomb',
    'BOMB',
    75,     -- danger close contact (meters)
    150,    -- danger close airburst (meters)
    192,    -- warhead weight (lbs)
    'HE',
    'GPS/INS + LGB',
    'Can engage moving targets with laser guidance or stationary targets with GPS. Flexible employment.'
),
(
    'GBU-56',
    'Laser JDAM 2000lb dual-mode GPS/laser-guided bomb',
    'BOMB',
    200,    -- danger close contact (meters)
    400,    -- danger close airburst (meters)
    945,    -- warhead weight (lbs)
    'HE',
    'GPS/INS + LGB',
    'Dual-mode guidance. Large warhead for hardened targets.'
),

-- Air-to-Ground Missiles
(
    'AGM-65E',
    'Maverick laser-guided air-to-surface missile',
    'MISSILE',
    150,    -- danger close contact (meters)
    NULL,   -- no airburst option
    136,    -- warhead weight (lbs)
    'Penetrator',
    'Laser',
    'Laser Maverick. Requires continuous laser designation. Effective against vehicles and structures.'
),
(
    'AGM-65G',
    'Maverick IR-guided air-to-surface missile',
    'MISSILE',
    150,    -- danger close contact (meters)
    NULL,   -- no airburst option
    300,    -- warhead weight (lbs)
    'HE',
    'IR',
    'Infrared Maverick. Lock-on before launch. Day/night capability.'
),
(
    'AGM-114K',
    'Hellfire II laser-guided missile',
    'MISSILE',
    200,    -- danger close contact (meters)
    NULL,   -- no airburst option
    20,     -- warhead weight (lbs)
    'HEAT',
    'Laser',
    'SALH guidance. Highly accurate. Can be used in LOBL or LOAL modes.'
),
(
    'AGM-114R',
    'Hellfire Romeo multi-purpose missile',
    'MISSILE',
    200,    -- danger close contact (meters)
    NULL,   -- no airburst option
    18,     -- warhead weight (lbs)
    'Multi-purpose',
    'Laser',
    'Multi-purpose warhead effective against personnel, vehicles, and structures.'
),

-- Rockets
(
    'Hydra 70 HE',
    '2.75 inch unguided rocket with HE warhead',
    'ROCKET',
    200,    -- danger close contact (meters)
    275,    -- danger close airburst (meters)
    17,     -- warhead weight (lbs)
    'HE',
    'Unguided',
    'Typically employed in volleys. Area weapon.'
),
(
    'APKWS',
    'Advanced Precision Kill Weapon System (laser-guided Hydra)',
    'ROCKET',
    100,    -- danger close contact (meters)
    NULL,   -- contact only
    6,      -- warhead weight (lbs)
    'HE',
    'Laser',
    'Precision guided 2.75 inch rocket. Low collateral damage option.'
),

-- Guns
(
    'GAU-8/A',
    '30mm Avenger cannon (A-10)',
    'GUN',
    50,     -- danger close contact (meters)
    NULL,   -- no airburst
    NULL,   -- N/A for guns
    'AP/HEI',
    'Unguided',
    'A-10 specific. 3,900 rounds/min. Highly effective against light armor and personnel.'
),
(
    'M61A1',
    '20mm Vulcan rotary cannon',
    'GUN',
    50,     -- danger close contact (meters)
    NULL,   -- no airburst
    NULL,   -- N/A for guns
    'HEI',
    'Unguided',
    'Standard fighter cannon. 6,000 rounds/min. Strafe attacks.'
),
(
    'GAU-12/U',
    '25mm Equalizer cannon (AV-8B, AC-130)',
    'GUN',
    50,     -- danger close contact (meters)
    NULL,   -- no airburst
    NULL,   -- N/A for guns
    'HEI',
    'Unguided',
    'Medium caliber aircraft cannon. Effective against personnel and light vehicles.'
);

-- ============================================
-- STEP 3: Link Weapons to Targets (Weapon-Target Pairing)
-- ============================================
INSERT INTO weapon_target (weapon_id, target_id, effectiveness_rating, notes) VALUES
-- GBU-12 pairings
(
    (SELECT id FROM weapon WHERE name = 'GBU-12'),
    (SELECT id FROM target WHERE name = 'Structure'),
    'HIGH',
    'Highly effective against fixed structures'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-12'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'HIGH',
    'Precision engagement of vehicles'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-12'),
    (SELECT id FROM target WHERE name = 'Armored Vehicle'),
    'MEDIUM',
    'Can damage/destroy with direct hit'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-12'),
    (SELECT id FROM target WHERE name = 'Bunker'),
    'MEDIUM',
    'May require multiple weapons for hardened bunkers'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-12'),
    (SELECT id FROM target WHERE name = 'Fighting Position'),
    'HIGH',
    'Effective against dug-in positions'
),

-- GBU-10 pairings (2000lb for hard targets)
(
    (SELECT id FROM weapon WHERE name = 'GBU-10'),
    (SELECT id FROM target WHERE name = 'Bunker'),
    'HIGH',
    'Large warhead effective against reinforced structures'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-10'),
    (SELECT id FROM target WHERE name = 'Bridge'),
    'HIGH',
    'Effective for bridge denial'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-10'),
    (SELECT id FROM target WHERE name = 'Structure'),
    'HIGH',
    'Large blast radius - verify collateral damage concerns'
),

-- GBU-38 pairings
(
    (SELECT id FROM weapon WHERE name = 'GBU-38'),
    (SELECT id FROM target WHERE name = 'Structure'),
    'HIGH',
    'Weather-independent, precise GPS guidance'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-38'),
    (SELECT id FROM target WHERE name = 'Fighting Position'),
    'HIGH',
    'Effective against stationary positions'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-38'),
    (SELECT id FROM target WHERE name = 'Ammunition Cache'),
    'HIGH',
    'Precision strike on fixed targets'
),

-- GBU-31 pairings
(
    (SELECT id FROM weapon WHERE name = 'GBU-31'),
    (SELECT id FROM target WHERE name = 'Bunker'),
    'HIGH',
    'Large warhead for hardened targets'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-31'),
    (SELECT id FROM target WHERE name = 'Bridge'),
    'HIGH',
    'Effective for infrastructure denial'
),

-- GBU-54 pairings (can hit movers)
(
    (SELECT id FROM weapon WHERE name = 'GBU-54'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'HIGH',
    'Can engage moving vehicles with laser'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-54'),
    (SELECT id FROM target WHERE name = 'Armored Vehicle'),
    'HIGH',
    'Effective against moving armor'
),
(
    (SELECT id FROM weapon WHERE name = 'GBU-54'),
    (SELECT id FROM target WHERE name = 'Structure'),
    'HIGH',
    'Dual-mode flexibility'
),

-- AGM-65E pairings
(
    (SELECT id FROM weapon WHERE name = 'AGM-65E'),
    (SELECT id FROM target WHERE name = 'Armored Vehicle'),
    'HIGH',
    'Penetrator warhead effective against armor'
),
(
    (SELECT id FROM weapon WHERE name = 'AGM-65E'),
    (SELECT id FROM target WHERE name = 'Main Battle Tank'),
    'HIGH',
    'Designed for anti-armor mission'
),
(
    (SELECT id FROM weapon WHERE name = 'AGM-65E'),
    (SELECT id FROM target WHERE name = 'Bunker'),
    'MEDIUM',
    'Penetrator warhead can defeat some fortifications'
),

-- AGM-65G pairings
(
    (SELECT id FROM weapon WHERE name = 'AGM-65G'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'HIGH',
    'IR seeker locks onto vehicle heat signature'
),
(
    (SELECT id FROM weapon WHERE name = 'AGM-65G'),
    (SELECT id FROM target WHERE name = 'Armored Vehicle'),
    'HIGH',
    'Large warhead effective against APCs/IFVs'
),

-- AGM-114K pairings
(
    (SELECT id FROM weapon WHERE name = 'AGM-114K'),
    (SELECT id FROM target WHERE name = 'Main Battle Tank'),
    'HIGH',
    'HEAT warhead designed for armor defeat'
),
(
    (SELECT id FROM weapon WHERE name = 'AGM-114K'),
    (SELECT id FROM target WHERE name = 'Armored Vehicle'),
    'HIGH',
    'Highly effective against all armor types'
),
(
    (SELECT id FROM weapon WHERE name = 'AGM-114K'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'HIGH',
    'Precision engagement of vehicles'
),

-- AGM-114R pairings (multi-purpose)
(
    (SELECT id FROM weapon WHERE name = 'AGM-114R'),
    (SELECT id FROM target WHERE name = 'Personnel'),
    'HIGH',
    'Multi-purpose warhead effective against troops'
),
(
    (SELECT id FROM weapon WHERE name = 'AGM-114R'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'HIGH',
    'Effective against soft targets'
),
(
    (SELECT id FROM weapon WHERE name = 'AGM-114R'),
    (SELECT id FROM target WHERE name = 'Structure'),
    'MEDIUM',
    'Can engage light structures'
),

-- Hydra 70 pairings
(
    (SELECT id FROM weapon WHERE name = 'Hydra 70 HE'),
    (SELECT id FROM target WHERE name = 'Personnel'),
    'HIGH',
    'Area suppression in volleys'
),
(
    (SELECT id FROM weapon WHERE name = 'Hydra 70 HE'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'MEDIUM',
    'Requires multiple hits, area weapon'
),
(
    (SELECT id FROM weapon WHERE name = 'Hydra 70 HE'),
    (SELECT id FROM target WHERE name = 'Fighting Position'),
    'MEDIUM',
    'Area saturation against positions'
),

-- APKWS pairings
(
    (SELECT id FROM weapon WHERE name = 'APKWS'),
    (SELECT id FROM target WHERE name = 'Personnel'),
    'HIGH',
    'Precision low-collateral option'
),
(
    (SELECT id FROM weapon WHERE name = 'APKWS'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'HIGH',
    'Precision engagement of soft vehicles'
),
(
    (SELECT id FROM weapon WHERE name = 'APKWS'),
    (SELECT id FROM target WHERE name = 'Personnel in Defilade'),
    'MEDIUM',
    'Small warhead may not defeat cover'
),

-- GAU-8/A pairings
(
    (SELECT id FROM weapon WHERE name = 'GAU-8/A'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'HIGH',
    'Devastating against soft vehicles'
),
(
    (SELECT id FROM weapon WHERE name = 'GAU-8/A'),
    (SELECT id FROM target WHERE name = 'Armored Vehicle'),
    'HIGH',
    '30mm AP effective against APCs'
),
(
    (SELECT id FROM weapon WHERE name = 'GAU-8/A'),
    (SELECT id FROM target WHERE name = 'Personnel'),
    'HIGH',
    'Area suppression capability'
),
(
    (SELECT id FROM weapon WHERE name = 'GAU-8/A'),
    (SELECT id FROM target WHERE name = 'Main Battle Tank'),
    'LOW',
    'Top attack angle required, limited effect on modern MBTs'
),

-- M61A1 pairings
(
    (SELECT id FROM weapon WHERE name = 'M61A1'),
    (SELECT id FROM target WHERE name = 'Personnel'),
    'HIGH',
    'High rate of fire for strafe'
),
(
    (SELECT id FROM weapon WHERE name = 'M61A1'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'MEDIUM',
    '20mm limited against vehicles'
),

-- GAU-12/U pairings
(
    (SELECT id FROM weapon WHERE name = 'GAU-12/U'),
    (SELECT id FROM target WHERE name = 'Personnel'),
    'HIGH',
    'Effective suppression'
),
(
    (SELECT id FROM weapon WHERE name = 'GAU-12/U'),
    (SELECT id FROM target WHERE name = 'Light Vehicle'),
    'HIGH',
    '25mm effective against soft vehicles'
),
(
    (SELECT id FROM weapon WHERE name = 'GAU-12/U'),
    (SELECT id FROM target WHERE name = 'Fighting Position'),
    'MEDIUM',
    'Can suppress dug-in positions'
);
