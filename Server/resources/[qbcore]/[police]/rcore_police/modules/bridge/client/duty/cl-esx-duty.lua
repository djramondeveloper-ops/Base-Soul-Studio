-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



NetworkService.RegisterNetEvent('HandleESXService', function(validRequest, jobName)
    if validRequest then
        if Config.Duty == Duty.ESX_SERVICE then
            HandleServiceDuty(jobName)
        else
            dbg.debug('Failed to find any duty resource!')
        end
    end
end)
function HandleServiceDuty(jobName)
    Framework.object.TriggerServerCallback('esx_service:isInService', function(isInService)
        if isInService then
            SetOffService(jobName)
        else
            SetActiveService(jobName)
        end
    end, jobName)
end
function SetOffService(jobName)
    local notification = {
        title    = _U('DUTY.TITLE'),
        subject  = '',
        msg      = _U('DUTY.ON_DUTY_SERVICE_MSG'),
        iconType = 1
    }
    TriggerServerEvent('esx_service:notifyAllInService', notification, jobName)
    TriggerServerEvent('esx_service:disableService', jobName)
    Framework.sendNotification(_U('DUTY.YOU_ARE_OFF_SERVICE'), 'success')
end
function SetActiveService(jobName)
    Framework.object.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
        local notification = {
            title    = _U('DUTY.TITLE'),
            subject  = '',
            msg      = _U('DUTY.OFF_DUTY_SERVICE_MSG'),
            iconType = 1
        }
        TriggerServerEvent('esx_service:notifyAllInService', notification, jobName)
        Framework.sendNotification(_U('DUTY.YOU_ARE_IN_SERVICE'), 'success')
    end, jobName)
end
