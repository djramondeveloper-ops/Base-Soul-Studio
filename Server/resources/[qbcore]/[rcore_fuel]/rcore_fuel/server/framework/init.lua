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

-- Preserve the shared Framework enum table from const.lua.
Framework = Framework or {}
Framework.Active = Config.Framework.Active

local function ResourceStarted(resourceName)
    if not resourceName or resourceName == "" then return false end
    local state = GetResourceState(resourceName)
    return state == "started" or state == "starting"
end

local function ApplyFrameworkImplementation(implementation)
    if not implementation then return false end
    for name, fn in pairs(implementation) do
        if name ~= "Init" and type(fn) == "function" then
            Framework[name] = fn
        end
    end
    if type(implementation.Init) == "function" then
        implementation.Init()
    end
    return true
end

function Framework.Init()
    if not Config.Framework.DisableDetection then
        if ResourceStarted("qb-core") or ResourceStarted("qbx_core") or ResourceStarted(Config.Framework.QB_CORE_NAME) then
            Framework.Active = Framework.QBCORE or 2
        elseif ResourceStarted(Config.Framework.ES_EXTENDED_NAME or "es_extended") then
            Framework.Active = Framework.ESX or 1
        else
            Framework.Active = Config.Framework.Active
        end
        Config.Framework.Active = Framework.Active
    end

    if Framework.Active == (Framework.QBCORE or 2) then
        if not ApplyFrameworkImplementation(QBCoreFrameworkImplementation) then
            print("^1[rcore_fuel] QBCore selected but the QBCore bridge was not loaded.^7")
        end
    elseif Framework.Active == (Framework.ESX or 1) then
        if not ApplyFrameworkImplementation(ESXFrameworkImplementation) then
            print("^1[rcore_fuel] ESX selected but the ESX bridge was not loaded.^7")
        end
    else
        ApplyFrameworkImplementation(StandaloneFrameworkImplementation)
    end
end

CreateThread(function()
    -- All bridge files are loaded in the same server-script batch. Defer one tick,
    -- then install only the implementation selected/detected above.
    Wait(0)
    Framework.Init()
end)
