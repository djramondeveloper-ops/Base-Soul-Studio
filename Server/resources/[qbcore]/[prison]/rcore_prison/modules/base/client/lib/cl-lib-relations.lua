local prisonScenarioBlockArea = 0

AddEventHandler("rcore_prison:shared:internal:MapLoaded", function()
    HandlePool()
end)

function HandlePool()
    local relationshipGroups = {
        "PRISONER",
        "COP"
    }

    for i = 1, #relationshipGroups do
        SetRelationshipBetweenGroups(1, relationshipGroups[i], 1862763509)
    end

    if not SH.data or not SH.data.interaction then
        return
    end

    local prisonYardCenter = vec3(
        SH.data.prisonYard.x,
        SH.data.prisonYard.y,
        SH.data.prisonYard.z
    )

    local areaRadiusXY = 300
    local areaRadiusZ = 300

    local minX = prisonYardCenter.x - areaRadiusXY
    local minY = prisonYardCenter.y - areaRadiusXY
    local minZ = prisonYardCenter.z - areaRadiusZ
    local maxX = prisonYardCenter.x + areaRadiusXY
    local maxY = prisonYardCenter.y + areaRadiusXY
    local maxZ = prisonYardCenter.z + areaRadiusZ

    if not Config.EnableSpawnNPCInsidePrison then
        dbg.debug("Disabling NPC spawning inside prison.")

        SetAllVehicleGeneratorsActiveInArea(
            minX, minY, minZ,
            maxX, maxY, maxZ,
            false, false
        )

        SetPedNonCreationArea(
            minX, minY, minZ,
            maxX, maxY, maxZ
        )

        prisonScenarioBlockArea = AddScenarioBlockingArea(
            minX, minY, minZ,
            maxX, maxY, maxZ,
            false, true, true, true
        )

        local suppressedPedModels = {
            "s_m_y_prisoner_01",
            "s_m_y_primuscl_01"
        }

        for i = 1, #suppressedPedModels do
            local model = suppressedPedModels[i]

            if IsModelAPed(model) then
                SetPedModelIsSuppressed(model, true)
            end
        end
    else
        SetAllVehicleGeneratorsActiveInArea(
            minX, minY, minZ,
            maxX, maxY, maxZ,
            true, true
        )

        RemoveScenarioBlockingArea(prisonScenarioBlockArea, true)
        dbg.debug("Enabling NPC spawning inside prison.")
    end
end