--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

local allowedModels = {}
local _modelRevision = "5076c59ea539de616e0e398f08bab4ac"
local pumpModelAliases = {}

-- Native GTA uses prop_gas_pump_old2 at several old/Globe Oil style stations.
-- rcore_fuel normally swaps those objects to prop_gas_pump_old2_rc, but the
-- swap can be bypassed by map/MLO replacements or streaming order. Treat the
-- native model as a first-class alias of the rcore replacement so interaction,
-- rope offsets and scaleform data continue to work even when the swap did not.
local NATIVE_OLD2_PUMP_HASH = GetHashKey("prop_gas_pump_old2")
local RCORE_OLD2_PUMP_HASH = GetHashKey("prop_gas_pump_old2_rc")

for _, v in pairs(Config.SupportedGasPumpModel) do
    allowedModels[v.modelHash] = true
    Config.resolution[v.modelHash] = v.inGameUIData

    if v.modelHash == RCORE_OLD2_PUMP_HASH then
        pumpModelAliases[NATIVE_OLD2_PUMP_HASH] = v
        allowedModels[NATIVE_OLD2_PUMP_HASH] = true
        Config.resolution[NATIVE_OLD2_PUMP_HASH] = v.inGameUIData
    end
end

-- FIX 1: some server maps override a pump's prop model for detection purposes
-- (see the map-compatibility block further down in config/shop_config.lua) but
-- that override hash was never added as its own Config.SupportedGasPumpModel
-- entry, so every function below that indexes it directly would crash with
-- "attempt to index a nil value" for that pump. Fall back to a generic,
-- widely-used pump model's offsets rather than crashing -- positions may not
-- be pixel-perfect for a model-specific prop, but the pump stays usable, and
-- /pumpeditor already exists for a server owner to fine-tune per-model offsets.
local GENERIC_FALLBACK_PUMP_HASH = GetHashKey("prop_gas_pump_1a")
local function GetSupportedPumpModelData(modelHash)
    return Config.SupportedGasPumpModel[modelHash]
        or pumpModelAliases[modelHash]
        or Config.SupportedGasPumpModel[GENERIC_FALLBACK_PUMP_HASH]
end

function IsModelAllowedDispenser(model)
    return Config.SupportedGasPumpModel[model] ~= nil or pumpModelAliases[model] ~= nil
end

function GetAllWorkingDispenserModels()
    return allowedModels
end


-- Resolve a pump by its configured world position rather than trusting one
-- exact model hash. This is important for map replacements: target systems can
-- see the real prop, while the station config may still contain the vanilla or
-- rcore replacement hash. The closest supported model to the configured pump
-- position wins, so adjacent dispensers cannot be selected just because their
-- model happens to match first.
function FindSupportedDispenserEntity(position, preferredModelHash, radius)
    radius = tonumber(radius) or 3.0
    if not position then
        return 0
    end

    local closestEntity = 0
    local closestDistance = radius + 0.001

    local function considerModel(modelHash)
        if not modelHash then return end

        local entity = GetClosestObjectOfType(position, radius, modelHash, false, false, false)
        if entity ~= 0 and DoesEntityExist(entity) then
            local distance = #(GetEntityCoords(entity) - position)
            if distance < closestDistance then
                closestDistance = distance
                closestEntity = entity
            end
        end
    end

    -- Keep the configured model as the fast/common path.
    considerModel(preferredModelHash)

    -- Then tolerate native/replacement/custom supported pump models at the same
    -- dispenser coordinates.
    for modelHash in pairs(allowedModels) do
        if modelHash ~= preferredModelHash then
            considerModel(modelHash)
        end
    end

    return closestEntity
end

function GetDispenserGunModel(model)
    return GetSupportedPumpModelData(model).nozzleHand
end

function CreateFuelRopeForPump(obj, side)
    if not obj or obj == 0 or not DoesEntityExist(obj) or not side then
        return
    end

    local model = GetEntityModel(obj)
    if not model or model == 0 then
        return
    end

    local modelData = GetSupportedPumpModelData(model)
    local dData = modelData.dispenserGunObjectsPosition[side]
    if not dData then
        return
    end

    local offsetRope = dData.offsetRope
    local ropePos = GetOffsetFromEntityInWorldCoords(obj, offsetRope)

    local ropeObject = CreateLocalObject(modelData.nozzleWithTube, ropePos)

    SetEntityCollision(ropeObject, false, true)
    SetEntityHeading(ropeObject, GetEntityHeading(obj) - dData.heading)
    return ropeObject
end

function CreateFuelHolderForPump(obj, side)
    if not obj or obj == 0 or not DoesEntityExist(obj) or not side then
        return
    end

    local model = GetEntityModel(obj)
    if not model or model == 0 then
        return
    end

    if type(side) ~= "number" then
        print("side: ", side, type(side), "is not a number!")
        return
    end

    local modelData = GetSupportedPumpModelData(model)
    local dData = modelData.dispenserGunObjectsPosition[side]
    if not dData then
        return
    end

    local offsetHolder = dData.offsetHolder
    local holderPos = GetOffsetFromEntityInWorldCoords(obj, offsetHolder)

    local holderObject = CreateLocalObject(modelData.nozzleHolster, holderPos)

    SetEntityCollision(holderObject, false, true)
    SetEntityHeading(holderObject, GetEntityHeading(obj) - dData.heading)

    return holderObject
end

function GetOffsetCoordsForRopeFuelDispenser(obj, side)
    if not obj or obj == 0 or not DoesEntityExist(obj) then return nil end

    local pedPos = GetEntityCoords(PlayerPedId())
    local modelHash = GetEntityModel(obj)
    local modelData = GetSupportedPumpModelData(modelHash)
    if not modelData then return nil end
    if side then
        return modelData.ropeOffsetPosition and modelData.ropeOffsetPosition[side]
    end

    local offsetOne = modelData.positionOffsetCheckForSides and modelData.positionOffsetCheckForSides[1]
    local offsetTwo = modelData.positionOffsetCheckForSides and modelData.positionOffsetCheckForSides[2]
    local distance1 = offsetOne and #(GetOffsetFromEntityInWorldCoords(obj, offsetOne) - pedPos) or math.huge
    local distance2 = offsetTwo and #(GetOffsetFromEntityInWorldCoords(obj, offsetTwo) - pedPos) or math.huge

    if distance1 == math.huge and distance2 == math.huge then return nil end
    if distance1 <= distance2 then
        return modelData.ropeOffsetPosition and modelData.ropeOffsetPosition[1]
    end
    return modelData.ropeOffsetPosition and modelData.ropeOffsetPosition[2]
end

function GetOffsetsForUIFlipForDispenserPump(obj)
    local modelHash = GetEntityModel(obj)
    local modelData = GetSupportedPumpModelData(modelHash)

    if not modelData.positionOffsetCheckForCameraSide then
        return vector3(-1.25, -1.0, 0.0), vector3(-1.25, 1.0, 0.0)
    end

    return (modelData.positionOffsetCheckForCameraSide[1] or vector3(-1.25, -1.0, 0.0)), (modelData.positionOffsetCheckForCameraSide[2] or vector3(-1.25, 1.0, 0.0))
end

function GetWalkOffsetForPump(obj, side)
    if not obj or obj == 0 or not DoesEntityExist(obj) then return nil, nil end

    local pedPos = GetEntityCoords(PlayerPedId())
    local modelHash = GetEntityModel(obj)
    local modelData = GetSupportedPumpModelData(modelHash)
    if not modelData or not modelData.playerWalkingOffsetPosition then return nil, nil end

    local sideOffsets = modelData.positionOffsetCheckForSides or {}
    local offsetOne, offsetTwo = sideOffsets[1], sideOffsets[2]
    local distance1 = offsetOne and #(GetOffsetFromEntityInWorldCoords(obj, offsetOne) - pedPos) or math.huge
    local distance2 = offsetTwo and #(GetOffsetFromEntityInWorldCoords(obj, offsetTwo) - pedPos) or math.huge

    if side then
        local walkOffset = modelData.playerWalkingOffsetPosition[side]
        if not walkOffset then return nil, nil end
        return GetOffsetFromEntityInWorldCoords(obj, walkOffset), side
    end

    local resolvedSide = distance1 <= distance2 and 1 or 2
    local walkOffset = modelData.playerWalkingOffsetPosition[resolvedSide]
    if not walkOffset then return nil, nil end
    return GetOffsetFromEntityInWorldCoords(obj, walkOffset), resolvedSide
end

function GetHeadingOffetForPump(obj, side)
    if not obj or obj == 0 or not DoesEntityExist(obj) then return nil end

    local pedPos = GetEntityCoords(PlayerPedId())
    local modelHash = GetEntityModel(obj)
    local modelData = GetSupportedPumpModelData(modelHash)
    if not modelData or not modelData.playerHeadingTowardGasPump then return nil end

    if side then
        return modelData.playerHeadingTowardGasPump[side]
    end

    local sideOffsets = modelData.positionOffsetCheckForSides or {}
    local offsetOne, offsetTwo = sideOffsets[1], sideOffsets[2]
    local distance1 = offsetOne and #(GetOffsetFromEntityInWorldCoords(obj, offsetOne) - pedPos) or math.huge
    local distance2 = offsetTwo and #(GetOffsetFromEntityInWorldCoords(obj, offsetTwo) - pedPos) or math.huge

    if distance1 == math.huge and distance2 == math.huge then return nil end
    local resolvedSide = distance1 <= distance2 and 1 or 2
    return modelData.playerHeadingTowardGasPump[resolvedSide]
end
