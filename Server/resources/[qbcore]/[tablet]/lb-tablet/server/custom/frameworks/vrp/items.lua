if Config.Framework ~= "vrp" then return end

function HasItem(source, itemName)
    local id = vRP.Passport(source)
    if not id then return false end
    return (vRP.ItemAmount(id, itemName) or 0) > 0
end

function CreateUsableItem(item, cb)
    -- A vRP desta base usa Execute no config/Item.lua.
    -- O README inclui o bloco para abrir o tablet pelo item.
end

function GetWeaponName(weapon)
    return ItemName and (ItemName(weapon) or weapon) or weapon
end

function GetWeaponImage(weapon)
    local index = ItemIndex and ItemIndex(weapon)
    if not index then return nil end
    return ("https://cfx-nui-inventory/web-side/images/%s.png"):format(index)
end
