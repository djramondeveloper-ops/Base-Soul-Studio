-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-bodycams.lua
--  Engineered by Eazy Fxap
--  Original: 337 lines → Cleaned: 114 lines
-- =====================================================

local ActiveBodyCams = {}
local ActiveDecoyPeds = {}

AddEventHandler("rcore_police:server:playerUnloaded", function(src)
    if not src then return end
    
    local hasCam, camId = HasPlayerActiveBodyCam(src)
    if hasCam then
        return UnregisterPlayerBodyCam(src, camId)
    end
end)

AddEventHandler("rcore_police:server:playerLoaded", function(src)
    if not src then return end
    
    if next(ActiveBodyCams) then
        StartClient(src, "SyncBodyCamsPoolForUser", ActiveBodyCams)
    end
    
    if next(ActiveDecoyPeds) then
        StartClient(src, "SyncDecoyPedPoolForUser", ActiveDecoyPeds)
    end
end)

RegisterNetEvent("rcore_police:server:requestSpectateStarted", function(targetNetId, tabletNetId, _, initiatorSrc)
    if not targetNetId or not initiatorSrc then return end
    
    local hasCam, camId = HasPlayerActiveBodyCam(initiatorSrc)
    local targetEntity = NetworkGetEntityFromNetworkId(targetNetId)
    
    if hasCam and DoesEntityExist(targetEntity) then
        local decoyId = #ActiveDecoyPeds + 1
        local decoyObj = {
            cameraId = camId,
            initiator = initiatorSrc,
            target = source,
            netId = targetNetId,
            tabletNetId = tabletNetId
        }
        
        ActiveDecoyPeds[decoyId] = decoyObj
        TriggerEvent("rcore_police:server:SetBodyCamState", source, true)
        StartClient(-1, "RegisterDecoyPed", decoyId, decoyObj)
    end
end)

RegisterNetEvent("rcore_police:server:requestDeleteDecoyPed", function(targetNetId)
    if not targetNetId then return end
    
    local src = source
    local targetEntity = NetworkGetEntityFromNetworkId(targetNetId)
    local hasDecoy, decoyId = HasPlayerActiveDecoyPed(src)
    
    if DoesEntityExist(targetEntity) then
        local ped = GetPlayerPed(src)
        local pedCoords = GetEntityCoords(ped)
        local targetCoords = GetEntityCoords(targetEntity)
        local dist = #(targetCoords - pedCoords)
        
        if dist <= 10.0 then
            DeleteEntity(targetEntity)
        end
    end
    
    if hasDecoy then
        table.remove(ActiveDecoyPeds, decoyId)
        StartClient(-1, "RemoveDecoyPed", decoyId)
    end
end)

function HasPlayerActiveDecoyPed(playerSrc)
    if next(ActiveDecoyPeds) then
        for decoyId, decoyObj in pairs(ActiveDecoyPeds) do
            if decoyObj.target == playerSrc then
                return true, decoyId
            end
        end
    end
end

function HasPlayerActiveBodyCam(playerSrc)
    if next(ActiveBodyCams) then
        for camId, camObj in pairs(ActiveBodyCams) do
            if camObj.playerId == playerSrc then
                return true, camId
            end
        end
    end
end

function UnregisterPlayerDecoyPed(playerSrc, camId)
    dbg.debug("Player named %s has removed his bodycam!", GetPlayerName(playerSrc))
    Framework.sendNotification(playerSrc, _U("BODYCAMS.DEACTIVATED"), "success")
    table.remove(ActiveBodyCams, camId)
    StartClient(-1, "RemoveBodyCam", camId)
end

function UnregisterPlayerBodyCam(playerSrc, camId)
    dbg.debug("Player named %s has removed his bodycam!", GetPlayerName(playerSrc))
    Framework.sendNotification(playerSrc, _U("BODYCAMS.DEACTIVATED"), "success")
    table.remove(ActiveBodyCams, camId)
    TriggerEvent("rcore_police:server:setBodyCamState", playerSrc, false)
    StartClient(-1, "RemoveBodyCam", camId)
end

function RegisterPlayerBodyCam(playerSrc)
    dbg.debug("Register player bodycam: %s", GetPlayerName(playerSrc))
    
    local hasCam, camId = HasPlayerActiveBodyCam(playerSrc)
    if hasCam then
        return UnregisterPlayerBodyCam(playerSrc, camId)
    end
    
    local camObj = {
        playerId = playerSrc,
        playerCoords = GetEntityCoords(GetPlayerPed(playerSrc)),
        officerName = Framework.getCharacterShortName(playerSrc),
        location = ""
    }
    
    local newCamId = #ActiveBodyCams + 1
    ActiveBodyCams[newCamId] = camObj
    
    dbg.debug("Player named %s has activated his bodycam!", GetPlayerName(playerSrc))
    Framework.sendNotification(playerSrc, _U("BODYCAMS.ACTIVATED"), "success")
    TriggerEvent("rcore_police:server:SetBodyCamState", playerSrc, true)
    StartClient(-1, "RegisterBodyCam", camObj)
end
