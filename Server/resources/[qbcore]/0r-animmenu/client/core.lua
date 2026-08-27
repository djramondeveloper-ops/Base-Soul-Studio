Core = nil
CoreName = nil
CoreReady = false

local function resourceStarted(resourceName)
    local state = GetResourceState(resourceName)
    return state == "starting" or state == "started"
end

local function frameworkIsValid(resourceName, framework)
    if type(framework) ~= "table" then
        return false
    end

    if resourceName == "qb-core" or resourceName == "qbx_core" then
        return type(framework.Functions) == "table" and type(framework.Functions.GetPlayerData) == "function"
    end

    if resourceName == "es_extended" then
        return type(framework.GetPlayerData) == "function"
    end

    return false
end

local function getCoreEntry(resourceName)
    for _, entry in ipairs(Cores) do
        if entry.ResourceName == resourceName then
            return entry
        end
    end
end

local function tryFramework(entry)
    if not entry or not resourceStarted(entry.ResourceName) then
        return false
    end

    local ok, framework = pcall(entry.GetFramework)
    if not ok or not frameworkIsValid(entry.ResourceName, framework) then
        return false
    end

    CoreName = entry.ResourceName
    Core = framework
    CoreReady = true
    return true
end

local function resolveFramework()
    -- A Seoul usa vRP/Creative como motor e expõe compatibilidade QB/ESX.
    -- O animmenu já foi escrito em torno das APIs QBCore/ESX, então quando
    -- vRP estiver ativo preferimos a camada QBCore que a própria Seoul expõe.
    if resourceStarted("vrp") then
        local seoulPriority = { "qb-core", "es_extended", "qbx_core" }
        for _, resourceName in ipairs(seoulPriority) do
            if tryFramework(getCoreEntry(resourceName)) then
                return true
            end
        end

        return false
    end

    -- Fora da Seoul preserva a detecção original dos frameworks suportados,
    -- mas só considera pronto depois de receber um objeto Core realmente válido.
    for _, entry in ipairs(Cores) do
        if tryFramework(entry) then
            return true
        end
    end

    return false
end

Citizen.CreateThread(function()
    while not CoreReady do
        if resolveFramework() then
            print(("^2[0r-animmenu]^7 Framework detectado: ^3%s^7"):format(CoreName))
            break
        end

        Citizen.Wait(250)
    end
end)

function GetPlayerData()
    if not CoreReady or not frameworkIsValid(CoreName, Core) then
        return {}
    end

    local ok, player

    if CoreName == "qb-core" or CoreName == "qbx_core" then
        ok, player = pcall(Core.Functions.GetPlayerData)
    elseif CoreName == "es_extended" then
        ok, player = pcall(Core.GetPlayerData)
    end

    if not ok or type(player) ~= "table" then
        return {}
    end

    return player
end

function Notify(text, length, notifyType)
    if CoreReady and CoreName == "qb-core" and Core and Core.Functions and type(Core.Functions.Notify) == "function" then
        Core.Functions.Notify(text, notifyType, length)
        return
    end

    if CoreReady and CoreName == "qbx_core" and Core and Core.Functions and type(Core.Functions.Notify) == "function" then
        Core.Functions.Notify(text, notifyType, length)
        return
    end

    if CoreReady and CoreName == "es_extended" and Core and type(Core.ShowNotification) == "function" then
        Core.ShowNotification(text, notifyType, length)
        return
    end

    -- Compatibilidade Seoul: a camada QBCore registra este evento no client.
    TriggerEvent('QBCore:Notify', text, notifyType, length)
end

-- Text UI
function Create3DTextUIOnPlayer(name, data)
    create3DTextUIOnPlayers(name, data)
end

function Delete3DTextUIOnPlayer(name)
    delete3DTextUIOnPlayers(name, data)
end

function ShowTextUI(name, key)
    displayTextUI(name, key)
end

function HideTextUI()
    hideTextUI()
end
