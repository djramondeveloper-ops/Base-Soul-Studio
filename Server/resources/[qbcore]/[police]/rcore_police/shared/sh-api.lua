-- =====================================================
--  rcore_police · shared/sh-api.lua
--  Engineered by Eazy Fxap
--  Original: 314 lines → Cleaned: 120 lines
-- =====================================================

-- ============================================================
--  EXPORT HELPERS
-- ============================================================

local function registerExport(name, func)
    local eventName = ("__cfx_export_%s_%s"):format(GetCurrentResourceName(), name)
    AddEventHandler(eventName, function(cb)
        cb(func)
    end)
end

local function registerExports(list)
    for _, entry in ipairs(list) do
        registerExport(entry.name, entry.func)
        dbg.debugAPI("Registered export: %s", entry.name)
    end
end

_G.registerExport  = registerExport
_G.registerExports = registerExports

-- ============================================================
--  LOCAL EVENT WRAPPERS
-- ============================================================

if IsDuplicityVersion() then
    -- Server-side local event helpers
    function RegisterLocalServerEvent(name, handler)
        local eventKey = ("%s:%s:%s"):format(GetCurrentResourceName(), "server", name)
        if eventKey then
            AddEventHandler(name, function(...)
                handler(...)
            end)
        end
    end

    function TriggerLocalServerEvent(name, ...)
        local eventKey = ("%s:%s:%s"):format(GetCurrentResourceName(), "server", name)
        if eventKey then
            TriggerEvent(name, ...)
        end
    end
else
    -- Client-side local event helpers
    function RegisterLocalClientEvent(name, handler)
        local eventKey = ("%s:%s:%s"):format(GetCurrentResourceName(), "client", name)
        if eventKey then
            AddEventHandler(name, function(...)
                handler(...)
            end)
        end
    end

    function TriggerLocalClientEvent(name, ...)
        local eventKey = ("%s:%s:%s"):format(GetCurrentResourceName(), "client", name)
        if eventKey then
            TriggerEvent(name, ...)
        end
    end
end

-- ============================================================
--  API EXPORT REGISTRATION (runs on next tick)
-- ============================================================

CreateThread(function()
    Wait(0)

    if IsDuplicityVersion() then
        -- Server exports
        local serverGroups = {
            Actions = {
                { name = "JailPlayer",           func = ActionService.JailPlayer },
                { name = "SearchPlayer",          func = ActionService.SearchPlayer },
                { name = "Escort",                func = ActionService.Escort },
                { name = "Zipties",               func = ActionService.ZipTies },
                { name = "Handcuff",              func = ActionService.Handcuff },
                { name = "PutPlayerInVehicle",    func = ActionService.PutPlayerInVehicle },
                { name = "TakePlayerFromVehicle", func = ActionService.TakePlayerFromVehicle },
                { name = "RemoveHandcuff",        func = ActionService.RemoveHandcuff },
                { name = "ForceUncuff",           func = ActionService.ForceUncuff },
                { name = "Paperbag",              func = ActionService.RequestHeadBag },
            },
            PlayerStates = {
                { name = "IsPlayerCuffed",      func = InteractionService.isCuffed },
                { name = "IsPlayerEscorted",    func = InteractionService.isEscorted },
                { name = "IsPlayerHeadBagged",  func = InteractionService.isHeadBagged },
                { name = "IsPlayerZiptied",     func = InteractionService.isPlayerZiptied },
            },
            Miscellaneous = {
                { name = "GetPoliceOnline", func = GroupsService.GetAllDeparmentsCount },
            },
        }
        for _, group in pairs(serverGroups) do
            registerExports(group)
        end
    else
        -- Client exports
        local clientGroups = {
            PlayerStates = {
                { name = "IsPlayerCuffed",            func = InteractionService.isCuffed },
                { name = "IsPlayerEscorted",          func = InteractionService.isEscorted },
                { name = "IsPlayerHeadBagged",        func = InteractionService.isHeadBagged },
                { name = "IsPlayerZiptied",           func = InteractionService.isPlayerZiptied },
            },
            Miscellaneous = {
                { name = "GetPoliceOnline",           func = GroupsService.GetAllDeparmentsCount },
                { name = "PlaceWheelClamp",           func = Props.RequestWheelClamp },
                { name = "RemoveWheelClamp",          func = RemoveWheelClamp },
                { name = "DoesVehicleHaveWheelClamp", func = DoesVehicleHaveWheelClamp },
            },
        }
        for _, group in pairs(clientGroups) do
            registerExports(group)
        end
    end
end)
