-- Seoul Base - integração AdminControl > seoul_vinewood

local function hasVinewoodPermission(src)
    src = tonumber(src)
    if not src or src <= 0 then
        return false
    end

    -- Usa primeiro a autoridade do AdminControl atual da Seoul.
    if type(AdminControlCanUse) == "function" then
        local permission = (Config and Config.AdminPermission) or "Admin"
        local ok, allowed = pcall(AdminControlCanUse, src, permission)
        if ok then
            return allowed == true
        end
    end

    -- Fallback para instalações antigas do AdminControl.
    local passport
    if vRP then
        if type(vRP.Passport) == "function" then
            local ok, value = pcall(vRP.Passport, src)
            if ok then passport = value end
        elseif type(vRP.getUserId) == "function" then
            local ok, value = pcall(vRP.getUserId, src)
            if ok then passport = value end
        end
    end

    if not passport then
        return false
    end

    local candidates = {
        (Config and Config.AdminPermission) or "Admin",
        "admin.permissao",
        "Admin"
    }

    local seen = {}
    for i = 1, #candidates do
        local permission = candidates[i]
        if type(permission) == "string" and permission ~= "" and not seen[permission] then
            seen[permission] = true

            if type(vRP.HasPermission) == "function" then
                local ok, allowed = pcall(vRP.HasPermission, passport, permission)
                if ok and allowed then return true end
            end

            if type(vRP.HasGroup) == "function" then
                local ok, allowed = pcall(vRP.HasGroup, passport, permission)
                if ok and allowed then return true end
            end

            if type(vRP.hasPermission) == "function" then
                local ok, allowed = pcall(vRP.hasPermission, passport, permission)
                if ok and allowed then return true end
            end
        end
    end

    return false
end

exports("HasVinewoodPermission", hasVinewoodPermission)

RegisterNetEvent("AdminControl:openVinewood", function()
    local src = source

    if not hasVinewoodPermission(src) then
        TriggerClientEvent("Notify", src, "negado", "Sem permissão para editar o Vinewood.", 5000)
        return
    end

    if GetResourceState("seoul_vinewood") ~= "started" then
        TriggerClientEvent("Notify", src, "negado", "seoul_vinewood não está iniciado.", 5000)
        return
    end

    local ok, opened = pcall(function()
        return exports["seoul_vinewood"]:OpenForPlayer(src)
    end)

    if not ok then
        print(("[AdminControl/Vinewood] Falha ao abrir seoul_vinewood para source %s: %s"):format(src, tostring(opened)))
        TriggerClientEvent("Notify", src, "negado", "Falha interna ao abrir o editor de Vinewood.", 5000)
        return
    end

    if opened ~= true then
        TriggerClientEvent("Notify", src, "negado", "O seoul_vinewood recusou a abertura.", 5000)
    end
end)
