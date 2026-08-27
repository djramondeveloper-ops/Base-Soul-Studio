-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-images.lua
--  Engineered by Eazy Fxap
--  Original: 47 lines → Cleaned: 18 lines
-- =====================================================

NetworkService.RegisterNetEvent("ViewPhoto", function(success, photoData)
    if success then ViewPhoto(photoData) end
end)

NetworkService.RegisterNetEvent("StartCamera", function(success, cameraData)
    if success then StartCamera(cameraData) end
end)

NetworkService.RegisterNetEvent("StartPhotoEffect", function(success)
    if success then PlayTakePhotoSound() end
end)
