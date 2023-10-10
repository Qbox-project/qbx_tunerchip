local rainbowNeon = false
LastEngineMultiplier = 1.0

function setVehData(veh, data)
    local multp = 0.12
    local dTrain = 0.0
    if tonumber(data.drivetrain) == 2 then dTrain = 0.5 elseif tonumber(data.drivetrain) == 3 then dTrain = 1.0 end
    if not DoesEntityExist(veh) or not data then return nil end
    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", data.boost * multp)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", data.acceleration * multp)
    SetVehicleEnginePowerMultiplier(veh, data.gearchange * multp)
    LastEngineMultiplier = data.gearchange * multp
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", dTrain*1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", data.breaking * multp)
end

function resetVeh(veh)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fInitialDriveForce", 1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveInertia", 1.0)
    SetVehicleEnginePowerMultiplier(veh, 1.0)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fDriveBiasFront", 0.5)
    SetVehicleHandlingFloat(veh, "CHandlingData", "fBrakeBiasFront", 1.0)
end

RegisterNUICallback('save', function(data, cb)
    local hasChip = exports.ox_inventory:Search('count', 'tunerlaptop') >= 1
    if hasChip then
        setVehData(cache.vehicle, data)
        exports.qbx_core:Notify(Lang:t("error.tunerchip_vehicle_tuned"), 'error')
        TriggerServerEvent('qb-tunerchip:server:TuneStatus', GetPlate(cache.vehicle), true)
    end
    cb('ok')
end)

RegisterNetEvent('qb-tunerchip:client:TuneStatus', function()
    local coords = GetEntityCoords(cache.ped)
    local closestVehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)
    local plate = GetPlate(closestVehicle)
    local vehModel = GetEntityModel(closestVehicle)
    if vehModel ~= 0 then
        local status = lib.callback.await('qb-tunerchip:server:GetStatus', false, plate)
        if status then
            exports.qbx_core:Notify(Lang:t("success.this_vehicle_has_been_tuned"), 'success')
        else
            exports.qbx_core:Notify(Lang:t("error.this_vehicle_has_not_been_tuned"), 'error')
        end
    else
        exports.qbx_core:Notify(Lang:t("error.no_vehicle_nearby"), 'error')
    end
end)

RegisterNUICallback('checkItem', function(data, cb)
    cb(exports.ox_inventory:Search('count', data.item) >= 1)
end)

RegisterNUICallback('reset', function(_, cb)
    resetVeh(cache.vehicle)
    exports.qbx_core:Notify(Lang:t("error.tunerchip_vehicle_has_been_reset"), 'error')
    cb("ok")
end)

RegisterNetEvent('qb-tunerchip:client:openChip', function()
    if cache.vehicle then
        if lib.progressBar({
            duration = 2000,
            label = Lang:t("error.tunerchip_vehicle_has_been_reset"),
            useWhileDead = false,
            canCancel = true,
            anim = {
                dict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                clip = "machinic_loop_mechandplayer",
                flag = 16
            },
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = true
            }
        }) then
            openTunerLaptop(true)
        else
            exports.qbx_core:Notify(Lang:t("error.canceled"), "error")
        end
    else
        exports.qbx_core:Notify(Lang:t("error.you_are_not_in_a_vehicle"), "error")
    end
end)

RegisterNUICallback('exit', function(_, cb)
    openTunerLaptop(false)
    SetNuiFocus(false, false)
    cb('ok')
end)

local lastRainbowNeonColor = 0

local rainbowNeonColors = {
    [1] = {r = 255, g = 0, b = 0},
    [2] = {r = 255, g = 165, b = 0},
    [3] = {r = 255, g = 255,  b = 0},
    [4] = {r = 0, g = 0, b = 255},
    [5] = {r = 75, g = 0, b = 130},
    [6] = {r = 238, g = 130, b = 238}
}

RegisterNUICallback('saveNeon', function(data, cb)
    local hasChip = exports.ox_inventory:Search('count', 'tunerlaptop') >= 1
    if hasChip then
        if not data.rainbowEnabled then
            if tonumber(data.neonEnabled) == 1 then
                for i = 0, 3 do
                    SetVehicleNeonLightEnabled(cache.vehicle, i, true)
                end
                data.r = tonumber(data.r)
                data.g = tonumber(data.g)
                data.b = tonumber(data.b)
                if data.r and data.g and data.b then
                    SetVehicleNeonLightsColour(cache.vehicle, data.r, data.g, data.b)
                else
                    SetVehicleNeonLightsColour(cache.vehicle, 255, 255, 255)
                end
                rainbowNeon = false
            else
                for i = 0, 3 do
                    SetVehicleNeonLightEnabled(cache.vehicle, i, false)
                end
                rainbowNeon = false
            end
        else
            if tonumber(data.neonEnabled) == 1 then
                if not rainbowNeon then
                    rainbowNeon = true
                    for i = 0, 3 do
                        SetVehicleNeonLightEnabled(cache.vehicle, i, true)
                    end
                    CreateThread(function()
                        while true do
                            if rainbowNeon then
                                if (lastRainbowNeonColor + 1) ~= 7 then
                                    lastRainbowNeonColor += 1
                                    SetVehicleNeonLightsColour(cache.vehicle, rainbowNeonColors[lastRainbowNeonColor].r, rainbowNeonColors[lastRainbowNeonColor].g, rainbowNeonColors[lastRainbowNeonColor].b)
                                else
                                    lastRainbowNeonColor = 1
                                    SetVehicleNeonLightsColour(cache.vehicle, rainbowNeonColors[lastRainbowNeonColor].r, rainbowNeonColors[lastRainbowNeonColor].g, rainbowNeonColors[lastRainbowNeonColor].b)
                                end
                            else
                                break
                            end

                            Wait(350)
                        end
                    end)
                end
            else
                rainbowNeon = false
                for i = 0, 3 do
                    SetVehicleNeonLightEnabled(cache.vehicle, i, false)
                end
            end
        end
    end
    cb('ok')
end)

local rainbowHeadlight = false
local rainbowHeadlightValue = 0

RegisterNUICallback('saveHeadlights', function(data, cb)
    local hasChip = exports.ox_inventory:Search('count', 'tunerlaptop') >= 1
    if hasChip then
        local value = tonumber(data.value)
        if data.rainbowEnabled then
            rainbowHeadlight = true
            CreateThread(function()
                while true do
                    if rainbowHeadlight then
                        if (rainbowHeadlightValue + 1) ~= 12 then
                            rainbowHeadlightValue += 1
                            ToggleVehicleMod(cache.vehicle, 22, true)
                            SetVehicleHeadlightsColour(cache.vehicle, rainbowHeadlightValue)
                        else
                            rainbowHeadlightValue = 1
                            ToggleVehicleMod(cache.vehicle, 22, true)
                            SetVehicleHeadlightsColour(cache.vehicle, rainbowHeadlightValue)
                        end
                    else
                        break
                    end
                    Wait(300)
                end
            end)
            ToggleVehicleMod(cache.vehicle, 22, true)
            SetVehicleHeadlightsColour(cache.vehicle, value)
        else
            rainbowHeadlight = false

            ToggleVehicleMod(cache.vehicle, 22, true)
            SetVehicleHeadlightsColour(cache.vehicle, value)
        end
    end
    cb('ok')
end)

function openTunerLaptop(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "ui",
        toggle = bool
    })
end

RegisterNUICallback('SetStancer', function(data, cb)
    local fOffset = data.fOffset * 100 / 1000
    local fRotation = data.fRotation * 100 / 1000
    local rOffset = data.rOffset * 100 / 1000
    local rRotation = data.rRotation * 100 / 1000
    exports["vstancer"]:SetWheelPreset(cache.vehicle, -fOffset, -fRotation, -rOffset, -rRotation)
    cb("ok")
end)