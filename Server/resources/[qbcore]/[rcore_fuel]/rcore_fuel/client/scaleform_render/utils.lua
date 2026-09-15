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

local duiUrlCache = {}

function GetLoadingDUILink(identifier, link)
  return string.format("nui://rcore_fuel/html/loaded.html?identifier=%s&link=%s", identifier, link)
end

function DuiMessageSendHandler(duiObj, message)
  SendDuiMessage(duiObj, json.encode(message))
end

function DuiMessageErrorHandler(err)
end

function DuiMessage(duiObj, message)
  xpcall(DuiMessageSendHandler, DuiMessageErrorHandler, duiObj, message)
end

function SetDUILink(duiObj, url)
  duiUrlCache[duiObj] = url
  SetDuiUrl(duiObj, url)
end

function GetDuiUrl(duiObj)
  local url = duiUrlCache[duiObj]
  if not url then
    url = "nil dui url"
  end
  return url
end

function GetScaleformMetaData(modelHash, entity, align)
  local modelDimensions = GetModelDimensions(modelHash)
  local modelDimensionLength = #modelDimensions
  local entityRotation = GetEntityRotation(entity)

  -- FIX 1: Config.resolution has the same gap as Config.SupportedGasPumpModel
  -- (see dispenserData.lua's FIX 1) for any pump model that isn't registered --
  -- indexing it 5 times below with no nil-check would crash trying to render
  -- the price screen on that pump. Resolve once with the same fallback.
  local resolutionConfig = Config.resolution[modelHash] or Config.resolution[GetHashKey("prop_gas_pump_1a")]

  local screenOffset = resolutionConfig.ScreenOffSet

  if not screenOffset then
    screenOffset = vector3(0, 0, 0)
  elseif type(screenOffset) == "table" then
    screenOffset = screenOffset[align]
  end

  local scaleformPosition = GetOffsetFromEntityInWorldCoords(entity, screenOffset.x, screenOffset.y, screenOffset.z)
  local renderDistance = resolutionConfig.distance

  if not renderDistance then
    renderDistance = 10.0
  end

  local rotationOffset = resolutionConfig.rotationOffset

  if rotationOffset then
    entityRotation = vector3(entityRotation.x, entityRotation.y, entityRotation.z) - rotationOffset
  end

  local screenSize = resolutionConfig.ScreenSize

  if Config.ScaleformEditor then
    screenSize = vector3(0, 0, 0)
  end

  local tvSize = vector3(
    modelDimensionLength / 1.204 * 100 * 5.75E-4,
    modelDimensionLength / 1.204 * 100 * 3.25E-4,
    modelDimensionLength / 1.204 * 100 * 0.001085
  ) - screenSize

  return scaleformPosition, tvSize, entityRotation, renderDistance, resolutionConfig
end
