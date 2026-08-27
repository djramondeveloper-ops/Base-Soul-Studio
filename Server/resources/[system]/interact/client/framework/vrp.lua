-- vRP framework support for interact (groups check via server callback)
local utils = require 'client.modules.utils'

---@diagnostic disable-next-line: duplicate-set-field
function utils.hasPlayerGotGroup(filter)
    if not filter then return true end

    local success, result = pcall(function()
        return lib.callback.await('interact:hasGroup', false, filter)
    end)

    return success and result == true
end
