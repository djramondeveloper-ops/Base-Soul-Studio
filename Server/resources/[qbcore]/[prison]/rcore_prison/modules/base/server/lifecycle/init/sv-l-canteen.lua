local registerNetEvent = EventLimiterService.RegisterNetEvent
local eventName = "rcore_prison:server:requestCanteenTransaction"

local function requestCanteenTransaction(playerSource, isAllowed, requestData)
    if not isAllowed then
        return
    end

    local prisoner = PrisonService.getPlayer(playerSource)
    if not prisoner then
        Framework.sendNotification(playerSource, _U("GENERAL.YOU_ARE_NOT_PRISONER"), "error")
        return dbg.debug(
            "Canteen: Requested transaction failed, since player: %s (%s) is not prisoner.",
            playerSource,
            GetPlayerName(playerSource)
        )
    end

    local shopType = requestData.shopType
    local itemData = requestData.items

    if shopType == "free" then
        CanteenService.GetFreeFoodPackage(playerSource)
        return
    end

    if shopType ~= "paid" then
        return
    end

    local prisonAccount = PrisonAccountService.getPlayer(playerSource)
    if not prisonAccount then
        Framework.sendNotification(playerSource, _U("GENERAL.YOU_DONT_HAVE_PRISONER_ACCOUNT"), "error")
        return dbg.debug(
            "Canteen: Requested transaction failed, since player: %s (%s) does not have a prison account.",
            playerSource,
            GetPlayerName(playerSource)
        )
    end

    local itemId = itemData.id
    local amount = itemData.amount

    if amount <= 0 then
        Framework.sendNotification(playerSource, _U("GENERAL.INVALID_ITEM_AMOUNT"), "error")
        return dbg.debug(
            "Canteen: Requested transaction failed, since player: %s (%s) has invalid item amount.",
            playerSource,
            GetPlayerName(playerSource)
        )
    end

    local canteenItem = Config.Canteen.CreditItems[itemId]
    if not canteenItem then
        Framework.sendNotification(playerSource, _U("GENERAL.ITEM_NOT_FOUND", tostring(itemId)), "error")
        return dbg.debug(
            "Canteen: Requested transaction failed, since player: %s (%s) requested invalid item id %s.",
            playerSource,
            GetPlayerName(playerSource),
            tostring(itemId)
        )
    end

    local totalPrice = canteenItem.price * amount

    if not Inventory.DoesItemExist(canteenItem.name, playerSource) then
        Framework.sendNotification(playerSource, _U("GENERAL.ITEM_NOT_FOUND", canteenItem.name), "error")
        return dbg.debug(
            "Canteen: Requested transaction failed, since player requested: %s (%s) item doesnt exist %s.",
            playerSource,
            GetPlayerName(playerSource),
            canteenItem.name
        )
    end

    if totalPrice > prisonAccount.balance then
        Framework.sendNotification(playerSource, _U("CANTEEN.NOT_ENOUGH_CREDITS", canteenItem.price), "error")
        return
    end

    prisonAccount.balance = prisonAccount.balance - totalPrice

    Inventory.addItem(playerSource, canteenItem.name, amount)
    Logs.BuyItemCanteen(playerSource, canteenItem, amount, totalPrice)

    dbg.debug(
        "Canteen: Requested transaction for player: %s (%s) with item: %s, amount: %s, price: %s.",
        playerSource,
        GetPlayerName(playerSource),
        canteenItem.name,
        amount,
        totalPrice
    )

    Framework.sendNotification(
        playerSource,
        _U("CANTEEN.BOUGHT_ITEM", canteenItem.name, totalPrice),
        "success"
    )

    AccountLogService.RegisterTransaction(
        _U("CANTEEN.TITLE"),
        _U("CANTEEN.BOUGHT_ITEM", canteenItem.name, totalPrice),
        Framework.getIdentifier(playerSource),
        -totalPrice
    )

    StartClient(playerSource, "UpdatePrisonerAccount", prisonAccount)
end

registerNetEvent(eventName, 0, 1, requestCanteenTransaction)