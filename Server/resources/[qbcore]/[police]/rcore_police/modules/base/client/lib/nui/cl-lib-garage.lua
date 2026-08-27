-- =====================================================
--  rcore_police · modules/base/client/lib/nui/cl-lib-garage.lua
--  Engineered by Eazy Fxap
--  Original: 72 lines → Cleaned: 24 lines
-- =====================================================

local GarageOptions = {}

RegisterNuiCallback(NUI_EVENTS.GET_VEHICLE_FROM_DEPARTMENT_GARAGE, function(data, cb)
    if not data then return end
    
    local index = data.index + 1
    local option = GarageOptions[index]
    
    if not option then return end
    
    if option.label then
        dbg.debug("Get item from store: Selected item: %s", option.label)
    end
    
    SetNuiFocus(false, false)
    Wait(0)
    RequestVehicleFromDepartmentGarage(option)
    
    GarageOptions = {}
    cb("ok")
end)

function OpenGarage(options)
    GarageOptions = options
    UI.SendReactMessage(NUI_EVENTS.OPEN_JOB_GARAGE, {
        options = options,
        showState = true
    })
    SetNuiFocus(true, true)
end
