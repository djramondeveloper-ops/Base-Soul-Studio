-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function HandleVehicleExtras(vehicle, extraId, enforce)
    if not extraId then return end
    if not vehicle then return end
    if not DoesExtraExist(vehicle, extraId) then return end
    if vehicle and vehicle ~= 0 then
        local state = IsVehicleExtraTurnedOn(vehicle, extraId)
        if enforce then
            if IsVehicleExtraTurnedOn(vehicle, extraId) then
                return
            end
            return SetVehicleExtra(vehicle, extraId, 1)
        end
        if state then
            SetVehicleExtra(vehicle, extraId, 1)
        else
            SetVehicleExtra(vehicle, extraId, 0)
        end
        dbg.debug("Setting vehicle extras with state: %s", state)
    end
end
function HandleVehicleSpawnExtras(vehicle)
    if not vehicle then return end
    if Config.Garage.EnableSpawnVehicleWithExtras then
        local model = Object.getHash(vehicle)
        local modelName = Object.getModelName(model, vehicle)
        local getVehicleExtras = Config.Garage.VehicleExtras[modelName]
        if getVehicleExtras and next(getVehicleExtras) then
            for k, v in pairs(getVehicleExtras) do
                local state = v.state
                local extraId = v.id
                if state then
                    HandleVehicleExtras(vehicle, extraId, true)
                end
            end
        end
    end
end
