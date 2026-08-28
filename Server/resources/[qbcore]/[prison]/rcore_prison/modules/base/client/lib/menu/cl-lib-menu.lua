local registeredMenus = {}
local onChangeCallbacks = {}
local onClickCallbacks = {}
local goBackCallbacks = {}
local onFocusCallbacks = {}

function IsMenuRegistered(menuId)
    if registeredMenus[menuId] then
        return true
    end

    dbg.menu("Menu with id %s not registered.", menuId or "undefined")
    return false
end

function GetCachedFunctionKey(menuId, rowId)
    return ("%s_%s"):format(menuId, rowId)
end

function GetValidPosition(position)
    local validPositions = {
        "top-left",
        "top-right",
        "bottom-left",
        "bottom-right"
    }

    for _, validPosition in ipairs(validPositions) do
        if validPosition == position then
            return position
        end
    end

    dbg.menu("Invalid menu position %s, defaulting to %s", position, validPositions[1])
    return validPositions[1]
end

function RegisterMenu(menuId, menuData)
    if registeredMenus[menuId] then
        dbg.menu("Menu with id %s already registered.", menuId)
        return
    end

    if not menuId then
        dbg.menu("Menu id not provided.")
        return
    end

    local menu = {
        id = menuId,
        header = menuData.header or "",
        headerTextColor = menuData.headerTextColor or "#000",
        headerImg = menuData.headerImg or nil,
        title = menuData.title or "",
        accentColor = menuData.accentColor or "#f2b440",
        maxRowsInView = menuData.maxRowsInView or 5,
        loadingLabel = menuData.loadingLabel or "Loading, please wait...",
        rows = menuData.rows or {},
        position = GetValidPosition(menuData.position)
    }

    registeredMenus[menuId] = menu

    if menuData.goBack then
        goBackCallbacks[menuId] = menuData.goBack
    end

    for _, row in ipairs(menu.rows) do
        if row.onChange and type(row.onChange) == "function" then
            local callbackKey = GetCachedFunctionKey(menuId, row.id)
            onChangeCallbacks[callbackKey] = row.onChange
            row.onChange = nil
        end

        if row.onClick and type(row.onClick) == "function" then
            local callbackKey = GetCachedFunctionKey(menuId, row.id)
            onClickCallbacks[callbackKey] = row.onClick
            row.onClick = nil
        end

        if row.onFocus and type(row.onFocus) == "function" then
            local callbackKey = GetCachedFunctionKey(menuId, row.id)
            onFocusCallbacks[callbackKey] = row.onFocus
            row.onFocus = nil
        end
    end

    FrontendService.SendReactMessage("reactMenuRegister", registeredMenus[menuId])
end

function GetMenuData(menuId)
    if not IsMenuRegistered(menuId) then
        return
    end

    return registeredMenus[menuId].rows
end

function DestroyMenu(menuId)
    if not IsMenuRegistered(menuId) then
        return
    end

    dbg.menu("Destroying menu with id %s", menuId)

    isBossMenuOpened = false
    IsMenuOpened = false
    HasActiveMenu = false

    SetNuiFocus(false, false)
    HideMenu(menuId)

    registeredMenus[menuId] = nil
    FrontendService.SendReactMessage("reactMenuDestroy", menuId)

    ClearCachedFunctionsForMenu(menuId)
end

function DestroyAllMenus()
    local menuIds = {}

    for menuId in pairs(registeredMenus) do
        menuIds[#menuIds + 1] = menuId
    end

    for _, menuId in ipairs(menuIds) do
        DestroyMenu(menuId)
    end
end

function ShowMenu(menuId)
    dbg.menu("Showing menu with id %s", menuId)

    if not IsMenuRegistered(menuId) then
        dbg.menu("%s", menuId)
        return
    end

    SetNuiFocus(true, false)

    FrontendService.SendReactMessage("loadApp", {
        screen = Screens.MENU,
        visible = true
    })

    FrontendService.SendReactMessage("reactMenuSetOpenState", {
        id = menuId,
        isOpened = true
    })

    dbg.menu("Menu with ID [%s] is opened", menuId)

    IsMenuOpened = true
    HasActiveMenu = true
end

function disableWeaponWheel()
    CreateThread(function()
        while IsMenuOpened do
            Wait(0)
            HudForceWeaponWheel(false)
            HudWeaponWheelIgnoreSelection()
            DisableControlAction(0, 37, true)
        end
    end)
end

function disableFiring()
    CreateThread(function()
        while IsMenuOpened do
            Wait(0)
            DisablePlayerFiring(PlayerPedId(), true)
        end
    end)
end

function DisableCombat()
    disableFiring()
    disableWeaponWheel()
end

function HideMenu(menuId)
    dbg.menu("Hiding menu with id %s", menuId)

    if not IsMenuRegistered(menuId) then
        return
    end

    SetNuiFocus(false, false)
    HelpKeys.Hide()

    if SH.zoneId and Config.Target == "NONE" then
        HelpKeys.ShowZoneInteractionKeys()
    end

    FrontendService.SendReactMessage("reactMenuSetOpenState", {
        id = menuId,
        isOpened = false
    })

    IsMenuOpened = false
    HasActiveMenu = false
end

local function ExecuteRowOnChange(menuId, rowId)
    local callbackKey = GetCachedFunctionKey(menuId, rowId)
    local callback = onChangeCallbacks[callbackKey]

    if callback then
        callback()
    end
end

local function ExecuteRowOnClick(menuId, rowId)
    local callbackKey = GetCachedFunctionKey(menuId, rowId)
    local callback = onClickCallbacks[callbackKey]

    if callback then
        callback()
    end
end

local function ExecuteRowOnFocus(menuId, rowId)
    local callbackKey = GetCachedFunctionKey(menuId, rowId)
    local callback = onFocusCallbacks[callbackKey]

    if callback then
        callback()
    end
end

function ShouldExecuteOnChange(menuId, updatedRow, changeData)
    if not IsMenuRegistered(menuId) then
        return
    end

    local newValue = updatedRow[changeData.valueName]

    if changeData.valueName == "isChecked" then
        return newValue ~= changeData.prevValue
    end

    if changeData.valueName == "value" then
        return newValue ~= changeData.prevValue
    end

    if changeData.valueName == "selectedOption" then
        return json.encode(changeData.prevValue) ~= json.encode(newValue)
    end
end

function SendMenuUpdate(menuId, rowId, updatedRow, changeData)
    dbg.menu("Sending menu update for menu %s, row %s", menuId, rowId)

    if not IsMenuRegistered(menuId) then
        return
    end

    FrontendService.SendReactMessage("reactMenuUpdateData", {
        id = menuId,
        rowKey = rowId,
        updatedRow = updatedRow
    })

    if ShouldExecuteOnChange(menuId, updatedRow, changeData) then
        ExecuteRowOnChange(menuId, rowId)
    end
end

function SetMenuLoading(menuId, isLoading)
    FrontendService.SendReactMessage("reactMenuSetLoading", {
        id = menuId,
        isLoading = isLoading
    })
end

function SetRowLoading(menuId, rowId, isLoading)
    SetMenuRowValue(menuId, rowId, "isLoading", isLoading)
end

function GetRowIndexById(menuId, rowId)
    if not IsMenuRegistered(menuId) then
        return
    end

    for rowIndex, row in ipairs(registeredMenus[menuId].rows) do
        if row.id == rowId then
            return rowIndex
        end
    end
end

function SetMenuRowValue(menuId, rowId, valueName, value)
    dbg.menu("Setting menu row value for menu %s, row %s, value %s", menuId, rowId, valueName)

    if not IsMenuRegistered(menuId) then
        return
    end

    Wait(0)

    local previousValue
    local rowIndex = GetRowIndexById(menuId, rowId)

    if rowIndex and registeredMenus[menuId] and registeredMenus[menuId].rows[rowIndex] then
        previousValue = registeredMenus[menuId].rows[rowIndex][valueName]
        registeredMenus[menuId].rows[rowIndex][valueName] = value
    else
        return
    end

    SendMenuUpdate(menuId, rowId, GetMenuRow(menuId, rowId), {
        valueName = valueName,
        prevValue = previousValue
    })
end

function GetMenuRow(menuId, rowId)
    if not IsMenuRegistered(menuId) then
        return
    end

    local rowIndex = GetRowIndexById(menuId, rowId)
    if not rowIndex then
        return
    end

    return registeredMenus[menuId] and registeredMenus[menuId].rows and registeredMenus[menuId].rows[rowIndex]
end

function GetMenuRowValue(menuId, rowId, key)
    if not IsMenuRegistered(menuId) then
        return
    end

    local row = GetMenuRow(menuId, rowId)
    if row then
        return row[key]
    end
end

function ClearCachedFunctionsForMenu(menuId)
    local rowCallbackPrefix = tostring(menuId) .. "_"

    for cacheKey in pairs(onChangeCallbacks) do
        if cacheKey:sub(1, #rowCallbackPrefix) == rowCallbackPrefix then
            onChangeCallbacks[cacheKey] = nil
        end
    end

    for cacheKey in pairs(onClickCallbacks) do
        if cacheKey:sub(1, #rowCallbackPrefix) == rowCallbackPrefix then
            onClickCallbacks[cacheKey] = nil
        end
    end

    if goBackCallbacks[menuId] then
        goBackCallbacks[menuId] = nil
    end

    for cacheKey in pairs(onFocusCallbacks) do
        if cacheKey:sub(1, #rowCallbackPrefix) == rowCallbackPrefix then
            onFocusCallbacks[cacheKey] = nil
        end
    end
end

function UpdateMenuData(menuId, rowId, value, rowType)
    dbg.menu(
        "Updating menu data for menu %s, row %s, value %s, type %s",
        menuId,
        rowId,
        value,
        rowType
    )

    if not IsMenuRegistered(menuId) then
        return
    end

    local wasUpdated = false

    if rowType == "checkbox" then
        SetMenuRowValue(menuId, rowId, "isChecked", value)
        wasUpdated = true
    elseif rowType == "select" then
        SetMenuRowValue(menuId, rowId, "selectedOption", value)
        wasUpdated = true
    elseif rowType == "input" then
        SetMenuRowValue(menuId, rowId, "value", value)
        wasUpdated = true
    end

    if not wasUpdated then
        dbg.menu("error", "Menu data not updated, invalid type %s", rowType)
    end
end

function GoBackInMenu(menuId)
    if not IsMenuRegistered(menuId) then
        return
    end

    local callback = goBackCallbacks[menuId]
    if callback and type(callback) == "function" then
        callback()
        return true
    end

    return false
end

RegisterNuiCallback("handleMenuCheckboxChange", function(data, cb)
    cb({})
    UpdateMenuData(data.menuId, data.key, data.value, "checkbox")
end)

RegisterNuiCallback("handleMenuSelectChange", function(data, cb)
    cb({})
    UpdateMenuData(data.menuId, data.key, data.value, "select")
end)

RegisterNuiCallback("handleMenuInputChange", function(data, cb)
    cb({})
    UpdateMenuData(data.menuId, data.key, data.value, "input")
end)

RegisterNuiCallback("handleMenuButtonClick", function(data, cb)
    cb({})
    ExecuteRowOnClick(data.menuId, data.key)
end)

RegisterNuiCallback("handleCloseMenu", function(data, cb)
    cb({})
    HideMenu(data.menuId)
    TriggerLocalClientEvent("onHud", true, "SHOW_HUD", "CLOSE_MENU_MENU")
end)

RegisterNuiCallback("handleMenuRowFocus", function(data, cb)
    cb({})

    if SH.screen ~= Screens.MENU then
        return
    end

    dbg.menu("Menu row focus for menu %s, row %s", data.menuId, data.key)
    ExecuteRowOnFocus(data.menuId, data.key)
end)

RegisterNuiCallback("handleMenuGoBack", function(data, cb)
    cb({})
    GoBackInMenu(data.menuId)
end)