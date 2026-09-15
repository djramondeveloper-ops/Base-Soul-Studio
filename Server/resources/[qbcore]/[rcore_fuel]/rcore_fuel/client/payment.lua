--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

-- FIX #11: original condition was `if Config.DisablePaymentModal then` which is
-- inverted — the modal code ran only when the config said it was DISABLED.
-- Corrected to `if not Config.DisablePaymentModal then` so the modal shows
-- when it is enabled (the default: Config.DisablePaymentModal = false).

local receiptGeneration = 0
local receiptTotal = 0

AddEventHandler("rcore_fuel:refuelSummary", function(summary)
    receiptGeneration = receiptGeneration + 1
    if summary.total ~= nil then receiptTotal = tonumber(summary.total) or 0 end
    summary.type = "refuelSummary"
    SendNUIMessage(summary)
end)

AddEventHandler("rcore_fuel:refuelSummaryEnded", function()
    TriggerEvent("rcore_fuel:refuelSummary", receiptTotal > 0
        and { status = "Refill complete — awaiting checkout" } or { visible = false })
end)

local function ReceiptQuantity(liters, fuelType)
    return GetMeasurementUnits(tonumber(liters) or 0, MeasurementTypes.LITERS),
        fuelType and _U(fuelType .. "_unit") or GetMeasurementTypeLabel(MeasurementTypes.LITERS)
end

if not Config.DisablePaymentModal then
    local checkoutOpen = false
    local paymentPending = false
    -- Shows the UI for picking bank/cash.
    -- Receives (cashAvailable: bool, bankAvailable: bool) from server.
    RegisterNetEvent("rcore_fuel:requestPaymentModal", function(cashAvailable, bankAvailable, cost, liters, fuelType)
        if cost ~= nil and cost <= 0 then
            return
        end

        local quantity, unit = ReceiptQuantity(liters, fuelType)
        TriggerEvent("rcore_fuel:refuelSummary", { visible = true, total = cost, liters = quantity,
            unit = unit, status = "Choose cash or bank" })
        paymentPending = false
        if not cashAvailable and not bankAvailable then
            checkoutOpen = false
            SetNuiFocus(false, false)
            SendNUIMessage({ type = "closePayment" })
            TriggerEvent("rcore_fuel:refuelSummary", { status = "Payment due — use /payfuel to retry" })
            ShowNotification(_U("not_enough_money_for_fuel") .. " Use /payfuel to retry payment.")
            return
        end

        checkoutOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            type = "showpaytype",
            cash = cashAvailable,
            bank = bankAvailable,
            total = cost,
            liters = quantity,
            unit = unit,
        })
    end)

    -- Result from the NUI — player chose a payment method
    RegisterNUICallback("payment", function(data, cb)
        if not checkoutOpen or paymentPending or (data.type ~= "cash" and data.type ~= "bank") then
            cb(false)
            return
        end
        paymentPending = true
        SendNUIMessage({ type = "paymentPending" })
        TriggerServerEvent("rcore_fuel:payForFuel", data.type)
        cb(true)
    end)

    RegisterNetEvent("rcore_fuel:paymentComplete", function(cost, liters, fuelType, method)
        checkoutOpen = false
        paymentPending = false
        SetNuiFocus(false, false)
        SendNUIMessage({ type = "closePayment" })
        local quantity, unit = ReceiptQuantity(liters, fuelType)
        TriggerEvent("rcore_fuel:refuelSummary", { visible = true, total = cost, liters = quantity,
            unit = unit, status = "Paid with " .. tostring(method) })
        local generation = receiptGeneration
        SetTimeout(Config.FuelReceiptDisplayDuration or 15000, function()
            if generation == receiptGeneration then SendNUIMessage({ type = "refuelSummary", visible = false }) end
        end)
    end)

    RegisterNetEvent("rcore_fuel:paymentDeferred", function(message)
        if source ~= 65535 then return end
        checkoutOpen = false
        paymentPending = false
        SetNuiFocus(false, false)
        SendNUIMessage({type = "closePayment"})
        ShowNotification(message)
    end)

    RegisterCommand("payfuel", function()
        TriggerServerEvent("rcore_fuel:requestPaymentModal", "fuelPump")
    end, false)

    AddEventHandler("onResourceStop", function(resource)
        if resource == GetCurrentResourceName() and checkoutOpen then SetNuiFocus(false, false) end
    end)
end
