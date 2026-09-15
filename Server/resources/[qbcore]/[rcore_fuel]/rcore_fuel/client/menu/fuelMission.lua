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

function OpenOptionalAcceptMenu(bossName, cb)
    local menu = CreateMenu("fuel_mission_accept_menu")

    menu.SetPrimaryTitle(_U("fuel_mission_primary_title_menu"))
    menu.SetSecondaryTitle(_U("select_item"))

    menu.SetProperties({
        float = "right",
        position = "middle",
    })

    menu.AddItem(_U("accept_task"), function()
        menu.RemoveAllEvents()
        cb("yes")
        menu.Close()
    end, _U("fuel_mission_title_menu", bossName))

    menu.AddItem(_U("decline_task"), function()
        menu.RemoveAllEvents()
        cb("no")
        menu.Close()
    end, _U("fuel_mission_title_menu", bossName))

    menu.OnCloseEvent(function()
        cb("no")
    end)

    menu.OnExitEvent(function()
        cb("no")
    end)

    menu.Open()
end

-- FIX 1: OpenOptionalMenuWithOptions was called from FinalizePaymentForNonMissionFuel
-- (client/company/buy_marker.lua) but was never defined anywhere in the codebase.
-- Shows a generic selection menu and fires callback(value) or callback(nil) on close/exit.
function OpenOptionalMenuWithOptions(title, options, cb)
    local fired    = false
    local function fire(val)
        if not fired then
            fired = true
            if cb then cb(val) end
        end
    end

    local menu = CreateMenu("fuel_optional_options_menu")
    menu.SetPrimaryTitle(title or "")
    menu.SetSecondaryTitle(_U("select_item"))
    menu.SetProperties({ float = "right", position = "middle" })

    for _, opt in ipairs(options or {}) do
        local val = opt.value
        menu.AddItem(opt.label or tostring(val), function()
            menu.RemoveAllEvents()
            menu.Close()
            fire(val)
        end)
    end

    menu.OnCloseEvent(function() fire(nil) end)
    menu.OnExitEvent(function()  fire(nil) end)
    menu.Open()
end
