local Frontend = {
  currentLabel = nil,
  currentName = nil,
  currentLibrary = Config.Menus,
  useLibrary = Config.Menus,
  Libraries = {
    ox_lib = true,
    ["qb-menu"] = true
  },
  Menus = {}
}

local function capitalizeFirst(text)
  return text:gsub("^%l", string.upper)
end

local function buildLabel(item)
  local header = item.header
  local text = item.txt

  if header and text and header ~= text then
    return ("%s - %s"):format(header, text)
  end

  return header
end

local function getMenuEventData(item)
  local params = item.params or {}
  local eventName = params.event
  local args = params.args

  return {
    isClient = params.isClient,
    isServer = params.isServer,
    event = eventName,
    args = args
  }
end

local rcoreMenuSettings = {
  [MENU_ID_LIST.JOB_MENU] = {
    headerImage = GetImageByName("yard"),
    title = _U("MENU.JOB_TITLE")
  },
  [MENU_ID_LIST.LOBBY_MENU] = {
    headerImage = GetImageByName("gate"),
    title = _U("MENU.LOBBY_TITLE")
  },
  [MENU_ID_LIST.COMS_MENU] = {
    headerImage = GetImageByName("coms"),
    title = _U("COMS_MENU.TITLE")
  }
}

c = capitalizeFirst
_G.Frontend = Frontend

function Frontend:ParseData(menuData, callback)
  local parsedData = {}

  if Config.Menus == Menus.OX then
    parsedData = self:Ox(menuData)
  elseif Config.Menus == Menus.ESX_MENU or Config.Menus == Menus.ESX_CONTEXT then
    parsedData = self:Esx(menuData)
  elseif Config.Menus == Menus.RCORE then
    parsedData = self:Rcore(menuData)
  end

  callback(parsedData)
end

function Frontend:CloseMenu()
  if Config.Menus == Menus.QB then
    exports["qb-menu"]:closeMenu()
    self.currentName = nil
  elseif Config.Menus == Menus.OX then
    if not lib then
      return dbg.debug("FE:CloseMenu - failed, ox_lib is not defined in fxmanifest.lua!")
    end

    lib.hideContext()
    self.currentName = nil
  elseif Config.Menus == Menus.ESX_MENU then
    if not Framework then
      return dbg.debug("FE:CloseMenu - failed, es_extended is not detected!")
    end

    Framework.UI.Menu.CloseAll()
  elseif Config.Menus == Menus.ESX_CONTEXT then
    exports.esx_context:Close()
    self.currentName = nil
  elseif Config.Menus == Menus.RCORE then
    self.currentName = nil
  end

  TriggerLocalClientEvent("onHud", true, "SHOW_HUD", "CLOSE_MENU")
end

function Frontend:ObtainSettingForRcore(menuId)
  return rcoreMenuSettings[menuId]
end

function Frontend:Rcore(menuData)
  self:RemoveHeaderFromArray(menuData)

  local parsedMenu = {
    options = {}
  }

  local waitForBuild = promise.new()
  local totalItems = #menuData

  for _, item in ipairs(menuData) do
    local option = {}
    local label = buildLabel(item)
    local eventData = getMenuEventData(item)

    option.label = label
    option.title = label
    option.description = item.description
    option.id = #parsedMenu.options + 1
    option.type = "button"

    if eventData.event and not eventData.isServer then
      option.event = eventData.event
    end

    if eventData.isServer and eventData.event then
      option.serverEvent = eventData.event
      option.args = eventData.args
    end

    if item.params then
      option.args = eventData.args
    end

    if item.disabled then
      option.disabled = true
    end

    if item.params and item.params.isClient then
      option.onClick = function()
        DestroyAllMenus()
        TriggerEvent(option.event, option.args)
      end
    end

    if item.params and item.params.isServer then
      option.onClick = function()
        DestroyAllMenus()
        TriggerServerEvent(option.serverEvent, option.args)
      end
    end

    parsedMenu.options[#parsedMenu.options + 1] = option

    if #parsedMenu.options == totalItems then
      waitForBuild:resolve(true)
    end
  end

  Citizen.Await(waitForBuild)

  local menuId = self.currentName

  CreateThread(function()
    if not IsMenuRegistered(menuId) then
      local settings = self:ObtainSettingForRcore(menuId) or {}

      RegisterMenu(menuId, {
        id = menuId,
        header = "",
        headerTextColor = "#fff",
        headerImg = settings.headerImage or nil,
        title = settings.title or "Unk title",
        accentColor = "#7ea5cc",
        maxRowsInView = 6,
        loadingLabel = settings.title or "Unk title",
        position = Config.Menu.Position,
        goBack = function()
          if not IsMenuRegistered(menuId) then
            return
          end

          dbg.menu("Closed menu with ID [%s]", menuId)
        end,
        rows = parsedMenu.options
      })
    end

    HelpKeys.ShowNavigationKeysInMenu()
    ShowMenu(menuId)
  end, "cl-main code name: Alfa")
end

function Frontend:Esx(menuData)
  self:RemoveHeaderFromArray(menuData)

  local parsedMenu = {
    options = {}
  }

  local waitForBuild = promise.new()
  local totalItems = #menuData

  for _, item in ipairs(menuData) do
    local option = {}
    local label = buildLabel(item)
    local eventData = getMenuEventData(item)

    option.label = label
    option.title = label

    if eventData.event and not eventData.isServer then
      option.event = eventData.event
    end

    if eventData.isServer and eventData.event then
      option.serverEvent = eventData.event
      option.args = eventData.args
    end

    if item.params then
      option.args = eventData.args
    end

    if item.disabled then
      option.disabled = true
    end

    parsedMenu.options[#parsedMenu.options + 1] = option

    if #parsedMenu.options == totalItems then
      waitForBuild:resolve(true)
    end
  end

  Citizen.Await(waitForBuild)

  if Config.Menus == Menus.ESX_MENU then
    RenderESXMenu(parsedMenu, self.currentName, self.currentLabel)
  elseif Config.Menus == Menus.ESX_CONTEXT then
    RenderESXContext(parsedMenu, self.currentName, self.currentLabel)
  end
end

function Frontend:RemoveHeaderFromArray(menuData)
  if not menuData then
    return
  end

  if type(menuData) == "table" then
    table.remove(menuData, 1)
    dbg.debug("Frontend - removed isMenuHeader from array.")
  end
end

function Frontend:Ox(menuData)
  self:RemoveHeaderFromArray(menuData)

  local parsedMenu = {
    id = self.currentName,
    title = c(self.currentLabel),
    options = {}
  }

  local waitForBuild = promise.new()
  local totalItems = #menuData

  for _, item in ipairs(menuData) do
    local option = {}
    local eventData = getMenuEventData(item)

    if item.header then
      option.title = item.header
    end

    if item.txt then
      option.description = item.txt
    end

    if eventData.event and not eventData.isServer then
      option.event = eventData.event
    end

    if eventData.isServer and eventData.event then
      option.serverEvent = eventData.event
      option.args = eventData.args
    end

    if item.params then
      option.args = eventData.args
    end

    if item.disabled then
      option.disabled = true
    end

    parsedMenu.options[#parsedMenu.options + 1] = option

    if #parsedMenu.options == totalItems then
      waitForBuild:resolve(true)
    end
  end

  Citizen.Await(waitForBuild)

  lib.registerContext(parsedMenu)
  Wait(0)

  return true
end

function Frontend:CreateMenu(name, menuLabel, menuData, shouldOpen)
  shouldOpen = shouldOpen or false

  if not name then
    return error("Frontend - failed to create menu, undefined name.")
  end

  if not menuData then
    return error("Frontend - failed to create menu, undefined menu data.")
  end

  if not menuLabel then
    return error("Frontend - failed to create menu, undefined menu menuLabel.")
  end

  local selectedLibrary = Config.Menus
  if not selectedLibrary then
    return error("Undefined library.")
  end

  if not Frontend.Menus[name] then
    Frontend.Menus[name] = {
      data = menuData
    }
  end

  self.currentName = name

  if not self.currentName then
    return dbg.critical("Failed to get currentName [%s]", self.currentName)
  end

  self.currentLabel = menuLabel

  if selectedLibrary == Menus.NONE then
    Config.Menus = Menus.RCORE
    selectedLibrary = Menus.RCORE
  end

  dbg.debug("Using frontend library -> [%s]", selectedLibrary)

  if selectedLibrary == Menus.QB then
    exports["qb-menu"]:openMenu(menuData)
  elseif selectedLibrary == Menus.OX then
    if not lib then
      return error([[
Frontend - failed to create menu, ox_lib not hooked with prison resource.
Please add ox_lib into rcore_prison/fxmanifest.lua
]])
    end

    if shouldOpen then
      self:ParseData(menuData, function(success)
        if success then
          dbg.debug("Opened menu named [%s]", self.currentName)
          lib.showContext(self.currentName)
        end
      end)
    end
  elseif selectedLibrary == Menus.ESX_MENU or selectedLibrary == Menus.ESX_CONTEXT or selectedLibrary == Menus.RCORE then
    if not Framework and selectedLibrary ~= Menus.RCORE then
      return error("Frontend - failed to create menu, esx_menu_list or esx_context not hooked with prison resource - unk framework.")
    end

    if shouldOpen then
      self:ParseData(menuData, function(success)
        if success then
          dbg.info("Opened menu named [%s]", self.currentName)
        end
      end)
    end
  end

  dbg.debug("Menu finished return state.")
end