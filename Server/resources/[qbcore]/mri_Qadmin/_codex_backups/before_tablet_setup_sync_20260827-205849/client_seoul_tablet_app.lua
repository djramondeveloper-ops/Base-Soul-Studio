-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMIN APP FOR LB TABLET
-----------------------------------------------------------------------------------------------------------------------------------------
local APP_ID = 'seoul_admin'
local APP_NAME = 'Seoul Admin'
local appOpen = false
local appAdded = false

local function tabletStarted()
    return GetResourceState('lb-tablet') == 'started'
end

local function sendToApp(action, data)
    if not tabletStarted() then return false end
    local ok = pcall(function()
        exports['lb-tablet']:SendCustomAppMessage(APP_ID, action, data or {})
    end)
    return ok
end

function SeoulTabletAdminSend(action, data)
    if not appOpen then return false end
    return sendToApp(action, data)
end

local function loadTranslations()
    local locale = GetConvar('ox:locale', GetConvar('ox_locale', 'pt-br'))
    local path = ('locales/%s.json'):format(locale)
    local raw = LoadResourceFile(GetCurrentResourceName(), path)
    if not raw and locale ~= 'pt-br' then
        locale = 'pt-br'
        raw = LoadResourceFile(GetCurrentResourceName(), 'locales/pt-br.json')
    end
    if raw then
        local ok, decoded = pcall(json.decode, raw)
        if ok and decoded then
            sendToApp('setTranslations', { translations = decoded, locale = locale })
        end
    end
end

local function requestSetup()
    -- A UI original do mri_Qadmin só renderiza o painel depois de receber setVisible=true.
    -- Dentro do lb-tablet o iframe já está aberto, mas sem esse evento fica tudo preto.
    sendToApp('setVisible', true)
    loadTranslations()
    TriggerServerEvent('mri_Qadmin:seoul:requestOpenFromTablet')
    TriggerEvent('mri_Qadmin:client:SetupPanel')
end

local function removeApp()
    if not tabletStarted() then return end
    pcall(function()
        exports['lb-tablet']:RemoveCustomApp(APP_ID)
    end)
    appAdded = false
end

local function registerApp()
    while not tabletStarted() do Wait(500) end

    local allowed = lib.callback.await('mri_Qadmin:seoul:canAccess', false)
    if not allowed then
        removeApp()
        return
    end

    removeApp()

    local success, reason = exports['lb-tablet']:AddCustomApp({
        identifier = APP_ID,
        name = APP_NAME,
        description = 'Painel administrativo oficial da Seoul Base.',
        developer = 'Seoul Dev',
        defaultApp = true,
        removable = false,
        size = 12288,
        icon = 'web/build/seoul_admin.svg',
        ui = 'web/build/index.html?tablet=1',

        onOpen = function()
            appOpen = true
            requestSetup()
            CreateThread(function()
                for _ = 1, 8 do
                    Wait(500)
                    if appOpen then requestSetup() end
                end
            end)
        end,

        onClose = function()
            appOpen = false
            -- Esconde o painel interno para ele abrir limpo da próxima vez.
            sendToApp('setVisible', false)
        end
    })

    appAdded = success == true
    if not success then
        print(('^1[Seoul Admin]^7 Falha ao registrar app no lb-tablet: %s'):format(tostring(reason)))
    else
        print('^2[Seoul Admin]^7 App registrado no Seoul Tablet para grupo Admin.')
    end
end

CreateThread(function()
    Wait(1500)
    registerApp()
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == 'lb-tablet' or resource == GetCurrentResourceName() then
        Wait(1500)
        registerApp()
    end
end)

RegisterNetEvent('mri_Qadmin:client:seoul:refreshTabletAdmin', function()
    registerApp()
end)
