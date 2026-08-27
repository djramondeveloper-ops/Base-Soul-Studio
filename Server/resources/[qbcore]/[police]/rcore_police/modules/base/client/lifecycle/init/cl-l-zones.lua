-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-zones.lua
--  Engineered by Eazy Fxap
--  Original: 799 lines → Cleaned: 205 lines
-- =====================================================

local ZONE_STATES = {
    DATABASE = {
        WRITE_REPORT = true,
        REPORTS = true
    },
    INTERACT = {
        [ZONE_TYPE.WEAPON_SHOP]   = { state = Config.ItemShop.Enable },
        [ZONE_TYPE.GARAGE_VEHICLE] = { state = Config.Garage.Enable },
        [ZONE_TYPE.DUTY]           = { state = Config.DutySystemState },
        [ZONE_TYPE.BOSS_MENU]      = { state = Config.BossMenu.Enable },
        [ZONE_TYPE.CLOTHING_ROOM]  = { state = Config.Outfits.Enable },
        [ZONE_TYPE.GARAGE_AIR]     = { state = Config.Garage.Enable }
    }
}

local loadedMaps = {}
local standaloneMapData = {}
local zoneQueue = {}
local registeredPoints = {}
ValidMapData = {}
local noExternalMaps = true

CreateThread(function()
    TextService.Hide()
    if HandleRegistrationZoneBlock() then
        dbg.debug("Zones: Disabled registration on init, awaiting player be fully loaded")
        return
    end
    InitRegisterZones()
end)

function InitRegisterZones()
    if Config.UseTargetForZones then
        Config.Zones.Style = "Target"
    end
    
    for mapName, mapData in pairs(Maps) do
        local mapLocation = mapData.MapLocation
        local resource = mapData.Resource
        
        if mapLocation then
            local mapState = "UNLOADED"
            
            if resource ~= MAPS.STANDALONE then
                if isResourcePresentProvideless(resource) then
                    mapState = "LOADED"
                    noExternalMaps = false
                end
            else
                standaloneMapData = { mapName = mapName, mapLocation = mapLocation, mapState = "LOADED" }
            end
            
            if mapState == "LOADED" then
                if loadedMaps[mapLocation] and loadedMaps[mapLocation].mapState == "UNLOADED" then
                    loadedMaps[mapLocation] = { mapName = mapName, mapLocation = mapLocation, mapState = mapState }
                end
            elseif mapState == "UNLOADED" then
                if not loadedMaps[mapLocation] then
                    loadedMaps[mapLocation] = { mapName = mapName, mapLocation = mapLocation, mapState = mapState }
                end
            end
        end
    end
    
    if noExternalMaps and standaloneMapData.mapLocation then
        loadedMaps[standaloneMapData.mapLocation] = standaloneMapData
    end
    
    local sortedMaps = {}
    for _, entry in pairs(loadedMaps) do
        table.insert(sortedMaps, entry)
    end
    table.sort(sortedMaps, function(a, b) return a.mapLocation < b.mapLocation end)
    
    if next(sortedMaps) then
        for _, entry in pairs(sortedMaps) do
            local mapName = entry.mapName
            local mapState = entry.mapState
            local mapDef = Maps[mapName]
            
            if mapDef and mapState == "LOADED" then
                local zones = mapDef.Zones
                local jobs = mapDef.Jobs
                local pos = mapDef.Pos
                local blipDef = mapDef.Blip
                
                ValidMapData[mapName] = {
                    resource = mapDef.Resource,
                    location = mapDef.MapLocation,
                    coords = pos,
                    owner = jobs
                }
                
                if blipDef and blipDef.enable then
                    Utils.CreateBlipAtCoords({
                        sprite = blipDef.sprite or 0,
                        display = blipDef.display or 1,
                        color = blipDef.color or 0,
                        scale = blipDef.scale or 1.0,
                        shortRange = blipDef.shortRange or false,
                        name = blipDef.name or "",
                        pos = pos
                    })
                end
                
                dbg.debug("Registering zones for map preset named %s", mapName)
                if pos then BlockEnviroment(pos) end
                
                if zones and next(zones) then
                    DefineZones(zones, mapName, jobs)
                    table.insert(zoneQueue, { zones = zones, mapKey = mapName, owner = jobs })
                end
            end
        end
    end
end

function DefineZones(zoneList, preset, owner)
    if Config.UseTargetForZones then
        Config.Zones.Style = "Target"
        dbg.debug("Switching zones to use target instead of markers!")
    end
    if not zoneList then return end
    
    local filteredZones = {}
    for _, zone in pairs(zoneList) do
        zone.skipRender = false
        
        if Config.Database == Database.NONE then
            if ZONE_STATES.DATABASE[zone.type] then
                zone.skipRender = true
            end
        end
        
        local interactState = ZONE_STATES.INTERACT[zone.type]
        if interactState then
            if not interactState.state then
                dbg.debug("Zone interact: Removing this zone type %s due to disabled state", zone.type)
                zone.skipRender = true
            end
        end
        
        table.insert(filteredZones, zone)
    end
    
    Wait(0)
    local zoneStyle = Config.Zones.Style
    
    for idx, zone in ipairs(filteredZones) do
        local coords = zone.coords
        local zoneType = zone.type
        local marker = createMarker()
        local zoneId = string.format("%s_%s", preset, idx)
        
        marker.setPosition(vec3(coords.x, coords.y, coords.z - 1))
        marker.setRenderDistance(Config.Zones.RenderDistanceNPC)
        marker.setDepartmentOwner(owner)
        marker.setZoneType(zoneType)
        marker.setJobState(zone.no_job_zone or false)
        marker.setZoneDutyState(zone.require_duty)
        marker.setKeys({38})
        
        local label = zone.label
        if zoneStyle == "3D" or zoneStyle == "DrawText" or zoneStyle == "Marker" then
            label = string.format("%s %s", zone.label, "[E]")
        end
        
        if zoneStyle == "Marker" then
            marker.setRenderDistance(Config.Zones.ZoneRenderDistance)
        end
        
        marker.setZoneLabel(label)
        marker.setAlpha(Config.Marker.Alpha)
        marker.setRotation(Config.Marker.Rotation)
        
        if zone.marker then
            marker.setType(zone.marker.type)
        end
        
        if zone.npc and not zone.skipRender then
            marker.setNPCModel(zone.npc.model)
            marker.setNPCHeading(zone.npc.heading)
            marker.setNPCRenderDistance(Config.Zones.RenderDistanceNPC)
        end
        
        if zoneStyle == "Target" and not zone.skipRender then
            local useOxOrCRM = Config.InteractionsTarget == InteractionsTarget.OX or isResourcePresentProvideless("crm-target")
            
            local targetOpts = {
                num = 1,
                type = "client",
                event = "rcore_police:client:zoneInteract",
                icon = zone.icon or "",
                label = label,
                targeticon = zone.icon or "",
                canInteract = function() return true end,
                drawColor = {255, 255, 255, 255},
                successDrawColor = {30, 144, 255, 255}
            }
            
            if useOxOrCRM then
                targetOpts.onSelect = function()
                    TriggerEvent("rcore_police:client:zoneInteract", { zone = marker })
                end
            else
                targetOpts.zone = marker
            end
            
            CreateTargetZone(coords, 1.5, 3.0, 35.0, { targetOpts })
        end
        
        marker.setZoneData({ preset = preset, index = idx })
        marker.setId(zoneId)
        
        if zone.skipRender then
            marker.stopRender()
        else
            marker.render()
        end
        
        marker.onEnter = function() OnZoneEnter(marker) end
        marker.onLeave = function() OnZoneLeave(marker) end
        
        if zoneStyle ~= "Target" then
            marker.registerKey(function(key)
                local ok, err = pcall(marker.onKey, key)
                if not ok then dbg.debug("Error in onKey: %s", err) end
            end, zoneId, "Activate Marker", "E", nil)
            
            marker.onKey = function() OnZoneKeypress(marker) end
        end
        
        if zone.points then
            RegisterPoints(zone.points, preset, idx, owner)
        end
    end
end

function RegisterPoints(spawnPoints, preset, zoneIdx, owner)
    if not spawnPoints or not next(spawnPoints) then return end
    
    local zoneStyle = Config.Zones.Style
    
    for spawnId, spawnPoint in ipairs(spawnPoints) do
        local marker = createMarker()
        local markerId = string.format("%s_%s_%s", preset, ZONE_TYPE.VEHICLE_SPAWNPOINT, tostring(spawnId))
        
        local label = ""
        local renderDist = 15
        if zoneStyle == "3D" or zoneStyle == "DrawText" or zoneStyle == "Marker" then
            label = string.format("%s %s", _U("POINTS.STORE_VEHICLE"), "[E]")
            renderDist = Config.Garage.MarkerRenderDistance or 10
        end
        
        marker.setZoneLabel(label)
        marker.setPosition(vec3(spawnPoint.coords.x, spawnPoint.coords.y, spawnPoint.coords.z))
        marker.setRenderDistance(renderDist)
        marker.setZoneType(ZONE_TYPE.VEHICLE_SPAWNPOINT)
        marker.setDepartmentOwner(owner)
        marker.setZoneDutyState(false)
        marker.setKeys({38})
        marker.setRotation(Config.Marker.Rotation)
        marker.setId(markerId)
        marker.setZoneData({ preset = preset, index = zoneIdx, spawnPointId = spawnId })
        marker.setAlpha(Config.Marker.Alpha)
        marker.render()
        
        marker.onEnter = function()
            GlobalZoneId = markerId
            OnZoneEnter(marker)
        end
        marker.onLeave = function()
            GlobalZoneId = nil
            OnZoneLeave(marker)
        end
        
        marker.registerKey(function(key)
            local ok, err = pcall(marker.onKey, key)
            if not ok then dbg.debug("Error in onKey: %s", err) end
        end, markerId, "Activate Marker", "E", nil)
        
        marker.onKey = function() OnZoneKeypress(marker) end
    end
end
