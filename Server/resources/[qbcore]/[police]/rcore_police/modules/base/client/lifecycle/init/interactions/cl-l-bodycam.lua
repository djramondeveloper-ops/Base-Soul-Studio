-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-bodycam.lua
--  Engineered by Eazy Fxap
--  Original: 1232 lines → Cleaned: 350 lines
-- =====================================================

BodyCams = BodyCams or {}
local activeBodycamProp = nil
local allCreatedProps = {}
local decoyPeds = {}
local spectateData = {
    IsActive = false,
    CameraId = nil,
    Camera = nil,
    TargetPed = nil,
    DecoyPed = nil
}
local tabletProp = nil
local TABLET_DICT = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local TABLET_NAME = "base"
local TABLET_MODEL = -1585232418
local TABLET_BONE = 60309
local TABLET_POS = vector3(0.03, 0.002, 0.0)
local TABLET_ROT = vector3(10.0, 160.0, 0.0)
local isTabletAnimPlaying = false

NetworkService.RegisterNetEvent("OpenBodyCamsFeed", function(success)
    if success then OpenBodyCams() end
end)

NetworkService.RegisterNetEvent("SyncBodyCamsPoolForUser", function(success, data)
    if success and data then BodyCams = data end
end)

NetworkService.RegisterNetEvent("SyncDecoyPedPoolForUser", function(success, data)
    if success and data then decoyPeds = data end
end)

RegisterNetEvent("rcore_police:client:RegisterDecoyPed", function(id, data)
    if not id or not data then return end
    decoyPeds[id] = data
end)

RegisterNetEvent("rcore_police:client:RemoveDecoyPed", function(id)
    if not id then return end
    local decoy = decoyPeds[id]
    if not decoy then return end
    
    if decoy.tabletNetId then
        local prop = NetworkGetEntityFromNetworkId(decoy.tabletNetId)
        if DoesEntityExist(prop) then DeleteEntity(prop) end
    end
    decoyPeds[id] = nil
end)

RegisterNuiCallback("SPECTATE_TARGET_PLAYER", function(data, cb)
    if not data.playerId or not data.cameraId then return end
    SpectatePlayer(data.playerId, data.cameraId)
    cb("OK")
end)

CreateThread(function()
    UtilsService.LoadAnimationDict(TABLET_DICT)
    local waitTime = Config.BodyCams and Config.BodyCams.ThreadTime or 250
    
    while true do
        Wait(waitTime)
        
        -- Handle Decoy Peds (Tablets)
        if decoyPeds and next(decoyPeds) then
            for _, decoy in pairs(decoyPeds) do
                if decoy.netId and BodyCams[spectateData.CameraId] then
                    local ped = PlayerPedId()
                    local pCoords = GetEntityCoords(ped)
                    local dist = #(pCoords - BodyCams[spectateData.CameraId].playerCoords)
                    
                    if dist <= 150 then
                        local dPed = NetworkGetEntityFromNetworkId(decoy.netId)
                        if DoesEntityExist(dPed) then
                            if not IsEntityPlayingAnim(dPed, TABLET_DICT, TABLET_NAME, 3) then
                                TaskPlayAnim(dPed, TABLET_DICT, TABLET_NAME, 3.0, 3.0, -1, 49, 0, false, false, false)
                                ClonePedToTarget(ped, dPed)
                            end
                        else
                            if DoesEntityExist(dPed) then DeleteEntity(dPed) end
                        end
                    end
                end
            end
        end
        
        -- Handle Active Spectation
        if spectateData.IsActive and IsCamActive(spectateData.Camera) then
            SetCamRot(spectateData.Camera, 0, 0, GetEntityHeading(spectateData.TargetPed), 2)
            
            local pCoords = GetEntityCoords(PlayerPedId())
            local tCoords = GetEntityCoords(spectateData.TargetPed)
            local dist = #(tCoords - pCoords)
            
            local camData = BodyCams[spectateData.CameraId]
            if camData then
                UI.HelpKeys({
                    keys = {
                        { label = string.format("%s: %s", _U("BODYCAMS.LABEL_OFFICER"), camData.officerName) },
                        { label = string.format("%s: %s", _U("BODYCAMS.LABEL_CAMERA_ID"), spectateData.CameraId) },
                        { label = string.format("%s: %s", _U("BODYCAMS.LABEL_LOCATION"), GetPlayerStreetName(MyServerId)) },
                        { label = _U("BODYCAMS.LABEL_EXIT"), key = Config.BodyCams.ExitCamKey }
                    }
                }, true)
                
                if dist >= 150 then
                    HandleLocation(spectateData.TargetPed)
                end
            end
        end
    end
end)

function DoTabletAnimation(ped)
    if isTabletAnimPlaying then
        isTabletAnimPlaying = false
        return
    end
    isTabletAnimPlaying = true
    
    UtilsService.LoadAnimationDict(TABLET_DICT)
    RequestModel(TABLET_MODEL)
    while not HasModelLoaded(TABLET_MODEL) do Citizen.Wait(100) end
    
    tabletProp = CreateObject(TABLET_MODEL, 0.0, 0.0, 0.0, true, true, false)
    local boneId = GetPedBoneIndex(ped, TABLET_BONE)
    
    AttachEntityToEntity(tabletProp, ped, boneId, TABLET_POS.x, TABLET_POS.y, TABLET_POS.z, TABLET_ROT.x, TABLET_ROT.y, TABLET_ROT.z, true, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(TABLET_MODEL)
    
    CreateThread(function()
        while isTabletAnimPlaying do
            Wait(0)
            if not IsEntityPlayingAnim(ped, TABLET_DICT, TABLET_NAME, 3) then
                TaskPlayAnim(ped, TABLET_DICT, TABLET_NAME, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end
    end)
end

function HandleLocation(ped, teleportCoords)
    local plyPed = PlayerPedId()
    if not ped then
        if teleportCoords then
            SetEntityCoords(plyPed, teleportCoords.x, teleportCoords.y, teleportCoords.z - 1, false, false, false, false)
        end
        return
    end
    
    local tCoords = GetEntityCoords(ped)
    SetEntityCoords(plyPed, tCoords.x, tCoords.y, tCoords.z - 1, false, false, false, false)
end

function HandleSpectator(ped, isSpectating)
    if not ped then return end
    if isSpectating then
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, false)
        SetEntityCollision(ped, false, false)
        SetEntityInvincible(ped, true)
    else
        FreezeEntityPosition(ped, false)
        SetEntityVisible(ped, true, true)
        SetEntityCollision(ped, true, true)
        SetEntityInvincible(ped, false)
    end
end

function CreateSpectatorClone()
    local ped = PlayerPedId()
    if not ped or not spectateData.CameraId then return end
    
    local heading = GetEntityHeading(ped)
    local model = GetEntityModel(ped)
    spectateData.DecoyPed = CreatePed(4, model, spectateData.CameraId.x, spectateData.CameraId.y, spectateData.CameraId.z - 1, heading, true, true)
    
    table.insert(allCreatedProps, spectateData.DecoyPed)
    ClonePedToTarget(ped, spectateData.DecoyPed)
    FreezeEntityPosition(spectateData.DecoyPed, true)
    SetEntityInvincible(spectateData.DecoyPed, true)
    SetBlockingOfNonTemporaryEvents(spectateData.DecoyPed, true)
    SetPedDefaultComponentVariation(spectateData.DecoyPed)
    
    Wait(500)
    DoTabletAnimation(spectateData.DecoyPed)
    dbg.debug("Decoy ped spawned for all clients!")
end

function CheckSpectatorPoolToTarget(coords)
    local ped = PlayerPedId()
    local pCoords = GetEntityCoords(ped)
    local dist = #(coords - pCoords)
    if dist >= 150 then
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    else
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false)
    end
end

function SpectatePlayer(playerId, cameraId)
    if not playerId then return end
    if MyServerId == playerId then
        return dbg.critical("Cannot spectate yourself, error received playerId: %s targetPed == plyPed", playerId)
    end
    
    local plyPed = PlayerPedId()
    local pCoords = GetEntityCoords(plyPed)
    spectateData.CameraId = pCoords -- Storing original coords briefly? Wait, L0_1 = L3_2
    
    local camData = BodyCams[cameraId]
    if not camData then return end
    
    DoScreenFadeOut(0)
    HandleSpectator(plyPed, true)
    CheckSpectatorPoolToTarget(camData.playerCoords)
    Wait(500)
    
    local targetPed = UtilsService.GetPlayerPedFromServerId(playerId)
    if not targetPed then
        DoScreenFadeIn(0)
        StopBodyCam()
        return dbg.critical("Failed to get target ped from serverId! Enforcing stop spectate unexpected error.")
    end
    
    if targetPed == plyPed then
        DoScreenFadeIn(0)
        StopBodyCam()
        return dbg.critical("Cannot spectate yourself, error received playerId: %s targetPed == plyPed", playerId)
    end
    
    dbg.debug("Bodycams: Spectator, preparing camera at the officer location..")
    local heading = GetEntityHeading(targetPed)
    local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
    local boneOffset = vec3(0.126832, 0.143209, 0.119865)
    
    CreateSpectatorClone()
    AttachCamToPedBone(cam, targetPed, 24818, boneOffset.x, boneOffset.y, boneOffset.z, true)
    SetCamFov(cam, 100.0)
    SetCamRot(cam, 0, 0, heading, 2)
    RenderScriptCams(true, false, 0, 1, 0)
    ShakeCam(cam, "HAND_SHAKE", 1.0)
    SetCamShakeAmplitude(cam, 2.0)
    
    if Config.BodyCams.Spectate.EnableScreenEffects then
        SetTimecycleModifier(Config.BodyCams.Spectate.EffectName)
        SetTimecycleModifierStrength(Config.BodyCams.Spectate.EffectModifier or 0.5)
    end
    
    DoScreenFadeIn(1000)
    spectateData.TargetPed = targetPed
    spectateData.Camera = cam
    spectateData.CameraId = cameraId
    
    dbg.debug("Bodycams: Spectator fully loaded on the officer cam with ID: %s", spectateData.CameraId)
    
    TriggerServerEvent("rcore_police:server:requestSpectateStarted", PedToNet(spectateData.DecoyPed), ObjToNet(tabletProp), spectateData.CameraId, playerId)
    spectateData.IsActive = true
end

function StopBodyCam()
    if not spectateData.IsActive then return end
    
    local plyPed = PlayerPedId()
    -- spectateData.CameraId was used to store initial coords. It's confusing but we'll use a local if it exists.
    if type(spectateData.CameraId) == "vector3" then
        dbg.debug("Bodycams: Teleporting spectator to initial location: %s %s %s", spectateData.CameraId.x, spectateData.CameraId.y, spectateData.CameraId.z)
        SetEntityCoords(plyPed, spectateData.CameraId.x, spectateData.CameraId.y, spectateData.CameraId.z - 1, false, false, false, false)
    end
    
    if spectateData.DecoyPed and DoesEntityExist(spectateData.DecoyPed) then
        dbg.debug("BodyCams: Deleting decoy ped.")
        TriggerServerEvent("rcore_police:server:requestDeleteDecoyPed", PedToNet(spectateData.DecoyPed))
        DeleteEntity(spectateData.DecoyPed)
        DoTabletAnimation(spectateData.DecoyPed) -- This will toggle the anim off since it was true
        spectateData.DecoyPed = nil
    end
    
    if IsCamActive(spectateData.Camera) then
        dbg.debug("BodyCams: Deleting spectator camera.")
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(spectateData.Camera, false)
        spectateData.Camera = nil
    end
    
    ClearTimecycleModifier()
    HandleSpectator(plyPed, false)
    
    spectateData.TargetPed = nil
    spectateData.IsActive = false
    
    dbg.debug("Bodycams: Spectator - fully exited from the player.")
    UI.HelpKeys(nil, false)
end

function GetStreetNameFromCoords(coords)
    if not coords then return "Unknown" end
    local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local n1 = GetStreetNameFromHashKey(s1)
    local n2 = GetStreetNameFromHashKey(s2)
    if n2 and n2 ~= "" then
        return n1 .. " & " .. n2
    end
    return n1
end

function GetPlayerStreetName(serverId)
    local ped = UtilsService.GetPlayerPedFromServerId(serverId)
    if not ped then return "" end
    local coords = GetEntityCoords(ped)
    return GetStreetNameFromCoords(coords)
end

function HandleBodyCamProp()
    if activeBodycamProp and DoesEntityExist(activeBodycamProp) then
        DetachEntity(activeBodycamProp, false, false)
        DeleteEntity(activeBodycamProp)
        activeBodycamProp = nil
        dbg.debug("Removing active bodycam prop!")
        return
    end
    
    if not IsModelValid("rdesign_bodycam_ex_small_dark") then
        return dbg.critical("Bodycam spawn on ped: Failed to detected streamed folder rcore_police_assets_bodycam, ensure it!")
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    activeBodycamProp = UtilsService.SpawnObject("rdesign_bodycam_ex_small_dark", coords, true, false, false)
    
    local boneId = Config.BodyCams.Prop.BoneId or 24818
    local pos = Config.BodyCams.Prop.Pos or vec3(0.126832, 0.143209, 0.119865)
    local rot = Config.BodyCams.Prop.Rot or vec3(-14.502323, 100, 100)
    
    AttachEntityToEntity(activeBodycamProp, ped, GetPedBoneIndex(ped, boneId), pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, true, true, false, true, 1, true)
    
    if Config.BodyCams.HideModel then
        SetEntityAlpha(activeBodycamProp, 0, false)
    end
    SetEntityCollision(activeBodycamProp, false, false)
    SetModelAsNoLongerNeeded("rdesign_bodycam_ex_small_dark")
    dbg.debug("Attaching bodycam to player, activated!")
end

RegisterNetEvent("rcore_police:client:RegisterBodyCam", function(data)
    if data.playerId then
        data.location = GetPlayerStreetName(data.playerId)
        if data.playerId == MyServerId then
            HandleBodyCamProp()
        end
    end
    table.insert(BodyCams, data)
end)

RegisterNetEvent("rcore_police:client:RemoveBodyCam", function(id)
    if not id then return end
    if BodyCams[id] then
        if BodyCams[id].playerId == MyServerId then
            HandleBodyCamProp()
        end
        table.remove(BodyCams, id)
        dbg.debug("Removed bodycam with ID: %s", id)
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        if activeBodycamProp and DoesEntityExist(activeBodycamProp) then
            DeleteEntity(activeBodycamProp)
        end
        if allCreatedProps and next(allCreatedProps) then
            for k, prop in pairs(allCreatedProps) do
                if DoesEntityExist(prop) then
                    DeleteEntity(prop)
                    allCreatedProps[k] = nil
                end
            end
        end
    end
end)

RegisterKey(StopBodyCam, "RCORE_POLICE_STOP_BODYCAM", _U("KEY_MAPPING.EXIT_BODYCAM"), Config.BodyCams.ExitCamKey or "E", nil, { state = true, cooldown = 250 })
