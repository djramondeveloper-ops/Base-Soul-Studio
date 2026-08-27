-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local CurrentZone = nil
function OpenWeaponShop(internalZone)
    if not Config.ItemShop.Enable then
        return dbg.debug('Weapon shop is disabled!')
    end
    local data, state, statusCode = GetAvailableItemsForGrade(Framework.job.name, Framework.job.grade, Framework.job.isBoss)
    if not state then
        return dbg.critical('Cannot open weapon shop: %s', statusCode)
    end
    local zone = internalZone.getZoneData()
    CurrentZone = zone
    OpenDepartmentStore(data)
end
function RequestGetItemFromStore(order)
    if not order then
        return
    end
    local payload = {
        item = order.name,
        amount = 1,
        paymentMethod = nil
    }
    if Config.ItemShop.PaymentDialog then
        local retval = UI.PayDialog({
            title = _U('WEAPON_SHOP.DIALOG_TITLE', order.label),
            desc = _U('WEAPON_SHOP.DIALOG_DSC'),
            payload = {
                value = order.price
            },
            inputTitle =  _U('WEAPON_SHOP.DIALOG_INPUT_TITLE'),
            showInput = true
        })
        payload.amount = tonumber(retval.input)
        payload.paymentMethod = retval.action
    end
    if not payload.paymentMethod then
        payload.paymentMethod = PAYMENT_METHODS.BANK
    end
    payload.zone = CurrentZone
    CurrentZone = nil
    TriggerServerEvent('rcore_police:server:requestBuyItemFromDepartmentStore', payload)
end
