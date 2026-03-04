Config = Config or {}

Config.Debug = false

Config.OpenKey = 243

Config.noLockVehicleClasses = {
    [8] = true,   -- Motorcycles
    [13] = true,  -- Cycles
    [14] = true,  -- Boats
    [15] = true,  -- Helicopters
    [16] = true,  -- Planes
}

Config.nonFuelVehicleClasses = {
    [13] = true, -- Cycles
    [21] = true, -- Trains
}

Config.DriveModes = {
    ECO = {
        powerMultiplier = 0.6,
        maxSpeed = 80.0, -- km/h (0 = unlimited)
        label = 'ECO',
    },
    STANDARD = {
        powerMultiplier = 1.0,
        maxSpeed = 0,
        label = 'STANDARD',
    },
    SPORTS = {
        powerMultiplier = 1.3,
        maxSpeed = 0,
        label = 'SPORTS',
    },
}

Config.classPerformanceConfig = {
    [0]  = { maxGear = 5, power = 0.45 },  -- Compacts
    [1]  = { maxGear = 5, power = 0.45 },  -- Sedans
    [2]  = { maxGear = 5, power = 0.45 },  -- SUVs
    [3]  = { maxGear = 5, power = 0.45 },  -- Coupes
    [4]  = { maxGear = 5, power = 0.5 },   -- Muscle
    [5]  = { maxGear = 5, power = 0.55 },  -- Sports Classics
    [6]  = { maxGear = 6, power = 0.6 },   -- Sports
    [7]  = { maxGear = 6, power = 0.7 },   -- Super
    [8]  = { maxGear = 6, power = 0.7 },   -- Motorcycles
    [9]  = { maxGear = 5, power = 0.45 },  -- Off-road
    [10] = { maxGear = 4, power = 0.4 },   -- Industrial
    [11] = { maxGear = 4, power = 0.4 },   -- Utility
    [12] = { maxGear = 4, power = 0.4 },   -- Vans
}

Config.modelPerformanceConfig = {
    -- [GetHashKey('sultan')] = { maxGear = 6, power = 0.65 },
}

Config.PremiumVehicles = {
    [GetHashKey('adder')] = true,
    [GetHashKey('zentorno')] = true,
    [GetHashKey('t20')] = true,
    [GetHashKey('osiris')] = true,
    [GetHashKey('entityxf')] = true,
    [GetHashKey('turismor')] = true,
    [GetHashKey('reaper')] = true,
    [GetHashKey('nero')] = true,
    [GetHashKey('nero2')] = true,
    [GetHashKey('tempesta')] = true,
    [GetHashKey('vagner')] = true,
    [GetHashKey('tezeract')] = true,
    [GetHashKey('thrax')] = true,
    [GetHashKey('emerus')] = true,
    [GetHashKey('krieger')] = true,
    [GetHashKey('s80')] = true,
    [GetHashKey('furia')] = true,
    [GetHashKey('tigon')] = true,
    [GetHashKey('zorrusso')] = true,
    [GetHashKey('sc1')] = true,
    [GetHashKey('pariah')] = true,
    [GetHashKey('italigtb')] = true,
    [GetHashKey('italigtb2')] = true,
}

Config.PremiumVehicleClasses = {
    [7] = false,  -- Super
}

Config.Seatbelt = {
    -- 'mst_seatbelt' or 'builtin'
    system = 'mst_seatbelt',

    builtin = {
        ejectSpeed = 50.0,
        ejectForce = 18.0,
        damageMultiplier = 0.5,
    },
}
