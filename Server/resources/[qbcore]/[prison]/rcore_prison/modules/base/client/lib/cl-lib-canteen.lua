Canteen = type(_G.Canteen) == 'table' and _G.Canteen or {}

function Canteen.RequestOpen()
    FrontendService.HandleFocus(true)
    FrontendService.SendReactMessage(FE_EVENTS.LOAD_APP, {
        screen = "Canteen",
        visible = true
    })
end

RegisterNuiCallback("proceedCanteenTransaction", function(transactionData, cb)
    cb("OK")
    TriggerServerEvent("rcore_prison:server:requestCanteenTransaction", transactionData)
end)

RegisterNuiCallback("getCanteen", function(_, cb)
    dbg.debug("Fetching canteen data to FE!")

    cb({
        free = Config.Canteen.FreeFoodPackageItems,
        paid = Config.Canteen.CreditItems
    })
end)