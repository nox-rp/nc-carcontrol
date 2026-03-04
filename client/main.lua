local nuiOpen = false
local currentVehicle = nil
local isPremiumVehicle = false
local ignitionState = 'LOCK'
local seatbeltOn = false
local cruiseActive = false
local cruiseSpeed = 0
local cruiseLimiter = false
local cruiseUnit = 'mph'

local function CruiseToMps(displaySpeed, unit)
    if unit == 'mph' then
        return displaySpeed * 0.44704
    else
        return displaySpeed / 3.6
    end
end

local function MpsToCruise(mps, unit)
    if unit == 'mph' then
        return math.floor(mps / 0.44704)
    else
        return math.floor(mps * 3.6)
    end
end

local states = {
    engine = false,
    locked = false,
    driveMode = 'STANDARD',
}
local vehicleStates = {}

local function DoesVehicleNeedFuel(vehicle)
    if not vehicle or vehicle == 0 then return false end
    return not Config.nonFuelVehicleClasses[GetVehicleClass(vehicle)]
end

local function IsInDriverSeat(vehicle)
    if not vehicle or vehicle == 0 then return false end
    return GetPedInVehicleSeat(vehicle, -1) == PlayerPedId()
end

local function GetClosestVehicleToPlayer()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 70)
    if vehicle == 0 then vehicle = nil end
    return vehicle
end

local function FlashVehicleLights(veh)
    Citizen.CreateThread(function()
        SetVehicleLights(veh, 2)
        Wait(250)
        SetVehicleLights(veh, 1)
        Wait(200)
        SetVehicleLights(veh, 0)
    end)
end

local function PlayKeyFobAnimation()
    local ped = PlayerPedId()
    local dict = "anim@mp_player_intmenu@key_fob@"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do Wait(0) end
    TaskPlayAnim(ped, dict, 'fob_click', 3.0, 3.0, -1, 49, 0, false, false, false)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
end

local function IsPremiumVehicle(vehicle)
    if not vehicle or vehicle == 0 then return false end
    local model = GetEntityModel(vehicle)
    if Config.PremiumVehicles and Config.PremiumVehicles[model] then
        return true
    end
    local class = GetVehicleClass(vehicle)
    if Config.PremiumVehicleClasses and Config.PremiumVehicleClasses[class] then
        return true
    end
    return false
end

local function ApplyDriveMode(vehicle)
    if not vehicle or vehicle == 0 then return end

    local model = GetEntityModel(vehicle)
    local cfg = Config.modelPerformanceConfig and Config.modelPerformanceConfig[model]

    if not cfg then
        local class = GetVehicleClass(vehicle)
        cfg = Config.classPerformanceConfig[class]
    end

    if not cfg then
        cfg = { maxGear = 5, power = 0.6 }
    end

    if cfg.maxGear and cfg.maxGear > 0 then
        SetVehicleHighGear(vehicle, cfg.maxGear)
    end

    local modeConfig = Config.DriveModes[states.driveMode] or Config.DriveModes['STANDARD']
    local basePower = cfg.power or 0.6
    local finalPower = basePower * (modeConfig.powerMultiplier or 1.0)

    SetVehicleCheatPowerIncrease(vehicle, finalPower)

    local maxSpeedKmh = modeConfig.maxSpeed or 0
    if maxSpeedKmh > 0 then
        local maxSpeedMs = maxSpeedKmh / 3.6
        SetEntityMaxSpeed(vehicle, maxSpeedMs)
    else
        SetEntityMaxSpeed(vehicle, 500.0)
    end
end

local function SaveVehicleState()
    if currentVehicle then
        vehicleStates[currentVehicle] = {
            engine = states.engine,
            locked = states.locked,
            driveMode = states.driveMode,
        }
    end
end

local function LoadVehicleState()
    if currentVehicle and vehicleStates[currentVehicle] then
        local saved = vehicleStates[currentVehicle]
        states.engine = saved.engine or false
        states.locked = saved.locked or false
        states.driveMode = saved.driveMode or 'STANDARD'
        SetVehicleEngineOn(currentVehicle, states.engine, false, false)
        SetVehicleDoorsLocked(currentVehicle, states.locked and 2 or 1)
    else
        states.engine = currentVehicle and GetIsVehicleEngineRunning(currentVehicle) or false
        states.locked = false
        states.driveMode = 'STANDARD'
    end
end

local function UpdateNUIStates()
    SendNUIMessage({
        type = "updateStates",
        engine = states.engine,
        locked = states.locked,
        driveMode = states.driveMode,
        isPremium = isPremiumVehicle,
        ignitionState = ignitionState,
        seatbelt = seatbeltOn,
        cruiseActive = cruiseActive,
        cruiseSpeed = cruiseSpeed,
        cruiseLimiter = cruiseLimiter,
    })
end

local function ShowNUI(show)
    nuiOpen = show
    if show then
        SetNuiFocusKeepInput(true)
        SetNuiFocus(true, true)
        SendNUIMessage({ type = "toggle", show = true, isPremium = isPremiumVehicle })
        UpdateNUIStates()
    else
        SetNuiFocusKeepInput(false)
        SetNuiFocus(false, false)
        SendNUIMessage({ type = "toggle", show = false })
    end
end

local function SetIgnitionState(newState)
    if not currentVehicle or not IsInDriverSeat(currentVehicle) then return end
    if not DoesVehicleNeedFuel(currentVehicle) then return end

    ignitionState = newState

    if newState == 'START' then
        SetVehicleEngineOn(currentVehicle, true, false, false)
        states.engine = true
        SaveVehicleState()
        Citizen.SetTimeout(800, function()
            if ignitionState == 'START' then
                ignitionState = 'ON'
                UpdateNUIStates()
            end
        end)
    elseif newState == 'ON' then
    elseif newState == 'ACC' then
        if states.engine then
            states.engine = false
            SetVehicleEngineOn(currentVehicle, false, false, false)
            SaveVehicleState()
        end
    elseif newState == 'LOCK' then
        if states.engine then
            states.engine = false
            SetVehicleEngineOn(currentVehicle, false, false, false)
            SaveVehicleState()
        end
    end

    UpdateNUIStates()
end

RegisterNUICallback('engineToggle', function(data, cb)
    if currentVehicle and DoesVehicleNeedFuel(currentVehicle) and IsInDriverSeat(currentVehicle) then
        states.engine = not states.engine
        SetVehicleEngineOn(currentVehicle, states.engine, false, false)
        SaveVehicleState()
        UpdateNUIStates()
    end
    cb('ok')
end)

RegisterNUICallback('lockToggle', function(data, cb)
    local veh = currentVehicle or GetClosestVehicleToPlayer()
    if veh then
        local vehClass = GetVehicleClass(veh)
        if Config.noLockVehicleClasses and Config.noLockVehicleClasses[vehClass] then
            cb('ok')
            return
        end

        states.locked = not states.locked
        PlayKeyFobAnimation()
        NetworkRequestControlOfEntity(veh)
        SetVehicleDoorsLocked(veh, states.locked and 2 or 1)
        FlashVehicleLights(veh)
        SaveVehicleState()
        UpdateNUIStates()
        Wait(300)
        ClearPedTasks(PlayerPedId())
    end
    cb('ok')
end)

RegisterNUICallback('setDriveMode', function(data, cb)
    if currentVehicle and IsInDriverSeat(currentVehicle) then
        local mode = data and data.mode
        if mode and Config.DriveModes[mode] then
            states.driveMode = mode
            ApplyDriveMode(currentVehicle)
            SaveVehicleState()
            UpdateNUIStates()
        end
    end
    cb('ok')
end)

RegisterNUICallback('closeNUI', function(data, cb)
    ShowNUI(false)
    cb('ok')
end)

RegisterNUICallback('seatbeltToggle', function(data, cb)
    if currentVehicle and IsInDriverSeat(currentVehicle) then
        local wantBuckle = data and data.seatbelt or false

        if Config.Seatbelt.system == 'mst_seatbelt' then
            local mstOk = exports['mst_seatbelt']:SetSeatbelt(wantBuckle)
            if mstOk then
                seatbeltOn = wantBuckle
            else
                seatbeltOn = exports['mst_seatbelt']:HasSeatbelt() or false
            end
        else
            seatbeltOn = wantBuckle
        end

        UpdateNUIStates()
    end
    cb('ok')
end)

RegisterNUICallback('cruiseToggle', function(data, cb)
    if not currentVehicle or not IsInDriverSeat(currentVehicle) then cb('ok') return end
    cruiseActive = data.active == true
    if data.unit then cruiseUnit = data.unit end

    if cruiseActive then
        local minDisplay = (cruiseUnit == 'mph') and 15 or 20
        if data.useCurrentSpeed then
            local currentMps = GetEntitySpeed(currentVehicle)
            local currentDisplay = MpsToCruise(currentMps, cruiseUnit)
            if currentDisplay >= minDisplay then
                cruiseSpeed = currentDisplay
                SendNUIMessage({ action = 'updateCruiseSpeed', speed = cruiseSpeed })
            else
                cruiseActive = false
                SendNUIMessage({ action = 'updateCruiseSpeed', speed = 0, active = false })
                cb('ok')
                return
            end
        elseif tonumber(data.speed) and tonumber(data.speed) >= minDisplay then
            cruiseSpeed = tonumber(data.speed)
        else
            cruiseActive = false
            SendNUIMessage({ action = 'updateCruiseSpeed', speed = 0, active = false })
            cb('ok')
            return
        end
    else
        SetEntityMaxSpeed(currentVehicle, 500.0)
    end
    cb('ok')
end)

RegisterNUICallback('cruiseSetSpeed', function(data, cb)
    if not currentVehicle or not IsInDriverSeat(currentVehicle) then cb('ok') return end
    cruiseSpeed = tonumber(data.speed) or 0
    if data.unit then cruiseUnit = data.unit end
    cb('ok')
end)

RegisterNUICallback('cruiseLimiter', function(data, cb)
    if not currentVehicle or not IsInDriverSeat(currentVehicle) then cb('ok') return end
    cruiseLimiter = data.limiter == true
    cb('ok')
end)

local function DisableCruise()
    if cruiseActive then
        cruiseActive = false
        if currentVehicle and DoesEntityExist(currentVehicle) then
            SetEntityMaxSpeed(currentVehicle, 500.0)
        end
        SendNUIMessage({ action = 'updateCruiseSpeed', speed = cruiseSpeed, active = false })
    end
end

Citizen.CreateThread(function()
    while true do
        if cruiseActive and currentVehicle and DoesEntityExist(currentVehicle) and IsInDriverSeat(currentVehicle) then
            Citizen.Wait(0)
            if IsControlPressed(0, 72) then
                DisableCruise()
            elseif not GetIsVehicleEngineRunning(currentVehicle) then
                DisableCruise()
            else
                local targetMps = CruiseToMps(cruiseSpeed, cruiseUnit)
                local vehMaxMps = GetVehicleEstimatedMaxSpeed(currentVehicle)
                if vehMaxMps > 0 and targetMps > vehMaxMps then
                    targetMps = vehMaxMps
                end

                local currentMps = GetEntitySpeed(currentVehicle)
                SetEntityMaxSpeed(currentVehicle, targetMps)

                if not cruiseLimiter then
                    if currentMps < targetMps - 0.3 then
                        local ratio = currentMps / targetMps
                        local throttle
                        if ratio < 0.5 then
                            throttle = 1.0
                        elseif ratio < 0.85 then
                            throttle = 0.7
                        elseif ratio < 0.95 then
                            throttle = 0.45
                        else
                            throttle = 0.3
                        end
                        SetControlNormal(0, 71, throttle)
                    end
                end
            end
        elseif cruiseActive then
            Citizen.Wait(0)
            DisableCruise()
        else
            Citizen.Wait(200)
        end
    end
end)

RegisterNUICallback('ignitionNext', function(data, cb)
    if not currentVehicle or not IsInDriverSeat(currentVehicle) then
        cb('ok')
        return
    end

    local isHold = data and data.hold

    if ignitionState == 'LOCK' then
        SetIgnitionState('ACC')
    elseif ignitionState == 'ACC' then
        if isHold then
            SetIgnitionState('START')
        end
    elseif ignitionState == 'ON' then
        SetIgnitionState('ACC')
    end

    cb('ok')
end)

RegisterNUICallback('ignitionSetState', function(data, cb)
    local newState = data and data.state
    if newState and (newState == 'LOCK' or newState == 'ACC' or newState == 'ON' or newState == 'START') then
        SetIgnitionState(newState)
    end
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local isInVehicle = vehicle ~= 0

        if isInVehicle and vehicle ~= currentVehicle then
            currentVehicle = vehicle
            isPremiumVehicle = IsPremiumVehicle(vehicle)
            ignitionState = 'LOCK'
            seatbeltOn = false
            Citizen.CreateThread(function()
                Wait(800)
                if currentVehicle == vehicle then
                    LoadVehicleState()
                    if states.engine then
                        ignitionState = 'ON'
                    end
                    ApplyDriveMode(vehicle)
                    UpdateNUIStates()
                end
            end)

        elseif (not isInVehicle) and currentVehicle ~= nil then
            if IsInDriverSeat(currentVehicle) then
                SaveVehicleState()
            end
            if cruiseActive and DoesEntityExist(currentVehicle) then
                SetEntityMaxSpeed(currentVehicle, 500.0)
            end
            cruiseActive = false
            cruiseSpeed = 0
            cruiseLimiter = false
            currentVehicle = nil
            isPremiumVehicle = false
            ignitionState = 'LOCK'
            seatbeltOn = false
            states.engine = false
            states.locked = false
            states.driveMode = 'STANDARD'

            if nuiOpen then
                ShowNUI(false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if not currentVehicle and not nuiOpen then
            Citizen.Wait(200)
        else
            Citizen.Wait(0)
        end

        if IsControlJustPressed(0, Config.OpenKey) then
            if not nuiOpen and currentVehicle and IsInDriverSeat(currentVehicle) then
                ShowNUI(true)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if currentVehicle and DoesEntityExist(currentVehicle) then
            local currentEngineStatus = GetIsVehicleEngineRunning(currentVehicle)
            if currentEngineStatus ~= states.engine then
                SetVehicleEngineOn(currentVehicle, states.engine, false, true)
            end
            SetVehicleAutoRepairDisabled(currentVehicle, true)
            ApplyDriveMode(currentVehicle)
            Citizen.Wait(200)
        else
            Citizen.Wait(500)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        if nuiOpen then
            if not currentVehicle or not IsInDriverSeat(currentVehicle) then
                ShowNUI(false)
            end

            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 25, true)
            DisableControlAction(0, 47, true)
            DisableControlAction(0, 58, true)
            DisableControlAction(0, 140, true)
            DisableControlAction(0, 141, true)
            DisableControlAction(0, 257, true)

            if not IsControlPressed(0, Config.OpenKey) then
                ShowNUI(false)
            end
        end
        Citizen.Wait(nuiOpen and 0 or 100)
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    currentVehicle = nil
    nuiOpen = false
    states = { engine = false, locked = false, driveMode = 'STANDARD' }
    vehicleStates = {}
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    if nuiOpen then ShowNUI(false) end
end)

exports('GetVehicleStates', function()
    return {
        engine = states.engine,
        locked = states.locked,
        driveMode = states.driveMode,
        isInVehicle = currentVehicle ~= nil and DoesEntityExist(currentVehicle),
    }
end)

exports('SetDriveMode', function(mode)
    if mode and Config.DriveModes[mode] then
        states.driveMode = mode
        if currentVehicle then
            ApplyDriveMode(currentVehicle)
            SaveVehicleState()
        end
        UpdateNUIStates()
    end
end)

exports('ToggleEngine', function()
    if currentVehicle and DoesVehicleNeedFuel(currentVehicle) and IsInDriverSeat(currentVehicle) then
        states.engine = not states.engine
        SetVehicleEngineOn(currentVehicle, states.engine, false, false)
        SaveVehicleState()
        UpdateNUIStates()
        return states.engine
    end
    return nil
end)

exports('ToggleLock', function()
    local veh = currentVehicle or GetClosestVehicleToPlayer()
    if veh then
        local vehClass = GetVehicleClass(veh)
        if Config.noLockVehicleClasses and Config.noLockVehicleClasses[vehClass] then
            return false
        end
        states.locked = not states.locked
        NetworkRequestControlOfEntity(veh)
        SetVehicleDoorsLocked(veh, states.locked and 2 or 1)
        FlashVehicleLights(veh)
        SaveVehicleState()
        UpdateNUIStates()
        return states.locked
    end
    return nil
end)
