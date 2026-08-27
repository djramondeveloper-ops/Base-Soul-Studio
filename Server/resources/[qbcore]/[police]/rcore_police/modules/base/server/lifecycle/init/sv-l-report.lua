-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-report.lua
--  Engineered by Eazy Fxap
--  Original: 346 lines → Cleaned: 111 lines
-- =====================================================

local Reports = {}
local ReportsCooldown = {}

AddEventHandler("rcore_police:server:databaseReady", function()
    Wait(1000)
    Reports = db.GetAllReports()
    dbg.debug("Loaded total reports: %s", table.size(Reports))
    
    if next(Reports) then
        StartClient(-1, "SyncReportsForUser", Reports)
    end
end)

AddEventHandler("rcore_police:server:playerLoaded", function(src)
    if not src then return end
    
    if next(Reports) then
        StartClient(src, "SyncReportsForUser", Reports)
    end
end)

AddEventHandler("rcore_police:server:playerUnloaded", function(src)
    if not src then return end
    
    if ReportsCooldown[src] then
        ReportsCooldown[src] = nil
    end
end)

RegisterNetEvent("rcore_police:server:requestDeleteReport", function(reportId)
    local src = source
    local isMember = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then return end
    
    if Reports[reportId] then
        Framework.sendNotification(src, _U("REPORTS.PLAYER_DELETED_REPORT"), "success")
        table.remove(Reports, reportId)
        db.DeleteReport(reportId)
        
        SetTimeout(500, function()
            StartClient(-1, "removeReport", reportId)
        end)
    end
end)

RegisterNetEvent("rcore_police:server:requestSaveReport", function(data)
    local src = source
    local isMember, group = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember or not group then return end
    
    local reportId = data.reportId
    local status = data.status
    local note = data.note
    
    if Reports[reportId] then
        if Reports[reportId].note == note and Reports[reportId].status == status then
            return
        end
        
        Reports[reportId].note = note
        Reports[reportId].status = status
        
        db.UpdateReportNote(reportId, note)
        db.UpdateReportStatus(reportId, status)
        
        if group then
            if Config.Reports["NotifyAllDepartmentOfficersWhenUpdatedReport"] then
                local groupObj = GroupsService.GetGroupByName(group.group)
                local msg = _U("REPORTS.OFFICER_UPDATED_REPORT_STATUS", reportId, status, Framework.getCharacterShortName(src))
                if groupObj then
                    groupObj.Notify(msg)
                end
            end
        end
        
        StartClient(-1, "updateReport", reportId, Reports[reportId])
    end
end)

RegisterNetEvent("rcore_police:server:sendReport", function(zoneId, reportData)
    local src = source
    if not UtilsService.IsPlayerAtInteract(src, zoneId) then return end
    if not reportData then return end
    if not Config.Reports.Enable then return end
    
    if ReportsCooldown[src] then
        return Framework.sendNotification(src, _U("REPORTS.PLAYER_REACHED_MAXIMUM_OPEN_REPORT"), "error")
    end
    
    if not reportData.status then
        reportData.status = REPORT_STATES.NEW_REPORT
    end
    
    if Config.Reports.LimitReportsPerPlayer then
        ReportsCooldown[src] = true
        SetTimeout(Config.Reports.CooldownResetPerPlayer * 60 * 1000, function()
            if ReportsCooldown[src] then
                ReportsCooldown[src] = nil
            end
        end)
    end
    
    local zoneJob = UtilsService.GetZoneJob(zoneId)
    local targetJob = nil
    
    if type(zoneJob) == "table" then
        for _, jobName in pairs(zoneJob) do
            if targetJob and targetJob.name == jobName then
                targetJob = jobName
            end
        end
    elseif targetJob and targetJob.name == zoneJob then
        targetJob = targetJob.name
    end
    
    local groupObj = GroupsService.GetGroupByName(targetJob)
    local msg = _U("REPORTS.RECEIVED_NEW_REPORT_OFFICERS")
    if groupObj and Config.Reports.NotifyAllDepartmentOfficersWhenNewReport then
        groupObj.Notify(msg)
    end
    
    table.insert(Reports, reportData)
    db.InsertReport(reportData.status, reportData.message, reportData.player, reportData.phone)
    
    Framework.sendNotification(src, _U("REPORTS.PLAYER_SUBMITTED_REPORT"), "success")
    StartClient(-1, "createReport", reportData)
end)
