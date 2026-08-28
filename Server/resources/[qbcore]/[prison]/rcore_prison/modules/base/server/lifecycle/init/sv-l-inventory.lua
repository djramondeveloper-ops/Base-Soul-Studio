Inventory.KeepSessionItems = {}
Inventory.KeepSessionItemsWithName = {}

CreateThread(function()
    local keepItems = Config.Stash.KeepItems

    if not keepItems then
        if Config.Stash.KeepItemsState then
            Config.Stash.KeepItemsState = false
        end
        return
    end

    for itemName, itemValue in pairs(keepItems) do
        if Config.Inventories == Inventories.ESX then
            Inventory.KeepSessionItems[itemName] = true
        else
            Inventory.KeepSessionItemsWithName[itemName] = itemValue

            if Config.Inventories == Inventories.OX and itemValue == false then
                return
            end

            table.insert(Inventory.KeepSessionItems, itemName)
        end
    end
end)