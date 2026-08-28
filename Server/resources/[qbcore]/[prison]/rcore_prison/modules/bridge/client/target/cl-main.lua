local targetCounter = 1
local trackedModels = {}
local trackedZones = {}
local registeredZoneNames = {}
local highlightedEntities = {}

local function generateTargetName(suffix)
  targetCounter = targetCounter + 1

  if suffix then
    return ("rcore_prison_target_%s_%s"):format(targetCounter, suffix)
  end

  return ("rcore_prison_target_%s"):format(targetCounter)
end

local function getInteractionDistance(options)
  if options[1] and options[1].distance then
    return options[1].distance
  end

  return options.distance or 2
end

function RemoveTargetEntityHiglight()
  if not next(highlightedEntities) then
    return
  end

  for name, entity in pairs(highlightedEntities) do
    if DoesEntityExist(entity) then
      SetEntityAsNoLongerNeeded(entity)
      SetEntityDrawOutline(entity, false)
      DeleteEntity(entity)
    end

    highlightedEntities[name] = nil
  end
end

function CreateTargetZone(coords, width, length, heading, options, nameSuffix, spawnInvisibleProp, distance)
  local interactionType = Config.Interactions
  local zoneName = generateTargetName(nameSuffix)

  registeredZoneNames[zoneName] = true

  local boxZoneLibraries = {
    [Interactions.Q] = true,
    [Interactions.QB] = true,
    [Interactions.MV] = true
  }

  if spawnInvisibleProp then
    local spawnedEntity = Entity.SpawnPropAtCoords({
      coords = coords,
      heading = heading,
      model = "prop_rub_cardpile_06",
      invisible = spawnInvisibleProp
    })

    if spawnedEntity and not highlightedEntities[zoneName] then
      highlightedEntities[zoneName] = spawnedEntity
    end
  end

  if interactionType == Interactions.OX then
    local zoneCoords = vector3(coords.x, coords.y, coords.z - 0.5)

    local zoneId = exports.ox_target:addBoxZone({
      name = zoneName,
      coords = zoneCoords,
      size = vector3(length, width, 2.0),
      rotation = heading,
      debug = false,
      minZ = zoneCoords.z - width,
      maxZ = zoneCoords.z + width,
      options = options
    })

    trackedZones[zoneId] = {
      name = zoneName,
      library = interactionType
    }

    return
  end

  if interactionType == Interactions.IS then
    local interactionOptions = {}

    for _, option in pairs(options) do
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
        end
      })
    end

    exports.is_interaction:addInteractionCoords(zoneName, coords, {
      hideSquare = false,
      checkVisibility = true,
      showInVehicle = false,
      distance = getInteractionDistance(options),
      distanceText = getInteractionDistance(options) + 2,
      offset = {
        text = { x = 0.0, y = 0.0, z = 1.0 },
        target = { x = 0.0, y = 0.0, z = 0.0 }
      },
      options = interactionOptions
    })

    return
  end

  if interactionType == Interactions.SLEEPLESS then
    local zoneId = exports.sleepless_interact:addCoords({
      id = zoneName,
      coords = coords,
      onEnter = function()
      end,
      onExit = function()
      end,
      nearby = function()
      end,
      options = options,
      renderDistance = 10.0,
      activeDistance = getInteractionDistance(options),
      cooldown = 1500
    })

    trackedZones[zoneId or zoneName] = {
      name = zoneName,
      library = interactionType
    }

    return
  end

  if boxZoneLibraries[interactionType] then
    local zoneConfig = {
      options = options,
      distance = distance or 5.0,
      heading = heading
    }

    exports[interactionType]:AddBoxZone(
      zoneName,
      coords,
      width,
      length,
      {
        name = zoneName,
        heading = heading,
        debugPoly = false,
        minZ = coords.z - width,
        maxZ = coords.z + width
      },
      zoneConfig
    )
  end
end

function CreateTargetModel(model, options)
  local modelHash = tonumber(model)

  if not modelHash then
    modelHash = GetHashKey(model)
    model = modelHash
  end

  trackedModels[model] = true

  local interactionType = Config.Interactions
  local modelLibraries = {
    [Interactions.Q] = true,
    [Interactions.QB] = true,
    [Interactions.MV] = true
  }

  if interactionType == Interactions.OX then
    exports.ox_target:addModel(model, options)
    return
  end

  if modelLibraries[interactionType] then
    exports[interactionType]:AddTargetModel(model, {
      options = options,
      distance = options.distance or 5.0
    })
  end
end

function RemoveAllTargetZones()
  local interactionType = Config.Interactions
  local boxZoneLibraries = {
    [Interactions.Q] = true,
    [Interactions.QB] = true,
    [Interactions.MV] = true
  }

  if interactionType == Interactions.OX then
    for model in pairs(trackedModels) do
      exports.ox_target:removeModel(model)
    end

    for zoneId in pairs(trackedZones) do
      exports.ox_target:removeZone(zoneId)
    end
  elseif boxZoneLibraries[interactionType] then
    for zoneName in pairs(registeredZoneNames) do
      exports[interactionType]:RemoveZone(zoneName)
    end
  elseif interactionType == Interactions.SLEEPLESS then
    for zoneId in pairs(trackedZones) do
      exports.sleepless_interact:removeById(zoneId)
    end
  elseif interactionType == Interactions.IS then
    exports.is_interaction:removeResource()
  end

  trackedModels = {}
  trackedZones = {}
  registeredZoneNames = {}
end

function RemoveTargetZone(targetName, _)
  local interactionType = Config.Interactions
  local boxZoneLibraries = {
    [Interactions.Q] = true,
    [Interactions.QB] = true
  }

  if not targetName then
    return
  end

  if interactionType == Interactions.OX then
    for model in pairs(trackedModels) do
      exports.ox_target:removeModel(model)
      trackedModels[model] = nil
    end

    for zoneId, zoneData in pairs(trackedZones) do
      local zoneName = zoneData.name

      if zoneName == targetName or string.match(zoneName, targetName) then
        exports.ox_target:removeZone(zoneId)
        trackedZones[zoneId] = nil
        registeredZoneNames[zoneName] = nil
      end
    end

    return
  end

  if boxZoneLibraries[interactionType] then
    for zoneName in pairs(registeredZoneNames) do
      if zoneName == targetName or string.match(zoneName, targetName) then
        exports[interactionType]:RemoveZone(zoneName)
        registeredZoneNames[zoneName] = nil
      end
    end

    return
  end

  if interactionType == Interactions.SLEEPLESS then
    for zoneId, zoneData in pairs(trackedZones) do
      local zoneName = zoneData.name

      if zoneName == targetName or string.match(zoneName, targetName) then
        exports.sleepless_interact:removeById(zoneId)
        trackedZones[zoneId] = nil
        registeredZoneNames[zoneName] = nil
      end
    end

    return
  end

  if interactionType == Interactions.IS then
    exports.is_interaction:removeResource()
  end
end