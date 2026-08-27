-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local CachedJobGarages = {}
RegisterNetEvent('rcore_police:client:setJobGarages', function(serverData)
    if source == '' then return end
    if not serverData then return end
    CachedJobGarages = serverData
end)
function GetJobGarageData(playerJob)
    local retval = {}
    if CachedJobGarages and next(CachedJobGarages) then
        for garageId, v in pairs(CachedJobGarages) do
            if garageId and tostring(garageId):lower() == tostring(playerJob):lower() then
                retval = v
            end
        end
    end
    if Config.Garages == Garages.OKOK and doesExportExistInResource(Garages.OKOK, 'getConfig') then
        local config = exports[Garages.OKOK]:getConfig()
        if config then
            local garages = config.Garages
            if garages and next(garages) then
                local playerId = PlayerPedId()
                local playerCoords = GetEntityCoords(playerId)
                local closestGarage, closestDist, closestIndex = nil, math.huge, nil
                for k, v in pairs(garages) do
                    local pos = v.coords
                    local dist = #(vector3(pos.x, pos.y, pos.z) - playerCoords)
                    if dist < closestDist then
                        closestDist = dist
                        closestGarage = v
                        closestIndex = k
                    end
                end
                if closestGarage then
                    retval = {
                        index = closestIndex,
                        name = closestGarage.name
                    }
                end
            end
        end
    end
    return retval
end
function RequestVehicleFromDepartmentGarage(order)
    if not order then
        return
    end
    dbg.debug('Department garage: Requesting parking space')
    TriggerServerEvent('rcore_police:server:requestParkingSpace', {
        zone = CurrentZone,
        model = order.model,
        label = order.label,
        price = order.price
    })
    CurrentZone = nil
end
function OpenJobGarageMenu(zone)
    if not Config.Garage.Enable then
        return dbg.debug('Job garage: Cannot be used/opened since its disabled in Config.Garage.Enable (config.lua)!')
    end
    if type(zone) ~= "table" then
        return dbg.critical('OpenJobGarageMenu: Received as zone: %s', type(zone))
    end
    local zoneData = zone.getZoneData()
    local zoneType = zone.getZoneType()
    local zoneJob = zone.getDepartmentOwner()
    CurrentZone = zoneData
    if not Config.Garage.UseOurBuiltinGarage then
        if Config.Garages == Garages.JG then
            local garage = GetJobGarageData(zoneJob)
            if garage and next(garage) then
                TriggerEvent("jg-advancedgarages:client:open-garage", garage.name, garage.type, GetEntityCoords(PlayerPedId()))
                return
            end
        end
        if Config.Garages == Garages.OKOK then
            local garage = GetJobGarageData(zoneJob)
            if garage and next(garage) then
                TriggerEvent('okokGarage:openMenu', garage.index, 'openGarage', garage.name)
                return
            end
        end
    end
    local data, state, statusCode = GetAvailableVehiclesForGrade(Framework.job.name, Framework.job.grade, Framework.job.isBoss, zoneType)
    if not state then
        return dbg.critical('Cannot open vehicle shop: %s', statusCode)
    end
    OpenGarage(data)
end
