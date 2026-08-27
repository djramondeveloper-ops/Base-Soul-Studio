-- =====================================================
--  rcore_police · modules/base/client/services/cl-se-vehicle.lua
--  Engineered by Eazy Fxap
--  Original: 183 lines → Cleaned: 66 lines
-- =====================================================

VehicleService = {}

function VehicleService.ImpoundVehicle(vehicle)
    if not vehicle then
        return dbg.critical("Failed to impound vehicle, not any received!")
    end

    local alpha = 255
    local waitInterval = 1.5
    local alphaDecrement = 5
    local impoundTime = Config.Garage.ImpoundRemoveTime
    local elapsed = 0
    local ped = PlayerPedId()
    local p = promise.new()
    
    dbg.debug("Starting impound vehicle!")
    
    if Config.Garage.ImpoundUseProgresBar then
        CancellableProgress(Config.Garage.ImpoundRemoveTime * 1000, _U("GARAGE.IMPOUND_ACTION"), "missheistdockssetup1clipboard@base", "base", 1, function()
            Framework.sendNotification(_U("IMPOUNDS.VEHICLE_SENT_TO_IMPOUND"), "success")
            DeleteEntity(vehicle)
            p:resolve(true)
        end, function()
            Framework.sendNotification(_U("IMPOUNDS.VEHICLE_REVOKE_SENT_TO_IMPOUND"), "success")
            p:resolve(true)
        end, {
            props = {
                {
                    name = "prop_notepad_01",
                    bone = 18905,
                    coords = vector3(0.1, 0.02, 0.05),
                    rotation = vector3(10.0, 0.0, 0.0)
                },
                {
                    name = "prop_pencil_01",
                    bone = 58866,
                    coords = vector3(0.11, -0.02, 0.001),
                    rotation = vector3(-120.0, 0.0, 0.0)
                }
            }
        })
    else
        TaskStartScenarioInPlace(ped, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
        CreateThread(function()
            while alpha > 0 do
                alpha = alpha - alphaDecrement
                if alpha < 0 then alpha = 0 end
                
                SetEntityAlpha(vehicle, alpha, false)
                Citizen.Wait(waitInterval * 1000)
                
                elapsed = elapsed + waitInterval
                if elapsed >= impoundTime then
                    DeleteEntity(vehicle)
                    ClearPedTasksImmediately(ped)
                    p:resolve(true)
                    break
                end
            end
        end)
    end
    
    return Citizen.Await(p)
end
