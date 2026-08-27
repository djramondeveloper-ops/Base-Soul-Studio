-- =====================================================
--  rcore_police · modules/base/client/lib/nui/cl-lib-bossmenu.lua
--  Engineered by Eazy Fxap
--  Original: 143 lines → Cleaned: 50 lines
-- =====================================================

RegisterNuiCallback(NUI_EVENTS.BOSS_MENU_REQUEST_ACTION, function(data, cb)
    TriggerServerEvent("rcore_police:server:requestBossMenuAction", data)
    cb("OK")
end)

RegisterNuiCallback(NUI_EVENTS.BOSS_MENU_ORDER_VEHICLE, function(data, cb)
    TriggerServerEvent("rcore_police:server:requestBuyGarageVehicle", data)
    cb("OK")
end)

function UpdateBossMenuData(options)
    UI.SendReactMessage(NUI_EVENTS.BOSS_MENU_UPDATE_DATA, {
        options = options
    })
end

function OpenBossMenuCustom(data)
    if not Framework.job then return end
    
    local jobName = Framework.job.name
    local isBoss = Framework.job.isBoss
    
    if not isBoss then
        return dbg.info("Boss menu: You cant access boss menu when not boss %s!", isBoss)
    end
    
    local jobData = data or GroupsService.GetStorageSpecificById(jobName)
    local grades = Framework.GetJobGrades(jobName)
    
    if not jobData then
        return dbg.info("Boss menu: Failed to find any job data for job named %s!", jobName)
    end
    
    local options = {
        label = jobData.name or "",
        garage = {
            stock_mode = Config.Garage.DepartmentsEnableBuyVehicles,
            stock = jobData.garageStock or 0
        },
        society = jobData.society or {},
        members = jobData.members or {},
        grades = grades or {}
    }
    
    UI.SendReactMessage(NUI_EVENTS.OPEN_JOB_BOSS_MENU, {
        options = options,
        showState = true
    })
    SetNuiFocus(true, true)
end
