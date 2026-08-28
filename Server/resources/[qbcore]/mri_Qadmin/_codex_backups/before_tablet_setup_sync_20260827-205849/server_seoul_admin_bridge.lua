-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL ADMIN TABLET PERMISSION GATE
-- Fonte de verdade de acesso: grupo vRP/Seoul "Admin".
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulQAdminStrictAdminGate = true

local function getCore()
    return SeoulQAdminGetCoreObject()
end

local function getPlayer(source)
    local core = getCore()
    if core and core.Functions and core.Functions.GetPlayer then
        local ok, player = pcall(core.Functions.GetPlayer, tonumber(source))
        if ok then return player end
    end
end

function SeoulQAdminHasAdminGroup(source)
    source = tonumber(source or 0) or 0
    if source <= 0 then return true end

    local core = getCore()

    if core and core.Functions and core.Functions.HasPermission then
        local checks = { 'Admin', 'admin', 'Administrador', 'admin.permissao' }
        for _, permission in ipairs(checks) do
            local ok, allowed = pcall(core.Functions.HasPermission, source, permission)
            if ok and allowed then return true end
        end
    end

    local player = getPlayer(source)
    local data = player and player.PlayerData
    local groups = data and data.groups
    if type(groups) == 'table' then
        if groups.Admin or groups.admin or groups.Administrador then return true end
        for name, _ in pairs(groups) do
            if tostring(name):lower() == 'admin' then return true end
        end
    end

    return false
end

local function notifyDenied(source)
    source = tonumber(source or 0) or 0
    if source > 0 then
        TriggerClientEvent('Notify', source, 'vermelho', 'Acesso negado. Apenas o grupo Admin pode usar o Seoul Admin.', 5000)
    end
end

lib.callback.register('mri_Qadmin:seoul:canAccess', function(source)
    return SeoulQAdminHasAdminGroup(source)
end)

RegisterNetEvent('mri_Qadmin:seoul:requestOpenFromTablet', function()
    local src = source
    if not SeoulQAdminHasAdminGroup(src) then
        notifyDenied(src)
        return
    end
    TriggerClientEvent('mri_Qadmin:client:SetupPanel', src)
end)

print('^2[Seoul Admin]^7 Gate ativo: acesso liberado somente para grupo ^3Admin^7.')
