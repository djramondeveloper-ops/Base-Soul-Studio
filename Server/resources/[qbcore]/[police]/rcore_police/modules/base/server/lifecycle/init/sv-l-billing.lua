-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-billing.lua
--  Engineered by Eazy Fxap
--  Original: 32 lines → Cleaned: 10 lines
-- =====================================================

RegisterNetEvent("rcore_police:server:createInvoice", function(targetSrc, amount)
    local src = source
    if not targetSrc or not amount then return end
    
    safeCallFunction(CreateInvoice, "CREATE_INVOICE", src, targetSrc, amount)
end)
