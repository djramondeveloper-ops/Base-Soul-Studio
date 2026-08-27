-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-garage.lua
--  Engineered by Eazy Fxap
--  Original: 154 lines → Cleaned: 40 lines
-- =====================================================

Garage = {}

function Garage.SpawnVehicle(coords, model)
    if not coords then return end
    model = model or "police"
    
    if not IsModelAVehicle(model) then
        return dbg.critical("Model is not vehicle, not spawning vehicle")
    end
    
    UtilsService.LoadModel(model)
    local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
    
    if DoesEntityExist(vehicle) then
        SetVehicleOnGroundProperly(vehicle)
        SetModelAsNoLongerNeeded(model)
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        UI.HelpKeys(nil, false)
        GlobalZoneId = nil
        return vehicle, VehToNet(vehicle)
    else
        dbg.critical("Failed to spawn vehicle.")
        return nil
    end
end

function Garage.GetClosestVehicleToPlayer(coords, radius)
    local vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, radius or 2.0, 0, 7)
    if vehicle ~= 0 then
        return true, "found_vehicle"
    end
    return false, "unk"
end

function Garage.GetFreeSpawnPoint(data, cb)
    local mapData = Maps[data.preset]
    if mapData and next(mapData) then
        local zoneData = mapData.Zones[data.index]
        if zoneData then
            for _, point in pairs(zoneData.points) do
                local hasVehicle, _ = Garage.GetClosestVehicleToPlayer(point.coords, 1.5)
                if not hasVehicle then
                    return cb(vec4(point.coords.x, point.coords.y, point.coords.z, point.heading))
                end
            end
        end
    end
    cb(nil)
end
