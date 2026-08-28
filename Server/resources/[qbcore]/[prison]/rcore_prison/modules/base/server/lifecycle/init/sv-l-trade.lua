EventLimiterService.RegisterNetEvent("rcore_prison:server:requestBuyDealerItem", 0, 1, function(playerSource, isAllowed, purchaseData, interactionId)
    if not isAllowed then
        return
    end

    local prisoner = PrisonService.getPlayer(playerSource)
    if not prisoner then
        Framework.sendNotification(playerSource, _U("GENERAL.YOU_ARE_NOT_PRISONER"), "error")

        return dbg.debug(
            "Trade: Requested transaction failed, since player: %s (%s) is not prisoner.",
            playerSource,
            GetPlayerName(playerSource)
        )
    end

    local itemId = purchaseData.id
    local itemAmount = purchaseData.amount

    if itemAmount <= 0 then
        Framework.sendNotification(playerSource, _U("GENERAL.INVALID_ITEM_AMOUNT"), "error")

        return dbg.debug(
            "Trade: Requested transaction failed, since player: %s (%s) has invalid item amount.",
            playerSource,
            GetPlayerName(playerSource)
        )
    end

    local interactionData = SH.data.interaction[interactionId]
    local dealerItem = interactionData and interactionData.items and interactionData.items[itemId]
    if not dealerItem then
        return
    end

    if dealerItem.name and not Inventory.DoesItemExist(dealerItem.name, playerSource) then
        Framework.sendNotification(playerSource, _U("DEALER.NO_ECONOMY_ITEM"), "error")

        return dbg.debug(
            "Trade: Requested transaction failed, for player named %s (%s) | this item is not defined: [%s]!",
            playerSource,
            GetPlayerName(playerSource),
            dealerItem.name
        )
    end

    local totalPrice = dealerItem.price * itemAmount

    dbg.debug(
        "Trade: Checking if player has %s amount of %s in his inventory | %s %s",
        totalPrice,
        Config.EconomyItem,
        playerSource,
        GetPlayerName(playerSource)
    )

    if Inventory.hasItem(playerSource, Config.EconomyItem, totalPrice) then
        dbg.debug(
            "Trade: Requested transaction proceed since player has %s amount of %s in his inventory | %s %s",
            totalPrice,
            Config.EconomyItem,
            playerSource,
            GetPlayerName(playerSource)
        )

        Inventory.removeItem(playerSource, Config.EconomyItem, totalPrice)
        Inventory.addItem(playerSource, dealerItem.name, itemAmount)

        Framework.sendNotification(
            playerSource,
            _U(
                "DEALER.BOUGHT_ITEM",
                dealerItem.label or dealerItem.name,
                itemAmount,
                totalPrice,
                Config.EconomyItem
            ),
            "success"
        )
    else
        Framework.sendNotification(
            playerSource,
            _U("DEALER.NOT_ENOUGH_ITEM", totalPrice, Config.EconomyItem),
            "error"
        )
    end
end)
