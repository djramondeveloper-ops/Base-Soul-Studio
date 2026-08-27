-- =====================================================
--  rcore_police · deterministic Seoul map resolver
-- =====================================================

ValidMapData = {}

CreateThread(function()
    local resourcePath = GetResourcePath and GetResourcePath(GetCurrentResourceName()) or "N/A"
    print(("^2[rcore_police][Seoul]^7 SEOUL_SINGLE_DP_V5 | path=%s"):format(tostring(resourcePath)))
    if not WaitForPoliceMapDefinitions(5000) then
        return dbg.critical('Server map presets were not populated before timeout')
    end

    local resolvedMaps = ResolvePoliceMapPresets()
    for _, entry in pairs(resolvedMaps) do
        local mapName = entry.mapName
        local mapConfig = entry.mapData

        if mapConfig then
            ValidMapData[mapName] = {
                resource = mapConfig.Resource,
                location = mapConfig.MapLocation,
                coords = mapConfig.Pos,
                owner = mapConfig.Jobs,
            }
            dbg.debug('Server map resolver selected %s for %s (%s)', mapName, tostring(mapConfig.MapLocation), tostring(entry.reason))
        end
    end
end)
