-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.MDT == MDT.TK then
        local JobPages = {
            ['police'] = 'police',
            ['ambulance'] = 'ambulance',
        }
        function GetPageByJob()
            local job = Framework.job
            if job and job.name and JobPages[job.name:lower()] then
                return JobPages[job.name:lower()]
            end
            return nil
        end
            -- Event handler for opening the MDT (Mobile Data Terminal).
            -- This event is triggered when 'rcore_police:client:showMDT' is fired.
        AddEventHandler('rcore_police:client:showMDT', function()
            local currentPage = GetPageByJob()
            if currentPage then
                exports.tk_mdt:openUI(currentPage)
            end
        end)
    end
end)

