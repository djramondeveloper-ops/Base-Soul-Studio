PlayerData = PlayerData or {}
PlayerData.hunger = PlayerData.hunger or 100
PlayerData.thirst = PlayerData.thirst or 100
PlayerData.stress = PlayerData.stress or 0

local function clampStatus(value)
    value = tonumber(value) or 0
    if value < 0 then return 0 end
    if value > 100 then return 100 end
    return value
end

local function requestServerData()
    TriggerServerEvent(_e('server:requestSeoulPlayerData'))
end

AddEventHandler('onClientResourceStart', function(resource)
    if resource == shared.resource then
        CreateThread(function()
            Wait(1500)
            if client.onPlayerLoad and client.IsPlayerLoaded then
                client.onPlayerLoad(client.IsPlayerLoaded())
            end
            requestServerData()
        end)
    end
end)

AddStateBagChangeHandler('Active', ('player:%s'):format(GetPlayerServerId(PlayerId())), function(_, _, value)
    if client.onPlayerLoad then client.onPlayerLoad(value == true) end
    if value == true then requestServerData() end
end)

RegisterNetEvent('Connect', function()
    if client.onPlayerLoad then client.onPlayerLoad(true) end
    requestServerData()
end)

RegisterNetEvent('hud:Thirst', function(value)
    PlayerData.thirst = clampStatus(value)
end)

RegisterNetEvent('hud:Hunger', function(value)
    PlayerData.hunger = clampStatus(value)
end)

RegisterNetEvent('hud:Stress', function(value)
    PlayerData.stress = clampStatus(value)
end)

RegisterNetEvent('hud:client:UpdateNeeds', function(newHunger, newThirst)
    PlayerData.hunger = clampStatus(newHunger)
    PlayerData.thirst = clampStatus(newThirst)
end)

RegisterNetEvent('hud:client:UpdateStress', function(newStress)
    PlayerData.stress = clampStatus(newStress)
end)

RegisterNetEvent(_e('client:setSeoulPlayerData'), function(data)
    data = data or {}
    PlayerData.hunger = clampStatus(data.hunger or PlayerData.hunger)
    PlayerData.thirst = clampStatus(data.thirst or PlayerData.thirst)
    PlayerData.stress = clampStatus(data.stress or PlayerData.stress)
    PlayerData.bank = tonumber(data.bank) or PlayerData.bank or 0
    PlayerData.cash = tonumber(data.cash) or PlayerData.cash or 0
    PlayerData.extra_currency = tonumber(data.extra_currency) or PlayerData.extra_currency or 0
    PlayerData.job = data.job or PlayerData.job or { label = 'Civil', grade = 'Sem cargo' }
end)

AddEventHandler('hud:Active', function(status)
    SendNUIMessage({ action = 'ui:setVisible', data = status == true })
end)

AddEventHandler('hud:Active2', function(status)
    SendNUIMessage({ action = 'ui:setVisible', data = status == true })
end)

AddEventHandler('hud:LogoOnly', function(status)
    SendNUIMessage({ action = 'ui:setVisible', data = status ~= true })
end)

AddEventHandler('hud:Weapon', function(status)
    if Config.DefaultHudSettings.client_info.weapon then
        Config.DefaultHudSettings.client_info.weapon.active = status ~= false
    end
end)

AddEventHandler('hud:Voip', function(mode)
    PlayerData.voiceMode = tonumber(mode) or PlayerData.voiceMode
end)

AddEventHandler('hud:Voice', function(talking)
    PlayerData.talking = talking == true
end)

RegisterCommand('hud', function()
    ExecuteCommand(Config.ToggleSettingsMenu.command or 'hudsettings')
end, false)

function client.GetPlayerData()
    return PlayerData
end

function client.GetPlayerBalance(account)
    if account == 'cash' then
        return tonumber(PlayerData.cash) or 0
    elseif account == 'bank' then
        return tonumber(PlayerData.bank) or 0
    elseif account == 'extra_currency' then
        return tonumber(PlayerData.extra_currency) or 0
    end
    return 0
end

function client.GetPlayerJob()
    return PlayerData.job or { label = 'Civil', grade = 'Sem cargo' }
end

function client.IsPlayerLoaded()
    return LocalPlayer.state.Active == true
end

function client.LoadFirstPlayerData()
    requestServerData()
end
