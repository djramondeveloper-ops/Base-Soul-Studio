-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMIN RUNTIME HELPERS
-- Camada de adaptação do MRI QAdmin para grupos/skin/dinheiro reais da Seoul Base.
-- Tudo aqui valida Admin pelo gate global já existente e usa tabelas reais: permissions/entitydata/characters.
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulQAdminRuntime = SeoulQAdminRuntime or {}

local function notify(src, msg, ntype)
    if src and tonumber(src) and tonumber(src) > 0 then
        QBCore.Functions.Notify(tonumber(src), msg, ntype or 'primary', 5000)
    else
        print(('^3[Seoul Admin]^7 %s'):format(tostring(msg)))
    end
end

local function getPassportFromSource(src)
    src = tonumber(src or 0) or 0
    local Player = QBCore.Functions.GetPlayer(src)
    if Player and Player.PlayerData and Player.PlayerData.citizenid then
        return tonumber(Player.PlayerData.citizenid)
    end
    return nil
end

local function callCoreFunction(name, ...)
    local core = SeoulQAdminGetCoreObject()
    local fn = core and core.Functions and core.Functions[name]
    if type(fn) ~= 'function' then return false end
    local ok, result = pcall(fn, ...)
    if not ok then
        print(('^1[Seoul Admin]^7 Falha em QBCore.Functions.%s: %s'):format(name, tostring(result)))
        return false
    end
    return result ~= false
end

local vRPDirect
local function getVrp()
    if vRPDirect then return vRPDirect end
    if type(module) == 'function' then
        local ok, Proxy = pcall(module, 'vrp', 'lib/Proxy')
        if ok and Proxy and type(Proxy.getInterface) == 'function' then
            local ok2, iface = pcall(Proxy.getInterface, 'vRP')
            if ok2 and iface then vRPDirect = iface end
        end
    end
    return vRPDirect
end

local function getPassportFromAny(value)
    local n = tonumber(value or 0) or 0
    if n <= 0 then return nil end
    local Player = QBCore.Functions.GetPlayer(n)
    if Player and Player.PlayerData and Player.PlayerData.citizenid then
        return tonumber(Player.PlayerData.citizenid)
    end
    local vRP = getVrp()
    if vRP and type(vRP.Passport) == 'function' then
        local ok, passport = pcall(vRP.Passport, n)
        if ok and passport then return tonumber(passport) end
    end
    return n
end

function SeoulQAdminRuntime.GetPassportFromSource(src)
    return getPassportFromAny(src)
end

local function normalizeVitalsTable(dt, ped, metadata)
    dt = type(dt) == 'table' and dt or {}
    metadata = type(metadata) == 'table' and metadata or {}
    local health = ped and ped ~= 0 and GetEntityHealth(ped) or tonumber(dt.Health or metadata.health) or 100
    local armor = ped and ped ~= 0 and GetPedArmour(ped) or tonumber(dt.Armour or dt.Armor or metadata.armor) or 0
    local hunger = tonumber(dt.Hunger or dt.hunger or metadata.Hunger or metadata.hunger) or 100
    local thirst = tonumber(dt.Thirst or dt.thirst or metadata.Thirst or metadata.thirst) or 100
    local stress = tonumber(dt.Stress or dt.stress or metadata.Stress or metadata.stress) or 0
    return {
        health = health,
        armor = armor,
        hunger = hunger,
        thirst = thirst,
        stress = stress,
        isdead = dt.isdead or dt.IsDead or metadata.isdead or metadata.IsDead or false
    }
end

function SeoulQAdminRuntime.GetVitalsForSource(src, fallbackMetadata)
    src = tonumber(src or 0) or 0
    local ped = src > 0 and GetPlayerPed(src) or 0
    local passport = getPassportFromAny(src)
    local dt
    local vRP = getVrp()
    if vRP and passport and type(vRP.Datatable) == 'function' then
        local ok, result = pcall(vRP.Datatable, passport)
        if ok then dt = result end
    end
    return normalizeVitalsTable(dt, ped, fallbackMetadata)
end

function SeoulQAdminRuntime.NormalizeMetadataForSource(src, metadata)
    local result = {}
    if type(metadata) == 'table' then
        for k, v in pairs(metadata) do result[k] = v end
    end
    local vitals = SeoulQAdminRuntime.GetVitalsForSource(src, result)
    result.health = vitals.health
    result.armor = vitals.armor
    result.hunger = vitals.hunger
    result.thirst = vitals.thirst
    result.stress = vitals.stress
    result.isdead = vitals.isdead
    result.Health = vitals.health
    result.Armour = vitals.armor
    result.Hunger = vitals.hunger
    result.Thirst = vitals.thirst
    result.Stress = vitals.stress
    return result
end

function SeoulQAdminRuntime.SetVital(target, vital, value)
    target = tonumber(target or 0) or 0
    value = tonumber(value)
    if target <= 0 or not value then return false end
    local passport = getPassportFromAny(target)
    local vRP = getVrp()
    local dt
    if vRP and passport and type(vRP.Datatable) == 'function' then
        local ok, result = pcall(vRP.Datatable, passport)
        if ok and type(result) == 'table' then dt = result end
    end

    if vital == 'health' then
        TriggerClientEvent('mri_Qadmin:client:SetHealth', target, value)
        if dt then dt.Health = value end
        return true
    elseif vital == 'armor' then
        SetPedArmour(GetPlayerPed(target), value)
        if dt then dt.Armour = value end
        return true
    elseif vital == 'hunger' then
        if dt then dt.Hunger = value end
        TriggerClientEvent('hud:Hunger', target, value)
        return true
    elseif vital == 'thirst' then
        if dt then dt.Thirst = value end
        TriggerClientEvent('hud:Thirst', target, value)
        return true
    elseif vital == 'stress' then
        if dt then dt.Stress = value end
        TriggerClientEvent('hud:Stress', target, value)
        return true
    end

    return false
end

function SeoulQAdminRuntime.Revive(target, health)
    target = tonumber(target or 0) or 0
    if target <= 0 then return false end
    local vRP = getVrp()
    if vRP and type(vRP.Revive) == 'function' then
        local ok = pcall(vRP.Revive, target, health or 150)
        if ok then return true end
    end
    TriggerClientEvent('hospital:client:Revive', target)
    TriggerClientEvent('qbx_medical:client:revive', target)
    TriggerClientEvent('QBCore:Client:Revive', target)
    TriggerClientEvent('mri_Qadmin:client:SetHealth', target, health or 150)
    return true
end

local SeoulWeatherTypes = {
    BLIZZARD=true, CLEAR=true, CLEARING=true, CLOUDS=true, EXTRASUNNY=true,
    FOGGY=true, HALLOWEEN=true, NEUTRAL=true, OVERCAST=true, RAIN=true,
    SMOG=true, SNOW=true, SNOWLIGHT=true, THUNDER=true, XMAS=true
}

function SeoulQAdminRuntime.SetWeather(weather)
    weather = tostring(weather or ''):upper()
    if weather == 'EXTRASOLARADO' then weather = 'EXTRASUNNY' end
    if weather == 'EXTRASUNNY' or SeoulWeatherTypes[weather] then
        GlobalState.Weather = weather
        return true, weather
    end
    return false, weather
end

function SeoulQAdminRuntime.SetTime(hour, minute)
    hour = tonumber(hour)
    minute = tonumber(minute) or 0
    if not hour then return false end
    hour = math.max(0, math.min(23, math.floor(hour)))
    minute = math.max(0, math.min(59, math.floor(minute)))
    GlobalState.Hours = hour
    GlobalState.Minutes = minute
    return true, hour, minute
end

function SeoulQAdminRuntime.SetBlackout(state)
    if state == nil then
        state = not (GlobalState.SeoulAdminBlackout == true)
    end
    state = state and true or false
    GlobalState.SeoulAdminBlackout = state
    TriggerClientEvent('mri_Qadmin:client:SeoulBlackout', -1, state)
    return state
end

function SeoulQAdminRuntime.SetPermission(passport, permission, level)
    passport = tonumber(passport)
    permission = tostring(permission or '')
    level = tonumber(level) or 1
    if not passport or permission == '' then return false end

    local src = QBCore.Functions.GetSource and QBCore.Functions.GetSource(tostring(passport)) or nil
    local Player = QBCore.Functions.GetPlayerByCitizenId and QBCore.Functions.GetPlayerByCitizenId(tostring(passport)) or nil
    if Player and Player.Functions and type(Player.Functions.SetJob) == 'function' then
        -- O adapter QBCore da Seoul usa SetJob como wrapper de vRP.SetPermission(Passport, group, level).
        local ok = pcall(function()
            Player.Functions.SetJob(permission, level)
            if Player.Functions.Save then Player.Functions.Save() end
        end)
        if ok then return true end
    end

    -- Fallback para offline ou quando o adapter não está disponível no runtime.
    return SeoulQAdminDB.SetPermission(passport, permission, level)
end

function SeoulQAdminRuntime.RemovePermission(passport, permission)
    passport = tonumber(passport)
    permission = tostring(permission or '')
    if not passport or permission == '' then return false end

    -- Se o vRP/QBCore adapter expuser RemovePermission no futuro, usa. Caso contrário, cai no DB real.
    local removed = callCoreFunction('RemoveSeoulPermission', passport, permission)
    if removed then return true end
    return SeoulQAdminDB.RemovePermission(passport, permission)
end

function SeoulQAdminRuntime.SetCharacterGroups(passport, groupsArray)
    passport = tonumber(passport)
    if not passport then return false, 'Passaporte inválido.' end
    if type(groupsArray) ~= 'table' then groupsArray = {} end

    local desired = {}
    for _, value in ipairs(groupsArray) do
        local groupName, level
        if type(value) == 'table' then
            groupName = value.name or value.id or value.group or value.group_id or value.value
            level = value.level or value.grade or value.rank or 1
        else
            groupName = tostring(value)
            level = 1
        end
        groupName = tostring(groupName or '')
        if groupName ~= '' then desired[groupName] = tonumber(level) or 1 end
    end

    local current = SeoulQAdminDB.GetCharacterPermissionNames(passport)
    for groupName, _ in pairs(current) do
        if not desired[groupName] then SeoulQAdminRuntime.RemovePermission(passport, groupName) end
    end
    for groupName, level in pairs(desired) do
        SeoulQAdminRuntime.SetPermission(passport, groupName, level)
    end

    local Player = QBCore.Functions.GetPlayerByCitizenId and QBCore.Functions.GetPlayerByCitizenId(tostring(passport)) or nil
    if Player and Player.Functions and Player.Functions.UpdatePlayerData then
        pcall(Player.Functions.UpdatePlayerData)
    end

    return true
end

function SeoulQAdminRuntime.OpenClothingFor(src, target)
    src = tonumber(src or 0) or 0
    target = tonumber(target or 0) or 0
    if target <= 0 then return false, 'Jogador inválido.' end

    if GetResourceState('nation_skinshop') == 'started' then
        TriggerClientEvent('skinshop:Open', target)
        return true
    end
    if GetResourceState('illenium-appearance') == 'started' then
        TriggerClientEvent('illenium-appearance:client:openClothingShopMenu', target, true)
        return true
    end
    if GetResourceState('qb-clothing') == 'started' then
        TriggerClientEvent('qb-clothing:client:openMenu', target)
        return true
    end
    return false, 'Nenhum sistema de roupas compatível está iniciado.'
end

print('^2[Seoul Admin]^7 Runtime Seoul carregado: grupos/skin/vitals/clima/comando externo prontos.')

AddEventHandler('mri_Qadmin:db:ready', function()
    CreateThread(function()
        Wait(500)
        local names = SeoulQAdminDB.GetAllPermissionNames()
        for _, groupName in ipairs(names) do
            MySQL.insert.await('INSERT IGNORE INTO mri_qadmin_groups (id, label, description) VALUES (?, ?, ?)', {
                groupName,
                groupName,
                'Grupo real sincronizado da Seoul/vRP.'
            })
        end
        print(('^2[Seoul Admin]^7 Grupos reais da Seoul sincronizados no painel: %d.'):format(#names))
    end)
end)
