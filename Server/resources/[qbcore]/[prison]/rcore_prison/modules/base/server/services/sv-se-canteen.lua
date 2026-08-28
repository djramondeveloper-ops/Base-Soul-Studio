CanteenService = CanteenService or {}

local function getCanteenStorage()
    return Object.getStorage(STORAGE_CANTEEN)
end

function CanteenService.GetFreeFoodPackage(source)
    if not Config.Canteen.FreeFoodPackage then
        return
    end

    local canteenStorage = getCanteenStorage()
    if not canteenStorage then
        return
    end

    if canteenStorage.isSessionRegistered(source) then
        return Framework.sendNotification(
            source,
            _U("CANTEEN.FREE_FOOD_PACKAGE_RECEIVED"),
            "error"
        )
    end

    local packageItems = Config.Canteen.FreeFoodPackageItems
    if not packageItems then
        return
    end

    Logs.FreePackageCanteen(source)
    canteenStorage.registerSession(source)

    pcall(function()
        return Inventory.addMultipleItems(source, packageItems)
    end)

    Framework.sendNotification(
        source,
        _U("CANTEEN.FREE_FOOD_PACKAGE_RECEIVED_SUCCESS"),
        "success"
    )
end

function CanteenService.ShowOffer(source)
end
