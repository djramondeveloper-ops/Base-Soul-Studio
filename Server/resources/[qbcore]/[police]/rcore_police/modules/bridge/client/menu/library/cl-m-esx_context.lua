-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function UI:RenderESXContext(esxListArray, currentName, currentLabel)
    local function onSelect(menu, currentElement)
        if currentElement.onClick then
            local status, err = pcall(currentElement.onClick, currentElement)
            exports['esx_context']:Close()
        else
            if currentElement.serverEvent then
                TriggerServerEvent(currentElement.serverEvent, currentElement.args)
            elseif currentElement.event then
                TriggerEvent(currentElement.event, currentElement.args)
            end
            exports['esx_context']:Close()
        end
    end
    function OpenContextMenu(position, menuData, onBack, parentMenu)
        local currentMenuData = table.deepcopy(menuData)
        if parentMenu then
            table.insert(currentMenuData, 1, { icon = "fas fa-arrow-left", title = _U('MENUS.GO_BACK_BUTTON_LABEL'), value = 'go_back' })
        end
        exports['esx_context']:Open(position, currentMenuData, function(menu, currentElement)
            local data = { current = currentElement }
            if data.current.value == 'go_back' then
                if onBack then
                    onBack()
                end
                return
            end
            if data.current.submenu then
                OpenContextMenu(position, data.current.submenu, function()
                    OpenContextMenu(position, menuData, onBack, parentMenu)
                end, currentMenuData)
            else
                onSelect(menu, currentElement)
            end
        end, onBack)
    end
    OpenContextMenu("right", esxListArray.options)
end
