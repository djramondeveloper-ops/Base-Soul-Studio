-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL SCRIPTS CLIENT BRIDGE
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = module('vrp','lib/Tunnel') or {}
Proxy = module('vrp','lib/Proxy') or {}
vRP = vRP or Proxy.getInterface('vRP')
vRPS = vRPS or Tunnel.getInterface('vRP')

SeoulScriptsClient = SeoulScriptsClient or {}

local function debugPrint(...)
    if SeoulScripts and SeoulScripts.Debug then
        print('[Seoul Scripts][CLIENT]', ...)
    end
end
SeoulScriptsClient.Debug = debugPrint

function SeoulScriptsClient.Enabled(name)
    return not SeoulScripts or not SeoulScripts.Modules or SeoulScripts.Modules[name] ~= false
end

function SeoulScriptsClient.Notify(kind,msg,time)
    TriggerEvent('Notify', kind or 'aviso', msg or '', time or 5000)
end

function DrawBase3D(x,y,z,text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    if not onScreen then return end
    SetTextFont(4)
    SetTextScale(0.35,0.35)
    SetTextColour(255,255,255,180)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text or '') / 370)
    DrawRect(_x,_y + 0.0125,0.015 + factor,0.032,0,0,0,100)
end

-- Compat legado Accessories/Reborn -> Seoul vRP client.
CreateThread(function()
    Wait(250)
    if vRP then
        if not vRP.createObjects and vRP.CreateObjects then vRP.createObjects = vRP.CreateObjects end
        if not vRP.removeObjects and vRP.Destroy then vRP.removeObjects = vRP.Destroy end
        if not vRP._playAnim and vRP.playAnim then vRP._playAnim = vRP.playAnim end
        if not vRP._stopAnim and vRP.Destroy then vRP._stopAnim = function() vRP.Destroy() end end
        if not vRP.getNearVehicle and vRP.ClosestVehicle then
            vRP.getNearVehicle = function(radius)
                local vehicle = vRP.ClosestVehicle(radius or 5.0)
                return vehicle
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    if vRP and vRP.Destroy then pcall(vRP.Destroy) end
end)
