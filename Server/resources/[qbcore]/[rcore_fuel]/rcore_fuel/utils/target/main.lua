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

local targetIdCounter = 1
local registeredTargetModels = {}
local oxTargetZoneIds = {}
local activeTargetIds = {}

function GenerateTargetId()
    targetIdCounter = targetIdCounter + 1
    return targetIdCounter .. "_rcore_fuel"
end

function GetTargetInteractionDistance(options, fallbackDistance)
    if options[1] and options[1].distance then
        return options[1].distance
    end

    if options.distance then
        return options.distance
    end

    return fallbackDistance or 2.0
end

function BuildIsInteractionOptions(targetOptions)
    local interactionOptions = {}

    for _, option in pairs(targetOptions) do
        table.insert(interactionOptions, {
            name = "option_" .. option.num,
            label = option.label,
            icon = option.icon,
            key = "",
            duration = 500,
            onSelect = function()
                if option.type == "client" then
                    TriggerEvent(option.event)
                end

                if option.type == "server" then
                    TriggerServerEvent(option.event)
                end
            end,
        })
    end

    return interactionOptions
end

function NormalizeOxTargetOptions(targetOptions)
    local normalized = {}

    for i, option in pairs(targetOptions) do
        local entry = {
            name = option.name or ("option_" .. (option.num or i)),
            label = option.label,
            icon = option.icon,
            distance = option.distance or 2.5,
            canInteract = option.canInteract,
        }

        if option.onSelect then
            entry.onSelect = option.onSelect
        elseif option.type == "server" then
            entry.serverEvent = option.event
        elseif option.type == "client" or option.event then
            entry.event = option.event
        end

        table.insert(normalized, entry)
    end

    return normalized
end

function CreateTargetModel(model, options)
    local modelHash = tonumber(model)
    if not modelHash then
        modelHash = GetHashKey(model)
        model = modelHash
    end

    local targetResource = TargetTypeResourceName[Config.TargetZoneType]
    local targetId = GenerateTargetId()
    activeTargetIds[targetId] = true

    local legacyTargetTypes = {
        [TargetType.Q_TARGET] = true,
        [TargetType.BT_TARGET] = true,
        [TargetType.QB_TARGET] = true,
    }

    registeredTargetModels[model] = true

    if Config.TargetZoneType == TargetType.SLEEPLESS then
        exports.sleepless_interact:addGlobalModel({
            id = targetId,
            models = {
                {
                    model = model,
                    offset = vec3(0, 0, 1.0),
                },
            },
            options = options,
            renderDistance = 10.0,
            activeDistance = GetTargetInteractionDistance(options, 2.0),
            cooldown = 1500,
        })
    elseif Config.TargetZoneType == TargetType.IS_INTERACTION then
        exports.is_interaction:addInteractionModel(
            targetId,
            model,
            {
                hideSquare = false,
                checkVisibility = true,
                showInVehicle = false,
                distance = GetTargetInteractionDistance(options, 2.0),
                distanceText = GetTargetInteractionDistance(options, 2.0),
                offset = {
                    text = { x = 0.0, y = 0.0, z = 1.0 },
                    target = { x = 0.0, y = 0.0, z = 0.0 },
                },
                bone = nil,
                options = BuildIsInteractionOptions(options),
            }
        )
    elseif Config.TargetZoneType == TargetType.OX_TARGET then
        exports.ox_target:addModel(model, NormalizeOxTargetOptions(options))
    elseif legacyTargetTypes[Config.TargetZoneType] then
        exports[targetResource]:AddTargetModel(model, {
            name = targetId,
            options = options,
            distance = GetTargetInteractionDistance(options, 2),
        })
    end
end

function CreateTargetZone(coords, length, width, heading, options)
    local targetResource = TargetTypeResourceName[Config.TargetZoneType]
    local targetId = GenerateTargetId()
    activeTargetIds[targetId] = true

    local legacyTargetTypes = {
        [TargetType.Q_TARGET] = true,
        [TargetType.BT_TARGET] = true,
        [TargetType.QB_TARGET] = true,
    }

    if Config.TargetZoneType == TargetType.SLEEPLESS then
        exports.sleepless_interact:addCoords({
            id = targetId,
            coords = coords,
            onEnter = function() end,
            onExit = function() end,
            nearby = function() end,
            options = options,
            renderDistance = 10.0,
            activeDistance = GetTargetInteractionDistance(options, 2),
            cooldown = 1500,
        })
    elseif Config.TargetZoneType == TargetType.IS_INTERACTION then
        exports.is_interaction:addInteractionCoords(
            targetId,
            coords,
            {
                hideSquare = false,
                checkVisibility = true,
                showInVehicle = false,
                distance = GetTargetInteractionDistance(options, 2),
                distanceText = GetTargetInteractionDistance(options, 2) + 2,
                offset = {
                    text = { x = 0.0, y = 0.0, z = 1.0 },
                    target = { x = 0.0, y = 0.0, z = 0.0 },
                },
                options = BuildIsInteractionOptions(options),
            }
        )
    elseif Config.TargetZoneType == TargetType.OX_TARGET then
        coords = vector3(coords.x, coords.y, coords.z - 0.5)

        local zoneId = exports.ox_target:addBoxZone({
            name = targetId,
            coords = coords,
            size = vector3(width, length, 3.0),
            rotation = heading,
            debug = Config.Debug,
            minZ = coords.z - length,
            maxZ = coords.z + length,
            options = NormalizeOxTargetOptions(options),
            distance = 5.0,
        })

        oxTargetZoneIds[zoneId] = true
    elseif legacyTargetTypes[Config.TargetZoneType] then
        exports[targetResource]:AddBoxZone(targetId, coords, length, width, {
            name = targetId,
            heading = heading,
            minZ = coords.z - length,
            maxZ = coords.z + length,
        }, {
            options = options,
            distance = GetTargetInteractionDistance(options, 2.0),
            heading = heading,
        })
    end
end

function RemoveAllTargetZones()
    local targetResource = TargetTypeResourceName[Config.TargetZoneType]
    local legacyTargetTypes = {
        [TargetType.Q_TARGET] = true,
        [TargetType.BT_TARGET] = true,
        [TargetType.QB_TARGET] = true,
    }

    if Config.TargetZoneType == TargetType.SLEEPLESS then
        for targetId in pairs(activeTargetIds) do
            exports.sleepless_interact:removeById(targetId)
        end
    elseif Config.TargetZoneType == TargetType.IS_INTERACTION then
        exports.is_interaction:removeResource()
    elseif Config.TargetZoneType == TargetType.OX_TARGET then
        for model in pairs(registeredTargetModels) do
            exports.ox_target:removeModel(model)
        end

        for zoneId in pairs(oxTargetZoneIds) do
            exports.ox_target:removeZone(zoneId)
        end
    elseif legacyTargetTypes[Config.TargetZoneType] then
        for targetId in pairs(activeTargetIds) do
            exports[targetResource]:RemoveZone(targetId)
        end

        if Config.TargetZoneType ~= TargetType.BT_TARGET then
            for model in pairs(registeredTargetModels) do
                exports[targetResource]:RemoveTargetModel(model)
            end
        end
    end

    registeredTargetModels = {}
    oxTargetZoneIds = {}
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        RemoveAllTargetZones()
    end
end)
