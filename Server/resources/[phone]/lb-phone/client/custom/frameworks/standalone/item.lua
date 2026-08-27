if Config.Framework ~= "standalone" then
    return
end

---@param itemName string
---@return boolean
function HasItem(itemName)
    if not Config.Item.Require then return true end
    return AwaitCallback("vrp:hasItem", itemName) == true
end
