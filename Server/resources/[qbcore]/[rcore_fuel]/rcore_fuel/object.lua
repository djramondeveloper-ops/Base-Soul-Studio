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

local loadedObject = false
OnObjectLoadedVariable = {}

function OnObjectLoaded(cb)
    if loadedObject then
        cb()
        return
    end
    table.insert(OnObjectLoadedVariable, cb)
end

function GetFrameworkName()
    local frameworkType = Config.Framework.Active
    if frameworkType == Framework.ESX then
        return Config.Framework.ES_EXTENDED_NAME
    end
    if frameworkType == Framework.QBCORE then
        return Config.Framework.QB_CORE_NAME
    end
    return nil
end

function IsResourceOnServer(resourceName)
    if not resourceName then return false end
    local state = GetResourceState(resourceName)
    return state == "started" or state == "starting"
end

local function awaitSharedObjectEvent(eventName, timeoutMs)
    if not eventName then return nil end

    local eventPromise = promise:new()
    local settled = false

    local function settle(value)
        if settled then return end
        settled = true
        eventPromise:resolve(value)
    end

    TriggerEvent(eventName, function(obj)
        settle(obj)
    end)

    SetTimeout(timeoutMs or 2000, function()
        settle(nil)
    end)

    return Citizen.Await(eventPromise)
end

local function runLoadedCallbacks()
    loadedObject = true
    local callbacks = OnObjectLoadedVariable
    OnObjectLoadedVariable = {}

    for _, callback in ipairs(callbacks) do
        callback()
    end
end

function GetSharedObject()
    local framework = Config.Framework.Active

    if not Config.Framework.DisableDetection then
        if IsResourceOnServer(Config.Framework.ES_EXTENDED_NAME) then
            framework = Framework.ESX
        end

        if IsResourceOnServer(Config.Framework.QB_CORE_NAME)
            or IsResourceOnServer("qb-core")
            or IsResourceOnServer("qbx_core") then
            framework = Framework.QBCORE
        end
    end

    Config.Framework.Active = framework

    if framework == Framework.CUSTOM then
        runLoadedCallbacks()
        return {}
    end

    local sharedObject = nil

    if framework == Framework.ESX then
        if ESX ~= nil then
            sharedObject = ESX
        end

        if not sharedObject then
            local resourceName = GetFrameworkName() or "es_extended"
            local ok, result = pcall(function()
                return exports[resourceName]:getSharedObject()
            end)
            if ok and result then
                sharedObject = result
            end
        end

        if not sharedObject then
            sharedObject = awaitSharedObjectEvent(Config.Framework.ESX_SHARED_OBJECT, 2000)
        end
    elseif framework == Framework.QBCORE then
        local resourceName = GetFrameworkName() or "qb-core"

        local ok, result = pcall(function()
            return exports[resourceName]:GetCoreObject()
        end)
        if ok and result then
            sharedObject = result
        end

        if not sharedObject then
            ok, result = pcall(function()
                return exports[resourceName]:GetSharedObject()
            end)
            if ok and result then
                sharedObject = result
            end
        end

        if not sharedObject and IsResourceOnServer("qb-core") and resourceName ~= "qb-core" then
            ok, result = pcall(function()
                return exports["qb-core"]:GetCoreObject()
            end)
            if ok and result then
                sharedObject = result
            end
        end

        if not sharedObject then
            sharedObject = awaitSharedObjectEvent(Config.Framework.QBCORE_SHARED_OBJECT, 2000)
        end
    end

    if not sharedObject then
        print(("^1[%s]^7 Failed to load framework shared object (framework=%s). Check Config.Framework and resource names.")
            :format(GetCurrentResourceName(), tostring(framework)))
    end

    runLoadedCallbacks()
    return sharedObject
end
