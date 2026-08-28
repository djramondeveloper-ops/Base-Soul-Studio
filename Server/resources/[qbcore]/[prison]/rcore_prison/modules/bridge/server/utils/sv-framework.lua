--- Build a short player tag for debug logs
---@param client number Player server ID
---@return string tag e.g. "(2) 'John Doe'"
function PlayerTag(client)
    local name = Framework.getCharacterName(client) or GetPlayerName(client) or "unknown"
    return sprint("(%s) '%s'", client, name)
end
