-- Seoul Base bridge for 0r-mapeditor
Bridge = Bridge or {}

-- O AdminControl e a autoridade principal de permissao na Seoul.
-- O ACE fica apenas como fallback caso o resource seja usado fora da base.
function Bridge.HasPermission(src)
    if not src or src <= 0 then
        return false
    end

    if GetResourceState('AdminControl') == 'started' then
        local ok, allowed = pcall(function()
            return exports['AdminControl']:HasPropEditorPermission(src)
        end)

        -- Com o AdminControl ativo, falha fechada: sem export/permissao = sem editor.
        return ok and allowed == true
    end

    local perm = Config.permission
    if not perm or perm == '' then
        return true
    end

    return IsPlayerAceAllowed(src, perm) == true
end

function Bridge.Notify(src, message, type)
    TriggerClientEvent('0r-mapeditor:notify', src, tostring(message or ''), type or 'inform')
end
