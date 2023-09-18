local nitrousActivated = false
local nitrousBoost = 35.0
local vehicleNitrous = {}
local Fxs = {}

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    local vehs = lib.callback.await('nitrous:GetNosLoadedVehs', false)
    vehicleNitrous = vehs
end)

RegisterNetEvent('smallresource:client:LoadNitrous', function()
    if not nitrousActivated then
        if cache.vehicle and not IsThisModelABike(GetEntityModel(cache.vehicle)) then
            if cache.seat == -1 then
                if lib.progressBar({
                    duration = 1000,
                    label = Lang:t("text.connecting_nos"),
                    useWhileDead = false,
                    canCancel = true,
                    disable = {
                        move = false,
                        car = false,
                        mouse = false,
                        combat = true
                    }
                }) then
                    TriggerEvent("inventory:client:ItemBox", QBCore.Shared.Items['nitrous'], "remove")
                    TriggerServerEvent("nitrous:server:removeItem")
                    local currentVehicle = cache.vehicle
                    local Plate = GetPlate(currentVehicle)
                    TriggerServerEvent('nitrous:server:LoadNitrous', Plate)
                end
            else
                QBCore.Functions.Notify(Lang:t("error.you_cannot_do_that_from_this_seat"), "error")
            end
        else
            QBCore.Functions.Notify(Lang:t("error.you_are_not_in_a_vehicle"), 'error')
        end
    else
        QBCore.Functions.Notify(Lang:t("error.you_already_have_nos_active"), 'error')
    end
end)

local nitrousUpdated = false

CreateThread(function()
    while true do
        if cache.vehicle then
            local Plate = GetPlate(cache.vehicle)
            if vehicleNitrous[Plate] ~= nil then
                if vehicleNitrous[Plate].hasnitro then
                    if IsControlJustPressed(0, 36) and cache.seat == -1 then
                        SetVehicleEnginePowerMultiplier(cache.vehicle, nitrousBoost)
                        SetVehicleEngineTorqueMultiplier(cache.vehicle, nitrousBoost)
                        SetEntityMaxSpeed(cache.vehicle, 999.0)
                        nitrousActivated = true

                        CreateThread(function()
                            while nitrousActivated do
                                if vehicleNitrous[Plate].level - 1 ~= 0 then
                                    TriggerServerEvent('nitrous:server:UpdateNitroLevel', Plate, (vehicleNitrous[Plate].level - 1))
                                    TriggerEvent('hud:client:UpdateNitrous', vehicleNitrous[Plate].hasnitro,  vehicleNitrous[Plate].level, true)
                                else
                                    TriggerServerEvent('nitrous:server:UnloadNitrous', Plate)
                                    nitrousActivated = false
                                    SetVehicleBoostActive(cache.vehicle, false)
                                    SetVehicleEnginePowerMultiplier(cache.vehicle, LastEngineMultiplier)
                                    SetVehicleEngineTorqueMultiplier(cache.vehicle, 1.0)
                                    StopScreenEffect("RaceTurbo")
                                    for index in pairs(Fxs) do
                                        StopParticleFxLooped(Fxs[index], true)
                                        TriggerServerEvent('nitrous:server:StopSync', GetPlate(cache.vehicle))
                                        Fxs[index] = nil
                                    end
                                end
                                Wait(100)
                            end
                        end)
                    end

                    if IsControlJustReleased(0, 36) and cache.seat == -1 then
                        if nitrousActivated then
                            SetVehicleBoostActive(veh, false)
                            SetVehicleEnginePowerMultiplier(cache.vehicle, LastEngineMultiplier)
                            SetVehicleEngineTorqueMultiplier(cache.vehicle, 1.0)
                            for index in pairs(Fxs) do
                                StopParticleFxLooped(Fxs[index], true)
                                TriggerServerEvent('nitrous:server:StopSync', GetPlate(cache.vehicle))
                                Fxs[index] = nil
                            end
                            StopScreenEffect("RaceTurbo")
                            TriggerEvent('hud:client:UpdateNitrous', vehicleNitrous[Plate].hasnitro,  vehicleNitrous[Plate].level, false)
                            nitrousActivated = false
                        end
                    end
                end
            else
                if not nitrousUpdated then
                    TriggerEvent('hud:client:UpdateNitrous', false, nil, false)
                    nitrousUpdated = true
                end
                StopScreenEffect("RaceTurbo")
            end
        else
            if nitrousUpdated then
                nitrousUpdated = false
            end
            StopScreenEffect("RaceTurbo")
            Wait(1500)
        end
        Wait(0)
    end
end)

p_flame_location = {
	"exhaust",
	"exhaust_2",
	"exhaust_3",
	"exhaust_4",
	"exhaust_5",
	"exhaust_6",
	"exhaust_7",
	"exhaust_8",
	"exhaust_9",
	"exhaust_10",
	"exhaust_11",
	"exhaust_12",
	"exhaust_13",
	"exhaust_14",
	"exhaust_15",
	"exhaust_16",
}

ParticleDict = "veh_xs_vehicle_mods"
ParticleFx = "veh_nitrous"
ParticleSize = 1.4

CreateThread(function()
    while true do
        if nitrousActivated then
            if cache.vehicle ~= 0 then
                TriggerServerEvent('nitrous:server:SyncFlames', VehToNet(cache.vehicle))
                SetVehicleBoostActive(veh, true)
                StartScreenEffect("RaceTurbo", 0.0, 0)

                for _,bones in pairs(p_flame_location) do
                    if GetEntityBoneIndexByName(cache.vehicle, bones) ~= -1 then
                        if Fxs[bones] == nil then
                            lib.requestNamedPtfxAsset(ParticleDict)
                            while not HasNamedPtfxAssetLoaded(ParticleDict) do
                                Wait(0)
                            end
                            SetPtfxAssetNextCall(ParticleDict)
                            UseParticleFxAssetNextCall(ParticleDict)
                            Fxs[bones] = StartParticleFxLoopedOnEntityBone(ParticleFx, cache.vehicle, 0.0, -0.02, 0.0, 0.0, 0.0, 0.0, GetEntityBoneIndexByName(cache.vehicle, bones), ParticleSize, false, false, false)
                        end
                    end
                end
            end
        end
        Wait(0)
    end
end)

local NOSPFX = {}

RegisterNetEvent('nitrous:client:SyncFlames', function(netid, nosid)
    local veh = NetToVeh(netid)
    if veh ~= 0 then
        local plate = GetPlate(veh)
        if NOSPFX[plate] == nil then
            NOSPFX[plate] = {}
        end
        if cache.serverId ~= nosid then
            for _,bones in pairs(p_flame_location) do
                if NOSPFX[plate][bones] == nil then
                    NOSPFX[plate][bones] = {}
                end
                if GetEntityBoneIndexByName(veh, bones) ~= -1 then
                    if NOSPFX[plate][bones].pfx == nil then
                        lib.requestNamedPtfxAsset(ParticleDict)
                        SetPtfxAssetNextCall(ParticleDict)
                        UseParticleFxAssetNextCall(ParticleDict)
                        NOSPFX[plate][bones].pfx = StartParticleFxLoopedOnEntityBone(ParticleFx, veh, 0.0, -0.05, 0.0, 0.0, 0.0, 0.0, GetEntityBoneIndexByName(veh, bones), ParticleSize, false, false, false)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('nitrous:client:StopSync', function(plate)
    for k, v in pairs(NOSPFX[plate]) do
        StopParticleFxLooped(v.pfx, true)
        NOSPFX[plate][k].pfx = nil
    end
end)

RegisterNetEvent('nitrous:client:UpdateNitroLevel', function(Plate, level)
    vehicleNitrous[Plate].level = level
end)

RegisterNetEvent('nitrous:client:LoadNitrous', function(Plate)
    vehicleNitrous[Plate] = {
        hasnitro = true,
        level = 100,
    }
    local CPlate = GetPlate(cache.vehicle)
    if CPlate == Plate then
        TriggerEvent('hud:client:UpdateNitrous', vehicleNitrous[Plate].hasnitro, vehicleNitrous[Plate].level, false)
    end
end)

RegisterNetEvent('nitrous:client:UnloadNitrous', function(Plate)
    vehicleNitrous[Plate] = nil
    local CPlate = GetPlate(cache.vehicle)
    if CPlate == Plate then
        nitrousActivated = false
        TriggerEvent('hud:client:UpdateNitrous', false, nil, false)
    end
end)
