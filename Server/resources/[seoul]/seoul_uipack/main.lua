local function SeoulConvar(name, default)
  return GetConvar(("seoul:%s"):format(name), GetConvar(("reborn:%s"):format(name), default))
end

local function SeoulConvarInt(name, default)
  local seoulValue = GetConvar(("seoul:%s"):format(name), "")
  if seoulValue ~= "" then
    return GetConvarInt(("seoul:%s"):format(name), default)
  end
  return GetConvarInt(("reborn:%s"):format(name), default)
end

local function SeoulPrimaryColor()
  local theme = GlobalState['SeoulTheme']
  local basics = GlobalState['Basics']
  local fallback = "#F20089"

  if type(theme) == "table" then
    fallback = theme.Primary or theme.CityColorHex or theme.Main or theme.main or fallback
  end

  if type(basics) == "table" then
    fallback = basics.CityColorHex or basics.CityColor or fallback
  end

  return SeoulConvar("primaryColor", fallback)
end

function LoadLocaleFile(locale)
  if not locale then
    locale = "pt"
  end

  local resourceName = GetCurrentResourceName()
  local localeFilePath = string.format("locales/%s.lua", locale)
  local localeContent = LoadResourceFile(resourceName, localeFilePath)

  if localeContent then
    local localeData = load(localeContent)()
    if localeData then
      return localeData
    end
  end

  return {}
end

-- Callback NUI para obter configurações do resource
RegisterNuiCallback("getConfig", function(data, callback)
  local locale = SeoulConvar("locale", "pt")
  local debugMode = SeoulConvarInt("debug", 0) == 1

  local config = {
    primaryColor = SeoulPrimaryColor(),
    notificationDuration = SeoulConvarInt("notificationDuration", 3000),
    progressCancelKey = SeoulConvar("progressCancelKey", "X"),
    notifyPosition = SeoulConvar("notificationPosition", "top-center"),
    textUIPosition = SeoulConvar("textUIPosition", "center-left"),
    progressVariant = SeoulConvar("progressBar", "secondary"),
    debugMode = debugMode,
    locale = locale,
    locales = LoadLocaleFile(locale)
  }

  if debugMode then
    Utils.debugPrint(string.format("Locale: %s", locale))
    Utils.debugPrint("Config Table:")

    for key, value in pairs(config) do
      if type(value) == "table" then
        Utils.debugPrint(key .. ": {")
        for subKey, subValue in pairs(value) do
          Utils.debugPrint("  " .. tostring(subKey) .. " = " .. tostring(subValue))
        end
        Utils.debugPrint("}")
      else
        Utils.debugPrint(tostring(key) .. " = " .. tostring(value))
      end
    end
  end

  callback(config)
end)

-- Exports para notificações
-- O evento global "Notify" fica no resource [scripts]/notify para evitar duplicidade visual.
exports("Notify", Notify)
RegisterNetEvent("seoul:notify", function(...)
  Notify(...)
end)
RegisterNetEvent("reborn:notify", function(...)
  Notify(...)
end) -- compatibilidade temporária

-- Exports para Text UI
exports("ShowTextUI", ShowTextUI)
exports("HideTextUI", HideTextUI)
exports("IsTextUIOpen", IsTextUIOpen)

-- Exports para Progress Bar
exports("ProgressBar", ProgressBar)
exports("ProgressActive", ProgressActive)
exports("CancelProgress", CancelProgress)

local function BuildLegacyProgress(first, second, third)
  if type(first) == "table" then
    return first
  end

  local label
  local duration

  -- Base Seoul/Creative usa Progress("Texto", tempo).
  -- Alguns scripts/compat usam Progress(tempo, "Texto").
  if type(first) == "number" then
    duration = first
    label = second
  else
    label = first
    duration = second
  end

  return {
    label = tostring(label or "Aguarde"),
    duration = tonumber(duration) or 5000,
    canCancel = third == true,
    useWhileDead = true,
    disable = {
      combat = true
    }
  }
end

local function RunLegacyProgress(...)
  return ProgressBar(BuildLegacyProgress(...))
end

RegisterNetEvent("Progress", RunLegacyProgress)
RegisterNetEvent("progress", RunLegacyProgress)
RegisterNetEvent("ProgressBar", RunLegacyProgress)
RegisterNetEvent("seoul:progress", RunLegacyProgress)
RegisterNetEvent("reborn:progress", RunLegacyProgress)
exports("Progress", RunLegacyProgress)

-- Exports para Radial Menu
exports("AddRadialItem", AddRadialItem)
exports("RemoveRadialItem", RemoveRadialItem)
exports("ClearRadialItems", ClearRadialItems)
exports("RegisterRadial", RegisterRadial)
exports("HideRadial", HideRadial)
exports("DisableRadial", disableRadial)
exports("GetCurrentRadialId", GetCurrentRadialId)

-- Exports para Skill Check
exports("SkillCheck", SkillCheck)
exports("SkillCheckActive", SkillCheckActive)
exports("CancelSkillCheck", CancelSkillCheck)

-- Exports para Input Dialog
exports("InputDialog", InputDialog)
exports("CloseInputDialog", CloseInputDialog)

-- Exports para Context Menu
exports("RegisterContext", RegisterContext)
exports("ShowContext", ShowContext)
exports("HideContext", HideContext)
exports("GetOpenContextMenu", GetOpenContextMenu)

-- Exports para Alert Dialog
exports("AlertDialog", AlertDialog)
exports("CloseAlertDialog", CloseAlertDialog)

-- Exports para Menu
exports("RegisterMenu", RegisterMenu)
exports("ShowMenu", ShowMenu)
exports("HideMenu", HideMenu)
exports("GetOpenMenu", GetOpenMenu)
exports("SetMenuOptions", SetMenuOptions)
