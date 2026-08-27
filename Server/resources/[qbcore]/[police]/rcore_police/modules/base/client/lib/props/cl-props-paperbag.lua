-- =====================================================
--  rcore_police · modules/base/client/lib/props/cl-props-paperbag.lua
--  Engineered by Eazy Fxap
--  Original: 124 lines → Cleaned: 40 lines
-- =====================================================

local offset = { 0.232, 0.0, 0.0, 0.0, -90.0, 0.0 }

function Props.RequestPaperBag(model)
    local ped = PlayerPedId()
    model = model or "prop_food_bag2"
    
    if Interactions.PaperBag.state then
        Interactions.PaperBag.state = false
        if DoesEntityExist(Interactions.PaperBag.entity) then
            DeleteEntity(Interactions.PaperBag.entity)
        end
        ClearPedTasksImmediately(ped, true)
        IsPropSessionActive = false
        TriggerServerEvent("rcore_police:server:unregisterDeploy")
        return
    end
    
    if not HasStreamedTextureDictLoaded("prop_ld_paper_bag") then
        RequestStreamedTextureDict("prop_ld_paper_bag")
    end
    
    local boneCoords = GetPedBoneCoords(ped, 12844, 0.0, 0.0, 0.0)
    local entity = UtilsService.SpawnObject(model, boneCoords, true, true)
    SetEntityCollision(entity, false, false)
    AttachEntityToEntity(entity, ped, GetPedBoneIndex(ped, 12844), offset[1], offset[2], offset[3], offset[4], offset[5], offset[6], true, false, false, true, 0, true)
    
    IsPropSessionActive = false
    Interactions.PaperBag.state = true
    Interactions.PaperBag.entity = entity
end
