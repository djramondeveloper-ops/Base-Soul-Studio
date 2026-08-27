-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-event-flow.lua
--  Engineered by Eazy Fxap
--  Original: 229 lines → Cleaned: 76 lines
-- =====================================================

AddEventHandler("rcore_police:server:playerLoaded", function(src)
    if not src then return end
    
    dbg.debug("Server flow | Player loaded event received from player %s named (%s)", src, GetPlayerName(src))
    local retval, statusCode = GroupsService.AddPlayer(src)
    
    if Config.Garages ~= Garages.NONE then
        TriggerEvent("rcore_police:server:requestGarages", src)
    end
    
    if Config.Framework == Framework.ESX then
        local jobs = CacheJobsForPlayer()
        if jobs then
            StartClient(src, "ServerJobs", jobs)
        end
    end
    
    dbg.debug("Server flow | Player named %s and his retval: %s and statusCode %s", GetPlayerName(src), tostring(retval), tostring(statusCode))
    
    if Config.DutySystemState then
        SetTimeout(Config.AutoDutyTimeout or 1000, function()
            if Config.AutoDuty then
                if AUTO_DUTY_STATES[statusCode] then
                    dbg.debug("Duty: Registering auto duty for player named %s (%s) since part of department.", GetPlayerName(src), src)
                    DutyService.EnforceDuty(src, true)
                    Framework.sendNotification(src, _U("DUTY.YOU_ARE_IN_SERVICE"), "success")
                end
            end
        end)
    end
end)

AddEventHandler("rcore_police:server:playerUnloaded", function(src)
    if not src then return end
    
    dbg.debug("Server flow | Player unloaded event received from player %s named (%s)", src, GetPlayerName(src))
    GroupsService.RemovePlayer(src)
    InteractionService.clearPlayerStorage(src)
    UsedItemsCache[src] = nil
    UseableItemsCooldowns[src] = nil
end)

AddEventHandler("rcore_police:server:jobUpdate", function(src, jobName)
    if not src or not jobName then return end
    
    dbg.debug("Server flow | Player jobUpdate event received from player %s named (%s)", src, GetPlayerName(src))
    GroupsService.HandlePlayerJobUpdate(src, jobName, "")
end)

local Listeners = {}

function RegisterListener(eventName, callback)
    if not Listeners[eventName] then
        Listeners[eventName] = {}
    end
    table.insert(Listeners[eventName], callback)
end

function TriggerListeners(eventName, ...)
    if Listeners[eventName] then
        for _, callback in ipairs(Listeners[eventName]) do
            callback(...)
        end
    end
end

exports("registerListener", RegisterListener)

RegisterLocalServerEvent("onGroups", function(groupId, data)
    TriggerListeners("onGroups", groupId, data)
end)

RegisterLocalServerEvent("onState", function(playerSrc, stateKey, stateValue)
    TriggerListeners("onState", playerSrc, stateKey, stateValue)
end)
