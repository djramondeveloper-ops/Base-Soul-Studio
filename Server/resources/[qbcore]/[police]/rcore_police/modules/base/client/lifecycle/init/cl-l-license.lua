-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-license.lua
--  Engineered by Eazy Fxap
--  Original: 26 lines → Cleaned: 11 lines
-- =====================================================

NetworkService.RegisterNetEvent("ShowPlayerLicense", function(success, licenseData)
    if success then
        safeCallFunction(ShowPlayerLicense, "SHOW_PLAYER_LICENSE", licenseData)
    end
end)
