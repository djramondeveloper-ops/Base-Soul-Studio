-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-ai.lua
--  Engineered by Eazy Fxap
--  Original: 116 lines → Cleaned: 40 lines
-- =====================================================

function BlockEnviroment(coords)
    if not coords then return end
    if not Config.Area.Enable then return end
    
    local distXY = 300
    local distZ = 300
    
    SetAllVehicleGeneratorsActiveInArea(
        coords.x - distXY, coords.y - distXY, coords.z - distZ, 
        coords.x + distXY, coords.y + distXY, coords.z + distZ, 
        false, false
    )
    
    SetPedNonCreationArea(
        coords.x - distXY, coords.y - distXY, coords.z - distZ, 
        coords.x + distXY, coords.y + distXY, coords.z + distZ
    )
    
    AddScenarioBlockingArea(
        coords.x - distXY, coords.y - distXY, coords.z - distZ, 
        coords.x + distXY, coords.y + distXY, coords.z + distZ, 
        false, true, true, true
    )
    
    local pedsToBlock = {"s_m_y_prisoner_01", "s_m_y_primuscl_01,"}
    local vehsToBlock = {"police", "policeb"}
    
    for _, ped in ipairs(pedsToBlock) do
        if IsModelAPed(ped) then
            SetPedModelIsSuppressed(ped, true)
        end
    end
    
    for _, veh in ipairs(vehsToBlock) do
        if IsModelAVehicle(veh) then
            SetVehicleModelIsSuppressed(veh, true)
        end
    end
end
