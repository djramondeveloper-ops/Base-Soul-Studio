-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-images.lua
--  Engineered by Eazy Fxap
--  Original: 695 lines → Cleaned: 180 lines
-- =====================================================

local isCameraActive = false
local cameraProp = nil
local cameraHandle = nil
local maxZoom = 70.0
local minZoom = 10.0
local currentZoom = 50.0
local animTimer = 0
local animCooldown = 500
local targetPed = nil
local CAMERA_MODEL = 680380202 -- "prop_pap_camera_01"
local CAMERA_DICT = "amb@world_human_paparazzi@male@base"
local CAMERA_ANIM = "base"

function ViewPhoto(options)
    if IsNuiFocused() or IsPauseMenuActive() then return end
    if isCameraActive then return end
    
    local data = {
        showState = true,
        options = options
    }
    
    UI.SendReactMessage(NUI_EVENTS.VIEW_PHOTO, data)
    SetNuiFocus(true, true)
end

function CheckModelLoaded(model)
    if not IsModelInCdimage(model) then return false end
    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

function CheckAnimDictLoaded(dict)
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

function StartCameraInternal(ped)
    if not CheckModelLoaded(CAMERA_MODEL) then return false end
    
    local coords = GetEntityCoords(ped)
    cameraProp = CreateObject(CAMERA_MODEL, coords.x, coords.y, coords.z + 0.2, true, true, false)
    local boneIndex = GetPedBoneIndex(ped, 28422)
    
    AttachEntityToEntity(cameraProp, ped, boneIndex, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(CAMERA_MODEL)
    
    if CheckAnimDictLoaded(CAMERA_DICT) then
        TaskPlayAnim(ped, CAMERA_DICT, CAMERA_ANIM, 2.0, 2.0, -1, 1, 0, false, false, false)
    end
    
    cameraHandle = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
    AttachCamToEntity(cameraHandle, ped, 0.0, 1.0, 0.8, true)
    SetCamRot(cameraHandle, 0.0, 0.0, GetEntityHeading(ped), 2)
    SetCamFov(cameraHandle, currentZoom)
    RenderScriptCams(true, false, 0, true, false)
    SetTimecycleModifier("default")
    SetTimecycleModifierStrength(0.3)
    SetCurrentPedWeapon(ped, -1569615261, true) -- Unarmed
    
    return true
end

function StopCamera(ped)
    if cameraProp and DoesEntityExist(cameraProp) then
        DetachEntity(cameraProp, true, true)
        DeleteObject(cameraProp)
        cameraProp = nil
    end
    
    if cameraHandle then
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cameraHandle, false)
        cameraHandle = nil
    end
    
    ClearTimecycleModifier()
    SetNightvision(false)
    SetSeethrough(false)
    currentZoom = (maxZoom + minZoom) * 0.5
    targetPed = nil
    animTimer = 0
    UI.HelpKeys(nil, false)
    ClearPedTasks(ped)
end

function HandleCameraRotation(cam, zoomOffset)
    local x = GetDisabledControlNormal(0, 220)
    local y = GetDisabledControlNormal(0, 221)
    if x == 0.0 and y == 0.0 then return end
    
    local rot = GetCamRot(cam, 2)
    local heading = GetEntityHeading(targetPed)
    local factor = -8.0 * (zoomOffset + 0.1)
    
    local newZ = rot.z + (x * factor)
    local newX = math.max(math.min(20.0, rot.x + (y * factor)), -89.5)
    
    local diff = newZ - heading
    if diff > 180.0 then diff = diff - 360.0
    elseif diff < -180.0 then diff = diff + 360.0 end
    
    if diff > 90.0 then newZ = heading + 90.0
    elseif diff < -90.0 then newZ = heading - 90.0 end
    
    SetCamRot(cam, newX, 0.0, newZ, 2)
end

function HandleCameraZoom(cam)
    if IsControlJustPressed(0, 96) then -- Scroll up
        currentZoom = math.max(currentZoom - 10.0, minZoom)
    elseif IsControlJustPressed(0, 97) then -- Scroll down
        currentZoom = math.min(currentZoom + 10.0, maxZoom)
    end
    
    local fov = GetCamFov(cam)
    if math.abs(currentZoom - fov) < 0.6 then
        currentZoom = fov
    else
        SetCamFov(cam, fov + (currentZoom - fov) * 0.05)
    end
end

function PlayTakePhotoSound()
    AnimpostfxPlay("FocusOut", 0, false)
    PlaySoundFrontend(-1, "Camera_Shoot", "Phone_SoundSet_Michael", true)
    Wait(250)
    AnimpostfxStop("FocusOut")
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

function TakePhoto()
    if not isCameraActive or not cameraProp or not DoesEntityExist(cameraProp) then return end

    local webhook = GetConvar("Discord_MDT", "")
    if not webhook or webhook == "" then
        TriggerServerEvent("rcore_police:server:cameraUploadUnavailable")
        return
    end

    if GetResourceState("screenshot-basic") ~= "started" then
        TriggerServerEvent("rcore_police:server:cameraUploadUnavailable")
        return
    end

    local coords = GetEntityCoords(PlayerPedId())
    local metadata = { location = GetStreetNameFromCoords(coords) }
    local cameraNetId = ObjToNet(cameraProp)

    exports["screenshot-basic"]:requestScreenshotUpload(
        webhook,
        "files[]",
        { encoding = "webp", quality = 0.75 },
        function(response)
            local ok, payload = pcall(json.decode, response or "")
            local attachment = ok and payload and payload.attachments and payload.attachments[1]
            local url = attachment and attachment.url

            if type(url) == "string" and url:sub(1, 8) == "https://" then
                TriggerServerEvent("rcore_police:server:requestCameraPhotoUrl", cameraNetId, metadata, url)
            else
                TriggerServerEvent("rcore_police:server:cameraUploadUnavailable")
            end
        end
    )
end

function StartCamera()
    if IsNuiFocused() or IsPauseMenuActive() then return end
    
    if isCameraActive then
        isCameraActive = false
        StopCamera(targetPed or PlayerPedId())
        currentZoom = 50.0
        targetPed = nil
        animTimer = 0
        return
    end
    
    local ped = PlayerPedId()
    targetPed = ped
    
    if StartCameraInternal(ped) then
        isCameraActive = true
        currentZoom = 50.0
        animTimer = GetGameTimer()
        
        UI.HelpKeys({
            keys = {
                { key = "", label = _U("CAMERA.ZOOM_HELPTEXT") },
                { key = "ENTER", label = _U("CAMERA.TAKE_PHOTO_HELPKEY") },
                { key = "BACKSPACE", label = _U("CAMERA.EXIT_HELPKEY") }
            }
        }, true)
    end
end

CreateThread(function()
    while true do
        if isCameraActive then
            local time = GetGameTimer()
            targetPed = targetPed or PlayerPedId()
            
            if IsEntityDead(targetPed) then
                isCameraActive = false
                StopCamera(targetPed)
                Wait(1000)
            end
            
            HideHudAndRadarThisFrame()
            
            if time - animTimer > animCooldown then
                if not IsEntityPlayingAnim(targetPed, CAMERA_DICT, CAMERA_ANIM, 3) then
                    TaskPlayAnim(targetPed, CAMERA_DICT, CAMERA_ANIM, 2.0, 2.0, -1, 1, 0, false, false, false)
                end
                animTimer = time
            end
            
            if cameraHandle then
                local zoomOffset = (1.0 / (maxZoom - minZoom)) * (currentZoom - minZoom)
                HandleCameraRotation(cameraHandle, zoomOffset)
                HandleCameraZoom(cameraHandle)
            end
            
            if IsControlJustPressed(0, 201) then -- Enter
                TakePhoto()
            elseif IsControlJustPressed(0, 194) then -- Backspace
                isCameraActive = false
                StopCamera(targetPed)
                Wait(100)
            end
            Wait(0)
        else
            Wait(1000)
        end
    end
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() and isCameraActive then
        isCameraActive = false
        StopCamera(targetPed or PlayerPedId())
    end
end)
