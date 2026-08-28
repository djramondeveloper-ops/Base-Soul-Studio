local OFFICER_CACHE_TTL = 5 * 60 * 1000
local officerCache = { officers = {}, count = 0, expiresAt = 0 }

---@param tbl table
---@return number
local function SafeCount(tbl)
    if type(tbl) ~= "table" or not next(tbl) then
        return 0
    end

    return #tbl > 0 and #tbl or table.size(tbl)
end

--- Default officer gathering: iterates all players and checks Config.Jobs
---@return table officers Array of player IDs
function LoadOfficersDefault()
    local players = GetPlayers()
    local officers = {}

    for _, playerId in pairs(players) do
        playerId = tonumber(playerId)

        local job = Framework.getJob(playerId)

        local onDuty = job and (job.duty or job.onDuty)

        if job and job.name and (Config.Jobs[job.name] or Config.Jobs[job.name:lower()]) and onDuty then
            dbg.debug("GetOfficers: Adding player with ID: %s that has job named: %s", playerId, job.name)
            officers[#officers + 1] = playerId
        end
    end

    return officers
end

LoadOfficers = LoadOfficersDefault

local PoliceCountProviders = {
    {
        resource = THIRD_PARTY_RESOURCE.RCORE_POLICE,
        export = "GetPoliceOnline",
        resolve = function()
            return exports[THIRD_PARTY_RESOURCE.RCORE_POLICE]:GetPoliceOnline()
        end,
    },
    {
        resource = THIRD_PARTY_RESOURCE.WASABI_POLICE,
        export = "getPoliceOnline",
        resolve = function()
            return exports[THIRD_PARTY_RESOURCE.WASABI_POLICE]:getPoliceOnline()
        end,
    },
}

--- Resolve officer count from third-party providers
---@param fallback number Default count if no provider is available
---@return number
local function ResolvePoliceCount(fallback)
    for _, provider in ipairs(PoliceCountProviders) do
        if isResourcePresentProvideless(provider.resource) and doesExportExistInResource(provider.resource, provider.export) then
            local ok, result = pcall(provider.resolve)

            if ok and type(result) == "number" then
                dbg.debug("GetOfficers: Using police count from '%s:%s' → %s", provider.resource, provider.export, result)
                return result
            end
        end
    end

    return fallback
end

--- Get all online officers matching Config.Jobs (cached for 5 minutes)
---@return table officers Array of player IDs
---@return number count Officer count (from third-party provider if available, otherwise #officers)
function Framework.getOfficers()
    local now = GetGameTimer()

    if officerCache.expiresAt > now then
        return officerCache.officers, officerCache.count
    end

    local officers = LoadOfficers()
    local size = SafeCount(officers)

    officerCache.officers = officers
    officerCache.count = size
    officerCache.expiresAt = now + OFFICER_CACHE_TTL

    local count = ResolvePoliceCount(size)

    return officers, count
end

function Framework.canStartPrisonBreak()
    if not Config.Escape.PoliceCheck then
        return true
    end

    local _, count = Framework.getOfficers()
    local required = Config.Escape.RequiredPolice

    if count >= required then
        dbg.debug("Can start prison break: %s officers online (required: %s)", count, required)
        return true
    end

    dbg.debug("Cannot start prison break: %s officers online (required: %s)", count, required)

    return false
end
