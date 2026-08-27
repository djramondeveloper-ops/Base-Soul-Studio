-----##########################################################-----
--###          ADMINCONTROL SEOUL - INSERT KEYBIND
-----##########################################################-----

local lastOpen = 0
local commandName = "seoul_admincontrol"

local function requestAdminControl()
    local now = GetGameTimer()
    if now - lastOpen < 800 then return end
    lastOpen = now

    -- Permission is validated server-side in AdminControl:openMenu/openMenu().
    TriggerServerEvent("AdminControl:openMenu")
end

RegisterCommand(commandName, function()
    requestAdminControl()
end, false)

RegisterKeyMapping(commandName, "Abrir AdminControl", "keyboard", "INSERT")

RegisterNetEvent("AdminControl:client:openByInsert", function()
    requestAdminControl()
end)
