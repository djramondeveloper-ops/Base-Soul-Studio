-- =====================================================
--  rcore_police · modules/base/server/services/sv-se-utils.lua
--  Engineered by Eazy Fxap
--  Original: 129 lines → Cleaned: 50 lines
-- =====================================================

UtilsService = {}

function UtilsService.GetZoneJob(zoneData)
    if not zoneData then return nil end
    local presetName = zoneData.preset
    local presetData = Maps[presetName]
    
    if presetData then
        return presetData.Jobs
    else
        return nil
    end
end

function UtilsService.IsPlayerAtInteract(src, zoneData)
    if not zoneData or not src then return false end
    
    local presetName = zoneData.preset
    local zoneIndex = zoneData.index
    local presetData = Maps[presetName]
    
    if presetData and next(presetData) then
        local zone = presetData.Zones[zoneIndex]
        if zone then
            local interactCoords = zone.coords
            local playerCoords = UtilsService.GetPlayerPos(src)
            local dist = #(playerCoords - interactCoords)
            return dist <= 5.0, interactCoords
        end
    end
    return false
end

function UtilsService.IsPlayerAtGarage(src, zoneData)
    if not zoneData or not src then return false end
    
    local presetName = zoneData.preset
    local zoneIndex = zoneData.index
    local spawnPointId = zoneData.spawnPointId
    local presetData = Maps[presetName]
    
    if presetData and next(presetData) then
        local zone = presetData.Zones[zoneIndex]
        if zone then
            local point = zone.points[spawnPointId]
            if point then
                local pointCoords = point.coords
                local playerCoords = UtilsService.GetPlayerPos(src)
                local dist = #(playerCoords - pointCoords)
                return dist <= 5.0
            end
        end
    end
    return false
end

function UtilsService.GetPlayerPos(src)
    if not src then return nil end
    local ped = GetPlayerPed(src)
    return GetEntityCoords(ped)
end
