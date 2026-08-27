-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CORRIDAS - CLIENT CORE
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

SeoulCorridasClient = {
    Tunnel = Tunnel,
    Proxy = Proxy,
    vRP = Proxy.getInterface("vRP")
}

function DrwText(text,height)
    SetTextFont(4)
    SetTextScale(0.50,0.50)
    SetTextColour(255,255,255,180)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5,height)
end

function DrawBase3D(x,y,z)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    if not onScreen then return end

    SetTextScale(0.35,0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255,255,255,215)
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString("~b~E~w~  INICIAR CORRIDA")
    DrawText(_x,_y)
end
