-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()    
    function getPoliceCount()
        return GroupsService.GetAllDeparmentsCount()
    end
    provideExport('getPoliceOnline', PoliceResources.WASABI, getPoliceCount)
end)
