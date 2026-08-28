--- Announcement provider definitions for broadcasting new prisoner events
--- Each provider declares a resource name and a broadcast function
--- First matching provider wins (order matters)
---@type { resource: string, broadcast: fun(prisoner: table, formattedTime: string) }[]
local AnnouncementProviders = {
    {
        resource = THIRD_PARTY_RESOURCE.FUTTE,
        broadcast = function(prisoner, formattedTime)
            exports['futte-newspaper']:CreateJailStory(prisoner.prisonerName, formattedTime)
        end,
    },
    {
        resource = "futte_newspaper",
        broadcast = function(prisoner, formattedTime)
            exports['futte-newspaper']:CreateJailStory(prisoner.prisonerName, formattedTime)
        end,
    },
    {
        resource = THIRD_PARTY_RESOURCE.NO_PAPER,
        broadcast = function(prisoner, formattedTime)
            local API = exports["no-newspaper"]
            local WeazelNews = API:RegisterPaper({
                id = "weazelnews",
                label = "Weazel News",
                canPublish = function() return true end,
                canDelete = function() return false end,
            })

            WeazelNews:Publish({
                header = "Jail Sentence",
                author = "Bolingbroke Penitentiary",
                content = _U('ANNOUCEMENT.CITIZEN_JAILED_ANNOUCEMENT', prisoner.prisonerName, formattedTime),
            })
        end,
    },
    {
        resource = "devkit_wanted",
        broadcast = function(prisoner, formattedTime)
            local message = _U('ANNOUCEMENT.CITIZEN_JAILED_ANNOUCEMENT', prisoner.prisonerName, formattedTime, formattedTime)
            exports["devkit_wanted"]:AnnounceJail(prisoner.source, message)
        end,
    },
}

--- Resolve the first available announcement provider
---@return table|nil provider
local function ResolveProvider()
    for _, provider in ipairs(AnnouncementProviders) do
        if isResourceLoaded(provider.resource) then
            return provider
        end
    end

    return nil
end

--- Fallback: broadcast via chat message
---@param prisoner table
---@param formattedTime string
local function BroadcastChat(prisoner, formattedTime)
    TriggerClientEvent('chat:addMessage', -1, {
        multiline = false,
        args = {
            _U('ANNOUCEMENT.PRISON'),
            _U('ANNOUCEMENT.CITIZEN_JAILED_ANNOUCEMENT', prisoner.prisonerName, formattedTime),
        },
    })
end

NetworkService.EventListener("heartbeat", function(eventType, data)
    if eventType ~= HEARTBEAT_EVENTS.PRISONER_NEW then return end
    if not Config.BroadcastNewPrisoner then return end

    local prisoner = data and data.prisoner
    if not prisoner then return end

    local formattedTime = Time.DynamicSecondsToClock(prisoner.jail_time)
    local provider = ResolveProvider()

    if provider then
        local ok, err = pcall(provider.broadcast, prisoner, formattedTime)

        if not ok then
            dbg.debug("Announcement: provider '%s' error: %s", provider.resource, err)
        end

        return
    end

    BroadcastChat(prisoner, formattedTime)
end)
