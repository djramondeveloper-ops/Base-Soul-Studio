-- Seoul Base - integracao AdminControl > Prop Editor
-- Usa a autoridade de permissao do proprio AdminControl atual da Seoul.

local function hasPropEditorPermission(src)
    src = tonumber(src)
    if not src or src <= 0 then
        return false
    end

    -- Caminho oficial da Seoul/AdminControl atual.
    if type(AdminControlCanUse) == "function" then
        local permission = (Config and Config.AdminPermission) or "Admin"
        local ok, allowed = pcall(AdminControlCanUse, src, permission)
        if ok then
            return allowed == true
        end
    end

    -- Fallback defensivo para instalacoes antigas do AdminControl.
    local passport
    if vRP then
        if type(vRP.Passport) == "function" then
            passport = vRP.Passport(src)
        elseif type(vRP.getUserId) == "function" then
            passport = vRP.getUserId(src)
        end
    end

    if not passport then
        return false
    end

    local permission = (Config and Config.AdminPermission) or "Admin"

    if type(vRP.HasPermission) == "function" and vRP.HasPermission(passport, permission) then
        return true
    end

    if type(vRP.HasGroup) == "function" and vRP.HasGroup(passport, permission) then
        return true
    end

    if type(vRP.hasPermission) == "function" and vRP.hasPermission(passport, permission) then
        return true
    end

    return false
end

exports("HasPropEditorPermission", hasPropEditorPermission)

RegisterNetEvent("AdminControl:openPropEditor", function()
    local src = source

    if not hasPropEditorPermission(src) then
        TriggerClientEvent("Notify", src, "negado", "Sem permissão para abrir o Prop Editor.", 5000)
        return
    end

    if GetResourceState("0r-mapeditor") ~= "started" then
        TriggerClientEvent("Notify", src, "negado", "Prop Editor não está iniciado.", 5000)
        return
    end

    local ok, opened = pcall(function()
        return exports["0r-mapeditor"]:OpenForPlayer(src)
    end)

    if not ok then
        print(("[AdminControl/PropEditor] Falha ao chamar 0r-mapeditor para source %s: %s"):format(src, tostring(opened)))
        TriggerClientEvent("Notify", src, "negado", "Falha interna ao abrir o Prop Editor. Verifique o console.", 5000)
        return
    end

    if opened ~= true then
        TriggerClientEvent("Notify", src, "negado", "O Prop Editor recusou a abertura.", 5000)
    end
end)
