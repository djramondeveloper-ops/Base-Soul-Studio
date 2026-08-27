-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-target.lua
--  Engineered by Eazy Fxap
--  Original: 283 lines → Cleaned: 90 lines
-- =====================================================

local TargetCount = 1
local TargetModels = {}
local TargetZones = {}

local function GetNextTargetName()
    TargetCount = TargetCount + 1
    return "rcore_police_target_" .. TargetCount
end

TargetType = {
    NO_TARGET = 0,
    Q_TARGET = 1,
    BT_TARGET = 2,
    QB_TARGET = 3,
    OX_TARGET = 4
}

TargetTypeResourceName = {
    [TargetType.NO_TARGET] = "none",
    [TargetType.Q_TARGET] = "qtarget",
    [TargetType.BT_TARGET] = "bt-target",
    [TargetType.QB_TARGET] = "qb-target",
    [TargetType.OX_TARGET] = "ox_target"
}

function CreateTargetZone(coords, width, length, heading, options)
    local targetName = GetNextTargetName()
    
    if Config.InteractionsTarget == InteractionsTarget.OX or isResourcePresentProvideless("crm-target") then
        local adjustedCoords = vector3(coords.x, coords.y, coords.z - 0.5)
        local id = exports.ox_target:addBoxZone({
            name = targetName,
            coords = adjustedCoords,
            size = vector3(length, width, 2.0),
            rotation = heading,
            debug = false,
            minZ = adjustedCoords.z - width,
            maxZ = adjustedCoords.z + width,
            options = options,
            distance = 5.0
        })
        TargetZones[id] = true
    elseif Config.InteractionsTarget == InteractionsTarget.QB then
        local opts = {
            options = options,
            distance = options.distance or 5.0,
            heading = heading
        }
        exports[InteractionsTarget.QB]:AddBoxZone(targetName, coords, width, length, {
            name = targetName,
            heading = heading,
            debugPoly = false,
            minZ = coords.z - width,
            maxZ = coords.z + width
        }, opts)
    end
end

function CreateTargetModel(model, options)
    local hash = tonumber(model)
    if not hash then hash = GetHashKey(model) end
    
    TargetModels[hash] = true
    
    if Config.InteractionsTarget == InteractionsTarget.OX or isResourcePresentProvideless("crm-target") then
        exports.ox_target:addModel(hash, options)
    elseif Config.InteractionsTarget == InteractionsTarget.QB then
        local opts = {
            options = options,
            distance = options.distance or 5.0
        }
        exports[InteractionsTarget.QB]:AddTargetModel(hash, opts)
    end
end

function RemoveAllTargetZones()
    if Config.InteractionsTarget == InteractionsTarget.OX or isResourcePresentProvideless("crm-target") then
        for model, _ in pairs(TargetModels) do
            exports.ox_target:removeModel(model)
        end
        for id, _ in pairs(TargetZones) do
            exports.ox_target:removeZone(id)
        end
    elseif Config.InteractionsTarget == InteractionsTarget.QB then
        for i = 1, TargetCount do
            exports[InteractionsTarget.QB]:RemoveZone("rcore_police_target_" .. i)
        end
        if Config.TargetZoneType ~= InteractionsTarget.NONE then
            for model, _ in pairs(TargetModels) do
                exports[InteractionsTarget.QB]:RemoveTargetModel(model)
            end
        end
    end
    
    TargetModels = {}
    TargetZones = {}
end
