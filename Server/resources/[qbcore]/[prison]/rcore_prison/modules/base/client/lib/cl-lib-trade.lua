Trade = type(_G.Trade) == 'table' and _G.Trade or {}

function Trade.Open()
    HelpKeys.Hide()
    FrontendService.HandleFocus(true)

    FrontendService.SendReactMessage(FE_EVENTS.LOAD_APP, {
        screen = Screens.TRADING,
        visible = true,
    })
end

RegisterNuiCallback("buyItem", function(data, cb)
    TriggerServerEvent("rcore_prison:server:requestBuyDealerItem", data, SH.zoneId)
    cb(true)
end)

RegisterNuiCallback("getTradeItems", function(_, cb)
    if not SH.zoneId then
        return
    end

    local interaction = SH.data.interaction[SH.zoneId]
    if not interaction then
        return
    end

    cb(interaction.items)
end)