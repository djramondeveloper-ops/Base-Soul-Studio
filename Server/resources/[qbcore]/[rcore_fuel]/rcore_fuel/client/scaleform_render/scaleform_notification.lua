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

function RequestScaleformMovieAndWait(scaleformName)
  local scaleformId = RequestScaleformMovie(scaleformName)

  while not HasScaleformMovieLoaded(scaleformId) do
    Wait(0)
  end

  return scaleformId
end

function ShowFullscreenBonusNotifyPlaySoundThread()
  Wait(500)
  PlaySoundFrontend(-1, "MEDAL_UP", "HUD_MINI_GAME_SOUNDSET", 1)
  StartScreenEffect("HeistCelebToast")
end

function ShowFullscreenBonusNotifyThread(title, subtitle, description, backgroundColour)
  local celebrationScaleform = RequestScaleformMovieAndWait("HEIST_CELEBRATION")
  local backgroundScaleform = RequestScaleformMovieAndWait("HEIST_CELEBRATION_BG")
  local foregroundScaleform = RequestScaleformMovieAndWait("HEIST_CELEBRATION_FG")
  local scaleformLayers = { celebrationScaleform, backgroundScaleform, foregroundScaleform }

  if not backgroundColour then
    backgroundColour = "HUD_COLOUR_PAUSE_BG"
  end

  for _, scaleformId in pairs(scaleformLayers) do
    CallScaleformFunction(scaleformId, false, "SET_PAUSE_DURATION", 5000.0)
    CallScaleformFunction(scaleformId, false, "CREATE_STAT_WALL", 1, backgroundColour, 1)
    CallScaleformFunction(scaleformId, false, "ADD_BACKGROUND_TO_WALL", 1, 50, 1)
    CallScaleformFunction(scaleformId, false, "ADD_MISSION_RESULT_TO_WALL", 1, title, subtitle, description, true, true, true)
    CallScaleformFunction(scaleformId, false, "SHOW_STAT_WALL", 1)
    CallScaleformFunction(scaleformId, false, "createSequence", 1, 1, 1)
    CallScaleformFunction(scaleformId, false, "PAUSE", 1)
  end

  local endTime = GetGameTimer() + 3000
  CreateThread(ShowFullscreenBonusNotifyPlaySoundThread, "playsound notif 30")

  while GetGameTimer() < endTime do
    Citizen.Wait(1)
    DrawScaleformMovieFullscreenMasked(backgroundScaleform, foregroundScaleform, 255, 255, 255, 50)
    DrawScaleformMovieFullscreen(celebrationScaleform, 255, 255, 255, 255)
  end
end

function ShowFullscreenBonusNotify(title, subtitle, description, backgroundColour)
  CreateThread(function()
    ShowFullscreenBonusNotifyThread(title, subtitle, description, backgroundColour)
  end, "ShowFullscreenBonusNotify")
end

function CallScaleformFunction(scaleformId, returnValue, methodName, ...)
  local params = { ... }

  BeginScaleformMovieMethod(scaleformId, methodName)

  for i = 1, #params do
    local paramType = type(params[i])

    if paramType == "boolean" then
      ScaleformMovieMethodAddParamBool(params[i])
    elseif paramType == "number" then
      -- FIX 1: string.find requires a string; params[i] is a number here.
      -- Use math.type() to distinguish integers from floats correctly.
      if math.type(params[i]) == "integer" or math.floor(params[i]) == params[i] then
        ScaleformMovieMethodAddParamInt(math.floor(params[i]))
      else
        ScaleformMovieMethodAddParamFloat(params[i])
      end
    elseif paramType == "string" then
      _ENV["ScaleformMovieMethodAddParamTextureNameString"](params[i])
    end
  end

  if not returnValue then
    EndScaleformMovieMethod()
  else
    return EndScaleformMovieMethodReturnValue()
  end
end
