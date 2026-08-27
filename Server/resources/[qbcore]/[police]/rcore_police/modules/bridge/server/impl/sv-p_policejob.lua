-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()    
    local function ForceUncuff(target)
        ActionService.ForceUncuff(target)
    end
    provideExport('forceUncuff', PoliceResources.P, ForceUncuff)
end)
