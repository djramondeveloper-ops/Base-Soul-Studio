-- Seoul UI Pack server bootstrap.
-- Não sobrescreve configuração viva da base; só cria fallback se nada existir.

CreateThread(function()
    local basics = GlobalState['Basics']
    if not basics then
        GlobalState:set('Basics', {
            ServerName = "Seoul",
            Discord = "",
            MaxHealth = 400,
            CityLogo = "",
            ServerStore = "",
            Identifier = "steam",
            Whitelist = false,
            Theme = "default",
            Debug = false
        }, true)
    end

    if not GlobalState['Inventory'] then
        GlobalState:set('Inventory', "ox_inventory", true)
    end
end)
