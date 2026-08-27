-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-reports.lua
--  Engineered by Eazy Fxap
--  Original: 76 lines → Cleaned: 28 lines
-- =====================================================

RegisterNetEvent("rcore_police:client:createReport", function(reportData)
    Reports[#Reports + 1] = reportData
end)

RegisterNetEvent("rcore_police:client:updateReport", function(reportId, reportData)
    if Reports[reportId] then
        Reports[reportId] = reportData
    end
end)

RegisterNetEvent("rcore_police:client:removeReport", function(reportId)
    if not reportId then return end
    if Reports[reportId] then
        table.remove(Reports, reportId)
        UI.SendReactMessage(NUI_EVENTS.REPORTS_REFRESH, Reports)
    end
end)

NetworkService.RegisterNetEvent("SyncReportsForUser", function(success, syncedReports)
    if not success or not syncedReports then return end
    dbg.debug("Syncing reports, since new user loaded.")
    Reports = syncedReports
end)
