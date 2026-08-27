-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-citizen.lua
--  Engineered by Eazy Fxap
--  Original: 41 lines → Cleaned: 16 lines
-- =====================================================

NetworkService.RegisterNetEvent("ShowInvoice", function(success, data)
    if success then
        safeCallFunction(HandleInvoice, MENU_ACTIONS.INVOCE_CITIZEN, data)
    end
end)

NetworkService.RegisterNetEvent("RequestInvoice", function(success, ...)
    if success then
        safeCallFunction(CreateInvoice, "RequestInvoice", ...)
    end
end)
