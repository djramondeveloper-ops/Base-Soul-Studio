-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL NOTIFY BRIDGE
-- Mantém o evento antigo "Notify" da base, mas envia o visual para o seoul_uipack.
-- seoul:notify/reborn:notify são tratados direto pelo seoul_uipack.
-- NotifyPush/dispatch continuam separados e NÃO passam por aqui.
-----------------------------------------------------------------------------------------------------------------------------------------
local function WaitForSeoulUiPack()
    while GetResourceState("seoul_uipack") ~= "started" do
        Wait(250)
    end
end

CreateThread(WaitForSeoulUiPack)

RegisterNetEvent("Notify")
AddEventHandler("Notify",function(...)
    if GetResourceState("seoul_uipack") == "started" then
        exports["seoul_uipack"]:Notify(...)
    end
end)
