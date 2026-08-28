--- Cuff provider definitions for auto-uncuffing new prisoners
--- Each provider declares a resource name and an uncuff function
---@type { resource: string, uncuff: fun(playerId: number), detect?: fun(): boolean }[]
local CuffProviders = {
    {
        resource = PoliceResources.WASABI,
        detect = function()
            local author = GetResourceMetadata(PoliceResources.WASABI, 'author', 0)
            return author and author == 'wasabirobby'
        end,
        uncuff = function(playerId)
            TriggerClientEvent('wasabi_police:uncuff', playerId)
        end,
    },
    {
        resource = PoliceResources.ESX,
        uncuff = function(playerId)
            TriggerClientEvent("esx_policejob:unrestrain", playerId)
        end,
    },
    {
        resource = "rcore_police",
        uncuff = function(playerId)
            exports['rcore_police']:ForceUncuff(playerId)
        end,
    },
    {
        resource = "p_policejob",
        uncuff = function(playerId)
            exports['p_policejob']:forceUncuff(playerId)
        end,
    },
    {
        resource = PoliceResources.QB,
        uncuff = function(playerId)
            local cuffState = Framework.getPlayerCuffState(playerId)

            if not cuffState then
                dbg.cuffs("Uncuff: skipping (%s) '%s' — not handcuffed", playerId, GetPlayerName(playerId) or "unknown")
                return
            end

            TriggerClientEvent("police:client:GetCuffed", playerId, playerId, false)
        end,
    },
    {
        resource = PoliceResources.ND,
        uncuff = function(playerId)
            TriggerClientEvent("ND_Police:uncuffPed", playerId)
        end,
    },
    {
        resource = "r_handcuffs",
        uncuff = function(playerId)
            TriggerClientEvent('r_handcuffs:client:execUncuffs', playerId)
        end,
    },
}

--- Resolve which cuff providers are available on this server
---@return { resource: string, uncuff: fun(playerId: number) }[]
local function ResolveActiveProviders()
    local active = {}

    for _, provider in ipairs(CuffProviders) do
        local present = isResourcePresentProvideless(provider.resource)

        if present then
            if provider.detect then
                if provider.detect() then
                    active[#active + 1] = provider
                    dbg.cuffs("Uncuff: registered provider '%s' (custom detect)", provider.resource)
                end
            else
                active[#active + 1] = provider
                dbg.cuffs("Uncuff: registered provider '%s'", provider.resource)
            end
        end
    end

    return active
end

--- Run uncuff on all active providers for a player
---@param providers table Active provider list
---@param playerId number Player server ID
local function RunUncuff(providers, playerId)
    for _, provider in ipairs(providers) do
        local ok, err = pcall(provider.uncuff, playerId)

        if not ok then
            dbg.cuffs("Uncuff: provider '%s' error: %s", provider.resource, err)
        end
    end
end

CreateThread(function()
    if not Config.AutoUncuffNewPrisoner then return end

    local providers = ResolveActiveProviders()

    if #providers == 0 then
        dbg.cuffs("Uncuff: no supported police resource found, disabling auto-uncuffing")
        return
    end

    dbg.cuffs("Uncuff: %s provider(s) active, auto-uncuffing enabled", #providers)

    NetworkService.EventListener("heartbeat", function(eventType, data)
        if eventType ~= HEARTBEAT_EVENTS.PRISONER_NEW then return end
        if not Config.AutoUncuffNewPrisoner then return end

        local prisoner = data and data.prisoner
        if not prisoner then return end

        local playerId = prisoner.source
        if not playerId then return end

        dbg.cuffs("Uncuff: %s auto-uncuffing new prisoner", PlayerTag(playerId))

        SetTimeout(1000, function()
            RunUncuff(providers, playerId)
        end)
    end)
end, "sv-cuffs_handler code name: Phoenix")
