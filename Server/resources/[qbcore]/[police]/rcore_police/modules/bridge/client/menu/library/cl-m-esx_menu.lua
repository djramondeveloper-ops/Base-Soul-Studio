-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function UI:RenderESXMenu(esxListArray, currentName, currentLabel)
    if not Framework then return end
    if not Framework.UI.Menu then return end
    Framework.UI.Menu.Open('default', GetCurrentResourceName(), currentName:lower(), {
        title    = c(currentLabel),
        align    = 'top-right',
        elements = esxListArray.options,
    }, function(data, menu)
        if data.current and data.current.serverEvent then
            TriggerServerEvent(data.current.serverEvent, data.current.args) 
        elseif data.current and data.current.event and data.current.args then
            TriggerEvent(data.current.event, data.current.args)
        end
        menu.close()
        currentName = nil
    end, function(data, menu) -- ON BACKSPACE CANCEL -> CLOSE
        menu.close()
        currentName = nil
    end)
end
