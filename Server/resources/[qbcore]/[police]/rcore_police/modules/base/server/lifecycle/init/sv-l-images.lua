-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-images.lua
--  Engineered by Eazy Fxap
--  Original: 131 lines → Cleaned: 33 lines
-- =====================================================

function IsEntityACamera(entityNetId)
    if not entityNetId then return false end
    local entity = NetworkGetEntityFromNetworkId(entityNetId)
    if DoesEntityExist(entity) then
        if GetEntityModel(entity) == 680380202 then
            return true
        end
    end
    return false
end

local function IsValidPhotoUrl(url)
    return type(url) == "string" and #url <= 2048 and url:sub(1, 8) == "https://"
end

local function StorePhoto(src, url, metadata)
    if not InventoryService.hasItem(src, Items.Camera, 1) then return end

    Framework.sendNotification(src, _U("CAMERA.PROCESSING_PHOTO"), "success")
    local meta = CameraMetadata({ url = url }, metadata)
    local added = InventoryService.addItem(src, Items.Photo, 1, meta)

    if added ~= false then
        StartClient(src, "StartPhotoEffect")
        Framework.sendNotification(src, _U("CAMERA.PROCESSING_PHOTO_FINISHED"), "success")
    end
end

RegisterNetEvent("rcore_police:server:requestCameraPhotoUrl", function(entityNetId, metadata, url)
    local src = source
    if not Config.Image.AllowCameraItem then return end
    if not entityNetId or not IsEntityACamera(entityNetId) then return end
    if not IsValidPhotoUrl(url) then return end

    if type(metadata) ~= "table" then metadata = {} end
    metadata.location = tostring(metadata.location or "Unknown"):sub(1, 160)

    StorePhoto(src, url, metadata)
end)

RegisterNetEvent("rcore_police:server:cameraUploadUnavailable", function()
    local src = source
    Framework.sendNotification(src, "Camera policial: configure Discord_MDT e mantenha screenshot-basic iniciado.", "error")
end)
