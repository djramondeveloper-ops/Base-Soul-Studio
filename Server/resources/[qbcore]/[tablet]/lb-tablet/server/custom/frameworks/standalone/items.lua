if Config.Framework ~= "standalone" then
    return
end

function HasItem(source, itemName)
    if GetResourceState("ox_inventory") == "started" then
        return (exports.ox_inventory:Search(source, "count", itemName) or 0) > 0
    end

    return true
end

function CreateUsableItem(item, cb)
end

function GetWeaponName(weapon)
    if not Weapons then
        return
    end

    for i = 1, #Weapons do
        if Weapons[i].model == weapon then
            return Weapons[i].label
        end
    end
end

function GetWeaponImage(weapon)
    weapon = weapon:upper()

    if GetResourceState("ox_inventory") == "started" then
        local fileName = "web/images/" .. weapon .. ".png"
        local fileExists = LoadResourceFile("ox_inventory", fileName)

        if fileExists then
            return "https://cfx-nui-ox_inventory/" .. fileName
        end
    end
end
