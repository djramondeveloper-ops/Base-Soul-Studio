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

local shouldRenderScaleforms = false
GlobalScaleformID = -1
ScaleformCache = {}
skipRender = false
ClosestScaleformData = nil

local scaleformOccupancyList = Config.ScaleFormLists
local sharedDuiPool = {}
local pendingScaleformState = {}

function GetUnoccupiedScaleform()
  local hasUnoccupied = false
  local scaleformName = "none"

  for name, isOccupied in pairs(scaleformOccupancyList) do
    if isOccupied == false then
      scaleformName = name
      hasUnoccupied = true
      break
    end
  end

  return hasUnoccupied, scaleformName
end

function SetScaleformOccupied(scaleformName)
  if scaleformOccupancyList[scaleformName] ~= nil then
    scaleformOccupancyList[scaleformName] = true
  end
end

function UnreleaseOccupiedScaleform(scaleformName)
  if scaleformOccupancyList[scaleformName] ~= nil then
    scaleformOccupancyList[scaleformName] = false
  end
end

function DestroyTV(scaleformData)
  scaleformData.destroying = true
  scaleformData.waitDuiMessage = true
  scaleformData.scaleformLoaded = false
  scaleformData.duiLoaded = false
  scaleformData.Rendering = false
  Debug("DestroyDui | render_scaleform.lua | 155")
  SetDUILink(scaleformData.duiObj, "nui://rcore_fuel/empty.html")
  UnreleaseOccupiedScaleform(scaleformData.scaleformName)

  if GlobalScaleformID ~= scaleformData.scaleformId then
    SetScaleformMovieAsNoLongerNeeded(scaleformData.scaleformId)
  end

  scaleformData.notHiding = nil
  scaleformData.scaleformName = nil
  scaleformData.scaleformId = nil
  scaleformData.waitDuiMessage = nil
  scaleformData.notShowing = nil
  scaleformData.flipScreen = nil
  scaleformData.destroying = nil
end

function DestroyDuiAndScaleform()
  for cacheKey, scaleformData in pairs(ScaleformCache) do
    if scaleformData.scaleformLoaded and scaleformData.duiLoaded then
      RemoveScaleformPumpDataByIdentifier(cacheKey)
    end
  end
end

function RemoveScaleformPumpDataByIdentifier(shopIdentifier)
  if IsPlayerReadyToPump then
    return
  end

  for shopId, shopData in pairs(Config.ShopList) do
    for pumpIndex, pumpData in pairs(shopData.pumpPosition) do
      if shopId == shopIdentifier and pumpData.entity then
        local cacheKey = "pump_" .. shopId .. "_" .. pumpIndex
        local scaleformData = ScaleformCache[cacheKey]

        if scaleformData and scaleformData.duiObj and scaleformData.duiLoaded and scaleformData.skipDestroy == nil then
          DestroyTV(scaleformData)
          ScaleformCache[cacheKey] = nil
          pumpData.entity = nil
        end
      end
    end
  end
end

function showSubtitle(text)
  BeginTextCommandPrint("STRING")
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandPrint(3000, 1)
end

function SendDUIDataByIdentifier(identifier, message)
  if identifier then
    local scaleformData = ScaleformCache[identifier]
    if not scaleformData then
      pendingScaleformState[identifier] = pendingScaleformState[identifier] or {}
      scaleformData = pendingScaleformState[identifier]
    end
    -- The browser may still be loading when fueling starts. Keep the latest
    -- values and restore them after its ready callback instead of losing ticks.
    scaleformData.duiState = scaleformData.duiState or {}
    if message.type == "showFueling" or message.type == "hideFueling" then
      scaleformData.duiState.fuelingVisibility = message
    elseif message.type == "activeFuel" or message.type == "lerpAmount" or message.type == "update_cost" then
      scaleformData.duiState[message.type] = message
    end
    if scaleformData.duiObj and scaleformData.duiLoaded then
      DuiMessage(scaleformData.duiObj, message)
    end
  end
end

function GetAdditionalDataForScaleform(identifier)
  if not identifier or not ScaleformCache[identifier] then
    return {}
  end
  local scaleformData = deepCopy(ScaleformCache[identifier])
  scaleformData.URL = nil
  scaleformData.scaleformPos = nil
  scaleformData.entityPos = nil
  scaleformData.tvSize = nil
  scaleformData.rot = nil
  scaleformData.distance = nil
  scaleformData.scaleformLoaded = nil
  scaleformData.scaleformName = nil
  scaleformData.scaleformId = nil
  scaleformData.entityHit = nil
  scaleformData.hash = nil
  return scaleformData
end

function SetAdditionalDataForScaleform(identifier, fieldName, fieldValue)
  if not identifier then return end
  local data = ScaleformCache[identifier]
  if not data then
    pendingScaleformState[identifier] = pendingScaleformState[identifier] or {}
    data = pendingScaleformState[identifier]
  end
  data[fieldName] = fieldValue
end

function CreateVirtualScaleform(identifier, pumpData, extraFields, entityPosition)
  local scaleformPos, tvSize, rotation, distance = GetScaleformMetaData(pumpData.ModelHash, pumpData.entity, pumpData.align)

  ScaleformCache[identifier] = {
    URL = pumpData.URL,
    entityPos = entityPosition,
    scaleformPos = scaleformPos,
    tvSize = tvSize,
    rot = rotation,
    distance = distance,
    scaleformLoaded = false,
    scaleformName = "shop_scaleform_1",
    scaleformId = nil,
    entityHit = pumpData.entity,
    hash = pumpData.ModelHash,
  }

  local additionalFields = extraFields or {}

  for fieldName, fieldValue in pairs(additionalFields) do
    ScaleformCache[identifier][fieldName] = fieldValue
  end
  if additionalFields.FuelPump then
    ScaleformCache[identifier].distance = Config.PumpDisplayDistance or 15
  end
  for fieldName, fieldValue in pairs(pendingScaleformState[identifier] or {}) do
    ScaleformCache[identifier][fieldName] = fieldValue
  end
  pendingScaleformState[identifier] = nil
end

function ScaleformRenderLoadClosestScaleform(closestScaleform, scaleformName)
  ClosestScaleformData = DeepCopy(closestScaleform)
  closestScaleform.scaleformName = scaleformName
  SetScaleformOccupied(scaleformName)
  closestScaleform.scaleformLoaded = true
  closestScaleform.flipScreen = 3
  closestScaleform.scaleformId = RequestScaleformMovie(closestScaleform.scaleformName)

  if closestScaleform.scaleformId == 0 then
    print("The scaleform ID is 0! Some other resource from your server is using too much \203\153RequestScaleformMovie\203\153 and doesnt release them!")

    if Config.UsePreloaded then
      print("Using preloaded scaleform the preloaded scaleform ID is: " .. GlobalScaleformID)
      closestScaleform.scaleformId = GlobalScaleformID
    end
  end

  Debug("trying to load: ", closestScaleform.scaleformName)

  while not HasScaleformMovieLoaded(closestScaleform.scaleformId) do
    Wait(0)
  end

  Debug("Loaded scaleform: ", closestScaleform.scaleformName)
  Debug("Scaleform ID: ", closestScaleform.scaleformId)

  closestScaleform.identifierNumber = math.random(9999999999)
  closestScaleform.URL = closestScaleform.URL:gsub(" ", "")
  -- Fuel pages report readiness themselves; avoid loading an intermediate page
  -- and making an extra browser -> game -> browser navigation round trip.
  local loadingDuiLink = closestScaleform.URL .. "?identifier=" .. closestScaleform.identifierNumber
  local runtimeTxdName = "video" .. scaleformName
  local runtimeTextureName = "test" .. scaleformName

  if not sharedDuiPool[scaleformName] then
    closestScaleform.duiObj = CreateDui(loadingDuiLink, 1920, 1300)
    closestScaleform.txd = CreateRuntimeTxd(runtimeTxdName)
    closestScaleform.dui = GetDuiHandle(closestScaleform.duiObj)
    CreateRuntimeTextureFromDuiHandle(closestScaleform.txd, runtimeTextureName, closestScaleform.dui)
    sharedDuiPool[scaleformName] = {
      duiObj = closestScaleform.duiObj,
      txd = closestScaleform.txd,
      dui = closestScaleform.dui,
      pos = closestScaleform.scaleformPos,
    }
  else
    local pooledDui = sharedDuiPool[scaleformName]
    closestScaleform.duiObj = pooledDui.duiObj
    closestScaleform.txd = pooledDui.txd
    closestScaleform.dui = pooledDui.dui
    SetDUILink(closestScaleform.duiObj, loadingDuiLink)
    DuiMessage(closestScaleform.duiObj, { type = "hideAll" })
  end

  Debug("IsDuiAvailable, 108")

  while not IsDuiAvailable(closestScaleform.duiObj) do
    Wait(0)
  end

  BeginScaleformMovieMethod(closestScaleform.scaleformId, "SET_TEXTURE")
  PushScaleformMovieFunction(closestScaleform.scaleformId, "SET_TEXTURE")
  PushScaleformMovieMethodParameterString(runtimeTxdName)
  PushScaleformMovieMethodParameterString(runtimeTextureName)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(0)
  PushScaleformMovieFunctionParameterInt(1920)
  PushScaleformMovieFunctionParameterInt(1080)
  PopScaleformMovieFunctionVoid()
  closestScaleform.Rendering = true
end

function ScaleformRenderUpdateProximity()
  local coords = GetEntityCoords(PlayerPedId())
  local selected, closestDistance, current, currentDistance = nil, math.huge, nil, math.huge
  local activeId = nil
  if IsPlayerReadyToPump and GetCurrentPumpIdentifier and GetCurrentDispenserIdentifier then
    local shopId, dispenserId = GetCurrentPumpIdentifier(), GetCurrentDispenserIdentifier()
    if shopId and dispenserId then activeId = "pump_" .. shopId .. "_" .. dispenserId end
  end

  for identifier, data in pairs(ScaleformCache) do
    local distance = #(data.entityPos - coords)
    local range = data.distance
    if data.FuelPump and identifier ~= activeId then
      range = math.min(range, Config.PumpDisplayDistance or 15)
    end
    if not skipRender and distance < range then
      if distance < closestDistance then selected, closestDistance = data, distance end
      if data.scaleformLoaded then current, currentDistance = data, distance end
    end
  end
  -- Keep the held nozzle's screen loaded, even if another pump is nearer.
  -- Without a held nozzle, avoid reloading browsers for tiny distance changes.
  if not skipRender and activeId and ScaleformCache[activeId] then
    selected = ScaleformCache[activeId]
  elseif current and currentDistance <= closestDistance + 1.0 then
    selected = current
  end

  shouldRenderScaleforms = selected ~= nil
  for _, data in pairs(ScaleformCache) do
    if data ~= selected and data.scaleformLoaded then DestroyTV(data) end
  end
  if selected then
    if not selected.scaleformLoaded then
      local available, name = GetUnoccupiedScaleform()
      if available then ScaleformRenderLoadClosestScaleform(selected, name) end
    end
    ClosestScaleformData = DeepCopy(selected)
  else
    ClosestScaleformData = nil
  end
end

function ScaleformRenderProximityThread()
  while true do
    ScaleformRenderUpdateProximity()
    Wait(100)
  end
end

function ScaleformRenderUpdateFlipScreen(scaleformData, cameraCoords)
  local distanceToSquareOne = #(scaleformData.FuelPumpSquares[1][1] - cameraCoords)
  local distanceToSquareTwo = #(scaleformData.FuelPumpSquares[2][1] - cameraCoords)

  if distanceToSquareOne <= distanceToSquareTwo then
    if scaleformData.flipScreen then
      scaleformData.flipScreen = false
      DuiMessage(scaleformData.duiObj, {
        type = "flipScreen",
        status = true,
      })
    end
  elseif distanceToSquareOne > distanceToSquareTwo then
    if not scaleformData.flipScreen then
      scaleformData.flipScreen = true
      DuiMessage(scaleformData.duiObj, {
        type = "flipScreen",
        status = false,
      })
    end
  end
end

function ScaleformRenderUpdateFadeVisibility(scaleformData)
  local distanceFromPump = #((scaleformData.entityPos or scaleformData.scaleformPos) - GetEntityCoords(PlayerPedId()))
  local visible = scaleformData.ignoreFade or distanceFromPump < scaleformData.distance
  if not visible then
    if not scaleformData.notHiding then
      scaleformData.notHiding = true
      scaleformData.notShowing = nil
      DuiMessage(scaleformData.duiObj, { type = "hide" })
    end
  else
    if not scaleformData.notShowing then
      scaleformData.notShowing = true
      scaleformData.notHiding = nil
      DuiMessage(scaleformData.duiObj, { type = "show" })
    end
  end
end

function ScaleformRenderDrawScaleform(scaleformData, rotationZ, scaleformPos, tvSize)
  if Config.ScaleformEditor then
    local editorPosition = GetOffsetFromEntityInWorldCoords(scaleformData.entityHit, xPosEdit, yPosEdit, zPosEdit)
    local _, editorTvSize = GetScaleformMetaData(scaleformData.hash, scaleformData.entityHit, "R")
    editorTvSize = editorTvSize - vector3(xScale, yScale, zScale)
    DrawScaleformMovie_3dNonAdditive(
      scaleformData.scaleformId,
      editorPosition.x, editorPosition.y, editorPosition.z,
      0, 0, rotationZ,
      2.0, 2.0, 2.0,
      editorTvSize.x, editorTvSize.y, editorTvSize.z
    )
  else
    DrawScaleformMovie_3dNonAdditive(
      scaleformData.scaleformId,
      scaleformPos.x, scaleformPos.y, scaleformPos.z,
      0, 0, rotationZ,
      2.0, 2.0, 2.0,
      tvSize.x, tvSize.y, tvSize.z
    )
  end
end

function ScaleformRenderDrawThread()
  while true do
    if not shouldRenderScaleforms then
      Wait(50)
    else
      Wait(0)

      for _, scaleformData in pairs(ScaleformCache) do
      if scaleformData.destroying then
        goto nextScaleform
      end

      if not scaleformData.scaleformId or not HasScaleformMovieLoaded(scaleformData.scaleformId) then
        goto nextScaleform
      end

      if Config.PopScaleform then
        BeginScaleformMovieMethod(scaleformData.scaleformId, "SET_TEXTURE")
        PushScaleformMovieMethodParameterString("video" .. scaleformData.scaleformId)
        PushScaleformMovieMethodParameterString("test" .. scaleformData.scaleformId)
        PopScaleformMovieFunctionVoid()
      end

      local rotationZ = scaleformData.rot.z * -1
      local scaleformPos = scaleformData.scaleformPos
      local tvSize = scaleformData.tvSize

      if scaleformData.duiLoaded then
        if Config.Debug then
          draw3DText(scaleformPos + vector3(0, 0, 0), "Rendering DUI")
        end

        ScaleformRenderDrawScaleform(scaleformData, rotationZ, scaleformPos, tvSize)

        if scaleformData.FuelPump then
          ScaleformRenderUpdateFlipScreen(scaleformData, GetGameplayCamCoord())
        end

        -- ignoreFade must actively show a browser hidden before nozzle pickup.
        ScaleformRenderUpdateFadeVisibility(scaleformData)
      end

      ::nextScaleform::
    end
    end

    ::continue::
  end
end

function ScaleformRenderDebugMarkerThread()
  while true do
    Wait(1)

    for _, scaleformData in pairs(ScaleformCache) do
      if not scaleformData.destroying and scaleformData.duiLoaded and scaleformData.FuelPump then
        DrawMarker(
          28,
          scaleformData.FuelPumpSquares[1][1],
          0.0, 0.0, 0.0,
          0.0, 0.0, 0.0,
          0.6, 0.6, 0.6,
          255, 0, 0, 150,
          false, false, 0, false
        )
        DrawMarker(
          28,
          scaleformData.FuelPumpSquares[2][1],
          0.0, 0.0, 0.0,
          0.0, 0.0, 0.0,
          0.6, 0.6, 0.6,
          255, 0, 0, 150,
          false, false, 0, false
        )
      end
    end
  end
end

CreateThread(ScaleformRenderProximityThread, "scaleform render thread ")
CreateThread(ScaleformRenderDrawThread, "scaleform renderer 305")

if Config.Debug then
  CreateThread(ScaleformRenderDebugMarkerThread, "Debug marker draw for scaleform locations")
end

