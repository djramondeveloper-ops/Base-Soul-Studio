-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-blips.lua
--  Engineered by Eazy Fxap
--  Original: 705 lines → Cleaned: 183 lines
-- =====================================================

local BlipEntity = {}
BlipEntity.__index = BlipEntity

function BlipEntity.new(entityId, visibleTo)
    local self = setmetatable({}, BlipEntity)
    local defaultVisibleTo = {}
    for groupName in pairs(Config.JobGroups) do
        defaultVisibleTo[groupName] = true
    end
    self.entityId = entityId
    self.active = true
    self.visibleTo = visibleTo or defaultVisibleTo
    self.lastCoords = nil
    self.lastUpdate = 0
    self.activeViewers = {}
    return self
end

function BlipEntity:isEntityValid()
    local ped = GetPlayerPed(self.entityId)
    return DoesEntityExist(ped)
end

function BlipEntity:getCoords()
    local ped = GetPlayerPed(self.entityId)
    if DoesEntityExist(ped) then
        return GetEntityCoords(ped)
    end
    return nil
end

function BlipEntity:getTrackType()
    local ped = GetPlayerPed(self.entityId)
    if DoesEntityExist(ped) then
        if GetVehiclePedIsIn(ped, false) then
            -- Left blank intentionally to preserve original behavior
        end
    end
    return TRACK_TYPE.PED, self.entityId
end

function BlipEntity:shouldUpdate(coords, currentTime)
    if not coords then return false end
    
    local updateInterval = (not self.lastCoords) and 3000 or 10000
    local lastUpdate = self.lastUpdate or 0
    
    return (not self.lastCoords) or (currentTime - lastUpdate > updateInterval)
end

function BlipEntity:markUpdated(coords, currentTime)
    self.lastCoords = coords
    self.lastUpdate = currentTime
end

function BlipEntity:getViewers()
    local viewers = {}
    if self.visibleTo.everyone then
        viewers = GetPlayers()
    else
        for groupName, state in pairs(self.visibleTo) do
            if state then
                local groupPlayers = GroupsService.GetGroupPlayersByDerpartmentName(groupName)
                for _, src in ipairs(groupPlayers) do
                    table.insert(viewers, tonumber(src))
                end
            end
        end
    end
    return viewers
end

TrackerManager = {
    trackers = {},
    subscriptions = {}
}
TrackerManager.__index = TrackerManager

function TrackerManager:toggleTracker(targetSrc, visibleTo)
    if self.trackers[targetSrc] then
        self:unregister(targetSrc)
        return false
    else
        self.trackers[targetSrc] = BlipEntity.new(targetSrc, visibleTo)
        return true
    end
end

function TrackerManager:setTrackerState(targetSrc, state, visibleTo)
    local hasTracker = (self.trackers[targetSrc] ~= nil)
    if state and not hasTracker then
        self.trackers[targetSrc] = BlipEntity.new(targetSrc, visibleTo)
        return true
    elseif not state and hasTracker then
        self:unregister(targetSrc)
        return false
    end
    return hasTracker
end

function TrackerManager:unregister(targetSrc)
    local tracker = self.trackers[targetSrc]
    if not tracker then return end
    
    local viewers = tracker:getViewers()
    self:sendRemoveBlip(targetSrc, viewers)
    self.trackers[targetSrc] = nil
end

function TrackerManager:toggleSubscription(src)
    if self.subscriptions[src] == nil then
        self.subscriptions[src] = true
    else
        self.subscriptions[src] = not self.subscriptions[src]
    end
    
    local stateStr = self.subscriptions[src] and "ENABLED" or "DISABLED"
    dbg.debug("Player %s toggled subscription -> %s", src, stateStr)
    dbg.debug("Current subscriptions: %s", json.encode(self.subscriptions))
    
    if not self.subscriptions[src] then
        for targetSrc, tracker in pairs(self.trackers) do
            if tracker.activeViewers[src] then
                TriggerClientEvent("rcore_police:client:removeBlip", src, targetSrc)
                tracker.activeViewers[src] = nil
            end
        end
    else
        local batch = {}
        for targetSrc, tracker in pairs(self.trackers) do
            local viewers = tracker:getViewers()
            for _, viewerSrc in ipairs(viewers) do
                if viewerSrc == src then
                    local coords = tracker:getCoords()
                    if coords then
                        local trackType = tracker:getTrackType()
                        table.insert(batch, {
                            id = targetSrc,
                            coords = coords,
                            type = trackType
                        })
                        tracker.activeViewers[src] = true
                    end
                    break
                end
            end
        end
        if #batch > 0 then
            TriggerClientEvent("rcore_police:client:updateBlipsBatch", src, batch)
        end
    end
    return self.subscriptions[src]
end

function TrackerManager:subscribe(src)
    self.subscriptions[src] = true
    dbg.debug("Player %s subscribed (auto)", src)
end

function TrackerManager:unsubscribe(src)
    dbg.debug("Player %s unsubscribed/left", src)
    self.subscriptions[src] = nil
end

function TrackerManager:canViewerSee(src, targetSrc)
    if not self:handleLostItem(src) then return false end
    
    local isSubscribed = (self.subscriptions[src] == true)
    dbg.debug("canViewerSee -> player %s subscribed = %s", src, tostring(isSubscribed))
    return isSubscribed
end

function TrackerManager:sendRemoveBlip(targetSrc, viewers)
    for _, viewerSrc in ipairs(viewers) do
        TriggerClientEvent("rcore_police:client:removeBlip", viewerSrc, targetSrc)
    end
end

function TrackerManager:sendUpdates(batches)
    for viewerSrc, batch in pairs(batches) do
        if #batch > 0 then
            TriggerLatentClientEvent("rcore_police:client:updateBlipsBatch", viewerSrc, 10000, batch)
        end
    end
end

function TrackerManager:handleLostItem(src)
    if not Config.Blips.GPS.RequireItem or not Config.Blips.GPS.ItemName then
        return true
    end
    
    if not InventoryService.hasItem(src, Config.Blips.GPS.ItemName, 1) then
        dbg.debug("[GPS] Target %s lost item '%s', removing tracker.", src, Config.Blips.GPS.ItemName)
        self:unsubscribe(src)
        self:unregister(src)
        return false
    end
    return true
end

function TrackerManager:tick()
    if not Config.Blips.Enable then return end
    
    local currentTime = GetGameTimer()
    local batches = {}
    
    for targetSrc, tracker in pairs(self.trackers) do
        if tracker.active and tracker:isEntityValid() then
            local coords = tracker:getCoords()
            local trackType = tracker:getTrackType()
            
            if tracker:shouldUpdate(coords, currentTime) then
                tracker:markUpdated(coords, currentTime)
                local viewers = tracker:getViewers()
                
                dbg.debug("Entity %s has %d viewers: %s", targetSrc, #viewers, json.encode(viewers))
                
                for _, viewerSrc in ipairs(viewers) do
                    if self:canViewerSee(viewerSrc, targetSrc) then
                        dbg.debug("Adding update for viewer %s -> entity %s", viewerSrc, targetSrc)
                        if not batches[viewerSrc] then batches[viewerSrc] = {} end
                        table.insert(batches[viewerSrc], {
                            id = targetSrc,
                            coords = coords,
                            type = trackType
                        })
                        tracker.activeViewers[viewerSrc] = true
                    elseif tracker.activeViewers[viewerSrc] then
                        dbg.debug("Viewer %s lost subscription, removing blip", viewerSrc)
                        TriggerClientEvent("rcore_police:client:removeBlip", viewerSrc, targetSrc)
                        tracker.activeViewers[viewerSrc] = nil
                    end
                end
            end
        end
    end
    
    if next(batches) then
        local viewerCount = 0
        for _ in pairs(batches) do viewerCount = viewerCount + 1 end
        dbg.debug("Sending updates to %d viewers", viewerCount)
        self:sendUpdates(batches)
    else
        dbg.debug("No updates this tick")
    end
end

AddEventHandler("playerDropped", function()
    local src = source
    TrackerManager:unsubscribe(src)
    TrackerManager:unregister(src)
end)

AddEventHandler("rcore_police:server:playerUnloaded", function(src)
    TrackerManager:unsubscribe(src)
    TrackerManager:unregister(src)
end)

CreateThread(function()
    if not Config.Blips.Enable then return end
    while true do
        Wait(1000)
        TrackerManager:tick()
    end
end)
