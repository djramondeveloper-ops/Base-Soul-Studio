-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if isResourcePresentProvideless("lb-phone") then
        RegisterNetEvent("rcore_police:client:setPhoneState", function(state)
            if source == "" then return end
            if not doesExportExistInResource("lb-phone", "ToggleDisabled") then return end
            exports["lb-phone"]:ToggleDisabled(state)
        end) 
    end
end)
