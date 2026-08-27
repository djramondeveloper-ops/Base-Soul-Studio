-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-zones.lua
--  Engineered by Eazy Fxap
--  Original: 164 lines → Cleaned: 85 lines
-- =====================================================

ValidMapData = {}

local sortedMapsList = {}
local tempMapsObj = {}
local singleLoadedMap = nil
local allowMapLoad = true

CreateThread(function()
    for mapName, mapConfig in pairs(Maps) do
        local mapLocation = mapConfig.MapLocation
        local resourceName = mapConfig.Resource
        
        if mapLocation then
            local mapState = "UNLOADED"
            
            if resourceName ~= MAPS.STANDALONE then
                if isResourcePresentProvideless(resourceName) then
                    mapState = "LOADED"
                    allowMapLoad = false
                end
            else
                local mapObj = {
                    mapName = mapName,
                    mapLocation = mapLocation,
                    mapState = "LOADED"
                }
                singleLoadedMap = mapObj
            end
            
            if mapState == "LOADED" then
                if not tempMapsObj[mapLocation] or tempMapsObj[mapLocation].mapState == "UNLOADED" then
                    tempMapsObj[mapLocation] = {
                        mapName = mapName,
                        mapLocation = mapLocation,
                        mapState = mapState
                    }
                end
            elseif mapState == "UNLOADED" then
                if not tempMapsObj[mapLocation] then
                    tempMapsObj[mapLocation] = {
                        mapName = mapName,
                        mapLocation = mapLocation,
                        mapState = mapState
                    }
                end
            end
        end
    end
    
    if allowMapLoad and singleLoadedMap then
        tempMapsObj[singleLoadedMap.mapLocation] = singleLoadedMap
    end
    
    for _, v in pairs(tempMapsObj) do
        table.insert(sortedMapsList, v)
    end
    
    table.sort(sortedMapsList, function(a, b)
        return a.mapLocation < b.mapLocation
    end)
    
    if next(sortedMapsList) then
        for _, mapItem in pairs(sortedMapsList) do
            local mapName = mapItem.mapName
            local mapState = mapItem.mapState
            
            local mapConfig = Maps[mapName]
            if mapConfig and mapState == "LOADED" then
                ValidMapData[mapName] = {
                    resource = mapConfig.Resource,
                    location = mapConfig.MapLocation
                }
                
                local zones = mapConfig.Zones
                local jobs = mapConfig.Jobs
                local pos = mapConfig.Pos
                
                if zones and next(zones) then
                    DefineZones(zones, mapName, jobs)
                end
            end
        end
    end
end)

function DefineZones(zones, mapName, jobs)
    for _, zone in pairs(zones) do
        local zType = zone.type
        local coords = zone.coords
        -- TODO: identify (stub/unfinished logic)
    end
end
