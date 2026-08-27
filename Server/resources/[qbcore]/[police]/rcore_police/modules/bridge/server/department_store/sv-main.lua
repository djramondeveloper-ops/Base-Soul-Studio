-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function RequestGetItemFromStore(playerId, itemName, paymentMethod, amount)
    if not itemName then
        dbg.debug('Department store: Failed to get item name!')
        return false
    end
    local playerJob = Framework.getJob(playerId)
    if not playerJob then
        dbg.debug('Department store: Failed to get player job!')
        return false
    end
    local playerGroup = playerJob.name
    local playerGrade = playerJob.grade_level or playerJob.grade
    local state = CanAccessItem(playerGroup, playerGrade, itemName)
    if not state then
        dbg.debug('Department store: You dont have access to obtain this item (%s)!', itemName)
        Framework.sendNotification(playerId, _U('WEAPON_SHOP.BUY_WEAPON_FAILED_NOT_ENOUGH_PERMS', itemName), 'success')
        return false
    end
    local order = GetItemStorageData(playerGroup, playerGrade, itemName)
    if not order then
        dbg.debug('Department store: Failed to get item from storage by name: %s', itemName)
        return false
    end
    if not amount then
        amount = 1
    end
    local itemLabel = order.label or ''
    local itemCost = (order.price * amount) or 0
    local ammoMatch = string.match(itemName, "[-_]?ammo[-_]?")
    if itemCost and itemCost <= 0 then
        dbg.debug('Department store: Adding item named %s to player named: %s -> free item!', itemName, GetPlayerName(playerId))
        local state = InventoryService.addItem(playerId, itemName, amount)
        if state then
            AddAmmoToWeapon(playerId, itemName)
            Framework.sendNotification(playerId, _U('WEAPON_SHOP.BUY_WEAPON_SUCCESS', itemLabel), 'success')
        end
        return false
    end
    if ammoMatch then
        if IS_QB[Config.Framework] and Config.Inventory ~= Inventory.OX then
            itemName = Config.ItemShop.AmmoAlias[itemName] 
        end
    end
    if paymentMethod == PAYMENT_METHODS.BANK then
        local playerBankMoney = Framework.getBankMoney(playerId)
        if playerBankMoney >= itemCost then
            local state = InventoryService.addItem(playerId, itemName, amount)
            if state then
                if itemCost and itemCost > 0 then
                    Framework.removeBankMoney(playerId, itemCost)
                end
                dbg.debug('Department store: Adding item named %s to player named: %s payed via bank', itemName, GetPlayerName(playerId))
                AddAmmoToWeapon(playerId, itemName)
                Framework.sendNotification(playerId, _U('WEAPON_SHOP.BUY_WEAPON_SUCCESS', itemLabel), 'success')
            end
        else
            Framework.sendNotification(playerId,
                _U('WEAPON_SHOP.BUY_WEAPON_FAILED_NOT_ENOUGH_BALANCE', itemLabel), 'error')
        end
    else
        local departmentMoney = SocietyService.GetMoney(playerGroup)
        if departmentMoney and departmentMoney >= itemCost then
            local state = InventoryService.addItem(playerId, itemName, amount)
            if state then
                SocietyService.RemoveMoney(playerGroup, itemCost)
                AddAmmoToWeapon(playerId, itemName)
                dbg.debug('Department store: Adding item named %s to player named: %s payed via society', itemName, GetPlayerName(playerId))
                Framework.sendNotification(playerId, _U('WEAPON_SHOP.BUY_WEAPON_SUCCESS', itemLabel), 'success')
            end
        else
            Framework.sendNotification(playerId,
                _U('WEAPON_SHOP.BUY_WEAPON_FAILED_NOT_ENOUGH_BALANCE', itemLabel), 'error')
        end
    end
end
function AddAmmoToWeapon(playerId, itemName)
    itemName = itemName:upper()
    if not (Config.ItemShop.Weapon and Config.ItemShop.Weapon.WhenBuyedWeaponGaveAmmo) then return end
    local match = string.match(itemName, "^WEAPON_")
    if not match then return end
    local ammoItem = Config.ItemShop.Weapon.AmmoToWeapon[itemName]
    if not ammoItem then return end
    if IS_QB[Config.Framework] and Config.Inventory ~= Inventory.OX then
        ammoItem = Config.ItemShop.Weapon.AmmoToWeaponQBCore[itemName] or ammoItem
    end
    if IS_QB[Config.Framework] and Config.Inventory ~= Inventory.OX and Config.ItemShop.AmmoAlias[ammoItem] then
        ammoItem = Config.ItemShop.AmmoAlias[ammoItem]
    end
    local amount = Config.ItemShop.Weapon.WhenBuyedWeaponGaveAmmoAmount or 30
    dbg.debug('Adding ammo for weapon named: %s with amount: %s for player named %s', itemName, amount, GetPlayerName(playerId))
    return InventoryService.addItem(playerId, ammoItem, amount)
end
