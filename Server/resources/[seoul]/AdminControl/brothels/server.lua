-- Seoul Base - integração AdminControl > seoul_brothels
local function hasBrothelsPermission(src)
    src=tonumber(src)
    if not src or src<=0 then return false end
    if type(AdminControlCanUse)=='function' then
        local ok,allowed=pcall(AdminControlCanUse,src,(Config and Config.AdminPermission) or 'Admin')
        if ok then return allowed==true end
    end
    return false
end

exports('HasBrothelsPermission',hasBrothelsPermission)

RegisterNetEvent('AdminControl:openBrothels',function()
    local src=source
    if not hasBrothelsPermission(src) then
        TriggerClientEvent('Notify',src,'negado','Sem permissão para administrar bordéis.',5000)
        return
    end
    if GetResourceState('seoul_brothels')~='started' then
        TriggerClientEvent('Notify',src,'negado','seoul_brothels não está iniciado.',5000)
        return
    end
    local ok,opened=pcall(function() return exports.seoul_brothels:OpenAdminForPlayer(src) end)
    if not ok or opened~=true then
        TriggerClientEvent('Notify',src,'negado','Falha ao abrir o gerenciador de bordéis.',5000)
    end
end)
