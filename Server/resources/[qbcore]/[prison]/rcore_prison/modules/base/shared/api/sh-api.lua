local createApiExportsThread
local registerListenerExport
local registerLocalClientEvent
local triggerLocalClientEvent

local function startAlarm()
  return HandleAlarm(true)
end

local function stopAlarm()
  return HandleAlarm(false)
end

local function restorePrisonerOutfit()
  ApplyOutfit(Outfits)
  return true
end

local function callServiceMethod(serviceName, methodName, ...)
  local service = rawget(_G, serviceName)
  local method = service and service[methodName]

  if type(method) ~= "function" then
    return nil
  end

  return method(...)
end

function createApiExportsThread()
  if IsDuplicityVersion() then
    dbg.debug("Server API loaded.")

    exports("Jail", function(...) return callServiceMethod("PrisonService", "Jail", ...) end)
    exports("StartCOMS", function(...) return callServiceMethod("COMSService", "StartPerollForCitizen", ...) end)
    exports("Unjail", function(...) return callServiceMethod("PrisonService", "Unjail", ...) end)
    exports("UnjailOffline", function(...) return callServiceMethod("PrisonService", "UnjailOfflineCitizen", ...) end)
    exports("IsPrisoner", function(...) return callServiceMethod("PrisonService", "CheckForAnySentence", ...) end)
    exports("GetPrisonerData", function(...) return callServiceMethod("PrisonService", "getPlayer", ...) end)
    exports("EditPrisonerSentence", function(...) return callServiceMethod("PrisonService", "EditSentenceBySource", ...) end)
    exports("AddCredits", function(...) return callServiceMethod("PrisonAccountService", "AddCredits", ...) end)
    exports("RemoveCredits", function(...) return callServiceMethod("PrisonAccountService", "RemoveCredits", ...) end)
    exports("SetSolitary", function(...) return callServiceMethod("SolitaryService", "SetPrisonerSentence", ...) end)
    exports("IsPrisonerInSolitary", function(...) return callServiceMethod("SolitaryService", "HasSentence", ...) end)
    exports("ReleaseFromSolitary", function(...) return callServiceMethod("SolitaryService", "ReleasePrisoner", ...) end)
    exports("StartAlarm", startAlarm)
    exports("StopAlarm", stopAlarm)
  else
    exports("JailByIdentifier", JailByIdentifier)
    exports("Jail", JailPlayer)
    exports("IsPrisoner", function(...) return callServiceMethod("PrisonService", "IsPrisoner", ...) end)
    exports("Unjail", UnjailPlayer)
    exports("IsPlayerInCutScene", PrologService.GetPlayerCutSceneState)
    exports("RestorePrisonerOutfit", restorePrisonerOutfit)
  end
end

CreateThread(createApiExportsThread, "sv-api code name: Phoenix")

if not IsDuplicityVersion() then
  local listeners = {}

  function registerListenerExport(eventName, callback)
    if not listeners[eventName] then
      listeners[eventName] = {}
    end

    table.insert(listeners[eventName], callback)
  end

  RegisterListener = registerListenerExport

  local function triggerListeners(eventName, ...)
    local callbacks = listeners[eventName]
    if not callbacks then
      return
    end

    for _, callback in ipairs(callbacks) do
      callback(...)
    end
  end

  TriggerListeners = triggerListeners

  function registerLocalClientEvent(eventName, callback)
    local resourceEventName = ("%s:%s:%s"):format(GetCurrentResourceName(), "client", eventName)

    if resourceEventName then
      AddEventHandler(resourceEventName, function(...)
        callback(...)
      end)
    end
  end

  function triggerLocalClientEvent(eventName, ...)
    local resourceEventName = ("%s:%s:%s"):format(GetCurrentResourceName(), "client", eventName)

    if resourceEventName then
      TriggerEvent(resourceEventName, ...)
    end
  end

  RegisterLocalClientEvent = registerLocalClientEvent
  TriggerLocalClientEvent = triggerLocalClientEvent

  exports("registerListener", RegisterListener)

  RegisterLocalClientEvent("onHud", function(...)
    TriggerListeners("onHud", ...)
  end)
end
