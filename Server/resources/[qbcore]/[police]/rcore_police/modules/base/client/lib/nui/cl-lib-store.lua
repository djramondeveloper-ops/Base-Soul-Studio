-- =====================================================
--  rcore_police · modules/base/client/lib/nui/cl-lib-store.lua
--  Engineered by Eazy Fxap
--  Original: 79 lines → Cleaned: 27 lines
-- =====================================================

local StoreOptions = {}

RegisterNuiCallback(NUI_EVENTS.GET_ITEM_FROM_DEPARTMENT_STORE, function(data, cb)
    if not data then return end
    
    local index = data.index + 1
    local option = StoreOptions[index]
    
    if not option then return end
    
    SetNuiFocus(false, false)
    Wait(0)
    RequestGetItemFromStore(option)
    
    StoreOptions = {}
    cb("ok")
end)

function OpenDepartmentStore(options)
    StoreOptions = options
    local jobName = Framework.job.name
    local storeConfig = Config.JobGroups[jobName] and Config.JobGroups[jobName].Store
    local storageMode = storeConfig and storeConfig.storageMode or STORAGE_MODE.FREE
    
    UI.SendReactMessage(NUI_EVENTS.OPEN_DEPARTMENT_STORE, {
        options = options,
        storageMode = storageMode,
        showState = true
    })
    SetNuiFocus(true, true)
end
