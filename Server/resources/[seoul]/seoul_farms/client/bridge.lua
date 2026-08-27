-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL FARMS CLIENT BRIDGE
-----------------------------------------------------------------------------------------------------------------------------------------
Tunnel = Tunnel or module("vrp","lib/Tunnel")
Proxy = Proxy or module("vrp","lib/Proxy")
vRP = vRP or Proxy.getInterface("vRP")

InProcess = InProcess or false

function DrawBase3D(x,y,z,text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoords())
    if onScreen then
        SetTextScale(0.35,0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255,255,255,215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y + 0.0125,0.015 + factor,0.03,0,0,0,120)
    end
end

function SeoulFarmsDrawText3D(x,y,z,text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    if onScreen then
        SetTextScale(0.35,0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255,255,255,215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y + 0.0125,0.015 + factor,0.03,0,0,0,120)
    end
end

function SeoulFarmsCancel(state)
    TriggerEvent("cancelando",state)
    LocalPlayer.state:set("Cancel",state,true)
end
