-- =====================================================
--  rcore_police · modules/base/client/lib/props/cl-props-wheelclamp.lua
--  Engineered by Eazy Fxap
--  Original: 660 lines → Cleaned: 160 lines
-- =====================================================

local WheelClampProp = Config.Props.ModelDataByPropType[PROP_TYPES.WHEEL_CLAMP].prop
local PlacedClamps = {}

local Bones = Config.WheelClamp.Bones or {
    "wheel_lf", "wheel_rf", "wheel_lr", "wheel_rr", 
    "wheel_lm1", "wheel_rm1", "wheel_lm2", "wheel_rm2", "wheel_lm3", "wheel_rm3"
}

NetworkService.RegisterNetEvent("RemoveWheelClamp", function(id)
    if id then
        RemoveWheelClamp()
    end
end)

function GetWheelSide(boneName)
    if string.find(boneName, "_l") then return "left" end
    if string.find(boneName, "_r") then return "right" end
    return "unknown"
end

function RemoveWheelClamp()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh, vehDist = GetNearbyVehicle(coords, 5.0)
    
    if veh then
        if PlacedClamps[veh] and next(PlacedClamps[veh]) then
            local closestDist = nil
            local closestClamp = nil
            local closestId = nil
            
            for id, clamp in pairs(PlacedClamps[veh]) do
                local clampPos = vector3(clamp.coords.x, clamp.coords.y, clamp.coords.z)
                local dist = #(coords - clampPos)
                
                if not closestDist or dist < closestDist then
                    closestDist = dist
                    closestClamp = clamp
                    closestId = clamp.id
                end
            end
            
            if closestId and closestDist <= Config.WheelClamp.DistanceToBoneToRemove then
                TriggerServerEvent("rcore_police:server:requestRemoveProp", closestId, PROP_TYPES.WHEEL_CLAMP)
            end
        else
            Framework.sendNotification(_U("WHEEL_CLAMP.NOT_ANY_WHEEL_CLAMP_ON_THIS_VEHICLE"), "error")
        end
    else
        Framework.sendNotification(_U("WHEEL_CLAMP.NOT_CLOSE_TO_VEHICLE"), "error")
    end
end

function GetClosestWheelBone(veh)
    local coords = GetEntityCoords(PlayerPedId())
    local closestBone = nil
    local closestPos = nil
    local closestDist = math.huge
    
    for _, boneName in ipairs(Bones) do
        local boneIdx = GetEntityBoneIndexByName(veh, boneName)
        if boneIdx ~= -1 then
            local bonePos = GetWorldPositionOfEntityBone(veh, boneIdx)
            local dist = #(coords - bonePos)
            if dist < closestDist and dist <= 1.5 then
                closestDist = dist
                closestBone = boneName
                closestPos = bonePos
            end
        end
    end
    
    return closestBone, closestPos
end

function GetCurrentAnimationTime(ped, dict, anim)
    local duration = GetAnimDuration(dict, anim)
    if duration <= 0.0 then return nil end
    return math.floor((duration * 1.0) * 1000)
end

function GetNearbyVehicle(coords, radius)
    local isVeh = false
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, radius or 2.0, 0, 7)
    if veh ~= 0 then
        isVeh = true
    end
    return isVeh, veh
end

function getClampNumber(id)
    local num = string.match(id, "WHEEL_CLAMP_(%d+)")
    return tonumber(num)
end

function WheelClampSpawn(entity, data)
    local objData = data.object
    local veh = NetToVeh(objData.vehNetId)
    if not DoesEntityExist(veh) then return end
    
    SetEntityCollision(entity, false, false)
    SetEntityDynamic(entity, false)
    SetEntityAlwaysPrerender(entity, true)
    PlaceObjectOnGroundProperly(entity)
    
    local boneIdx = GetEntityBoneIndexByName(veh, objData.wheelBone)
    local side = GetWheelSide(objData.wheelBone)
    
    if boneIdx ~= -1 then
        local bonePos = GetWorldPositionOfEntityBone(veh, boneIdx)
        local rot = GetEntityRotation(veh, 2)
        
        local targetPos
        if side == "left" then
            targetPos = vector3(bonePos.x, bonePos.y - 0.5, bonePos.z)
        else
            targetPos = vector3(bonePos.x, bonePos.y + 0.5, bonePos.z)
        end
        
        SetEntityCoords(entity, bonePos.x, bonePos.y, bonePos.z - 0.1, false, false, false, true)
        SetEntityRotation(entity, rot.x, rot.y, rot.z, 2, true)
    end
    
    if not PlacedClamps[veh] then
        PlacedClamps[veh] = {}
    end
    
    PlacedClamps[veh][data.id] = {
        id = getClampNumber(data.id),
        bone = objData.wheelBone,
        coords = GetEntityCoords(entity)
    }
end

function WheelClampDespawn(veh)
    if PlacedClamps[veh] then
        PlacedClamps[veh] = nil
        SetVehicleHandbrake(veh, false)
        SetVehicleBrake(veh, false)
        dbg.debug("Wheel clamp: Enabling movement of vehicle named %s", GetEntityArchetypeName(veh))
    end
end

function DoesVehicleHaveWheelClamp(veh)
    local coords = GetEntityCoords(PlayerPedId())
    if veh and DoesEntityExist(veh) then
        if PlacedClamps[veh] then return true, "HAS_CLAMP_ON_VEHICLE" end
    end
    
    local isVeh, nearbyVeh = GetNearbyVehicle(coords, 5.0)
    if isVeh and PlacedClamps[nearbyVeh] then
        return true, "HAS_CLAMP_ON_VEHICLE"
    end
    
    return false, "NOT_CLAMP_ON_VEHICLE"
end

function Props.RequestWheelClamp(model)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local isVeh, veh = GetNearbyVehicle(coords, 5.0)
    
    if isVeh then
        local boneName, bonePos = GetClosestWheelBone(veh)
        local animTime = GetCurrentAnimationTime("amb@prop_human_bum_bin@idle_b", "idle_d")
        
        if not boneName then
            Framework.sendNotification(_U("WHEEL_CLAMP.NOT_CLOSE_TO_WHEEL"), "error")
            TriggerServerEvent("rcore_police:server:unregisterDeploy")
            IsPropSessionActive = false
            return
        end
        
        animTime = animTime or 1700
        
        CancellableProgress(animTime - 700, _U("PROPS.PLACING_OBJECT", _U("WHEEL_CLAMP.PG_TITLE")), "amb@prop_human_bum_bin@idle_b", "idle_d", 1, function()
            TriggerServerEvent("rcore_police:server:deployProp", {
                type = PROP_TYPES.WHEEL_CLAMP,
                pos = bonePos,
                wheelBone = boneName,
                vehNetId = VehToNet(veh)
            })
            ClearPedTasksImmediately(ped)
            IsPropSessionActive = false
            Framework.sendNotification(_U("WHEEL_CLAMP.PLACED"), "success")
        end, function()
            TriggerServerEvent("rcore_police:server:unregisterDeploy")
            IsPropSessionActive = false
        end, { previewObject = false })
    else
        TriggerServerEvent("rcore_police:server:unregisterDeploy")
        IsPropSessionActive = false
        Framework.sendNotification(_U("WHEEL_CLAMP.NOT_CLOSE_TO_VEHICLE"), "error")
    end
end

CreateThread(function()
    if not Config.WheelClamp.Enable then return end
    while true do
        Wait(250)
        if next(PlacedClamps) then
            for veh, clamps in pairs(PlacedClamps) do
                if DoesEntityExist(veh) and GetVehiclePedIsIn(PlayerPedId(), false) == veh then
                    SetVehicleHandbrake(veh, true)
                    SetVehicleBrake(veh, true)
                end
            end
        else
            Wait(1000)
        end
    end
end)

AddEventHandler("onResourceStart", function(res)
    if res ~= GetCurrentResourceName() then return end
    
    for _, obj in ipairs(GetGamePool("CObject")) do
        if DoesEntityExist(obj) and GetEntityArchetypeName(obj) == WheelClampProp then
            NetworkRequestControlOfEntity(obj)
            local timeout = GetGameTimer() + 2000
            while not NetworkHasControlOfEntity(obj) and timeout > GetGameTimer() do
                Wait(0)
                NetworkRequestControlOfEntity(obj)
            end
            
            if not IsEntityAMissionEntity(obj) then
                SetEntityAsMissionEntity(obj, true, true)
            end
            DeleteEntity(obj)
        end
    end
end)
