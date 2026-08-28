Entity = type(_G.Entity) == 'table' and _G.Entity or {
    cache = {}
}
Entity.cache = Entity.cache or {}

local createAsNetworkEntity = false
local createAsMissionEntity = false

function Entity.RefreshArea()
    -- Placeholder: original decompiled function had no body.
end

function Entity.SpawnNPCAtCoords(_)
    -- Placeholder: original decompiled function had no body.
end

local function generateCirclePositions(centerCoords, radius, pointCount)
    local positions = {}
    local totalPoints = pointCount or math.random(3, 6)
    local angleStep = (2 * math.pi) / totalPoints

    for index = 0, totalPoints - 1 do
        local angle = index * angleStep
        local offsetX = math.cos(angle) * radius
        local offsetY = math.sin(angle) * radius

        table.insert(positions, {
            x = centerCoords.x + offsetX,
            y = centerCoords.y + offsetY,
            z = centerCoords.z
        })
    end

    return positions
end

_G.generateCirclePositions = generateCirclePositions

function Entity.SpawnPropAtCoords(data)
    if not data or not data.model then
        return
    end

    local model = data.model
    local coords = data.coords
    local heading = data.heading or 0.0
    local isInvisible = data.invisible == true

    local modelHash = type(model) == "string" and joaat(model) or model
    if not IsModelInCdimage(modelHash) then
        return
    end

    if isInvisible then
        createAsNetworkEntity = false
        createAsMissionEntity = false
    end

    while not HasModelLoaded(modelHash) do
        RequestModel(modelHash)
        Wait(100)
    end

    local isPhoneBox = model == "sf_prop_sf_phonebox_01b_s"
        or modelHash == joaat("sf_prop_sf_phonebox_01b_s")

    if isPhoneBox then
        heading = 0.0
    end

    local entity
    if isPhoneBox then
        entity = CreateObject(
            modelHash,
            coords.x,
            coords.y,
            coords.z - 1.3,
            createAsNetworkEntity,
            createAsMissionEntity,
            true
        )
    else
        entity = CreateObjectNoOffset(
            modelHash,
            coords.x,
            coords.y,
            coords.z,
            createAsNetworkEntity,
            createAsMissionEntity,
            true
        )
    end

    local attempts = 0
    while not DoesEntityExist(entity) do
        Wait(1)
        attempts = attempts + 1

        if attempts >= 200 then
            dbg.critical("Failed to spawn entity in cl-lib-entity.lua")
            break
        end
    end

    Entity.cache[entity] = {
        entity = entity
    }

    Wait(0)

    SetEntityHeading(entity, heading)
    SetEntityRotation(entity, 0.0, 0.0, heading, 2, true)
    SetEntityCanBeDamaged(entity, false)

    if isInvisible and Config.PrisonJobs.TargetHighlight then
        local outlineColor = Config.PrisonJobs.TargetHiglightColor or {
            r = 50,
            g = 149,
            b = 1,
            a = 255
        }

        SetEntityAlpha(entity, 50, true)
        SetEntityDrawOutline(entity, true)
        SetEntityDrawOutlineColor(
            outlineColor.r,
            outlineColor.g,
            outlineColor.b,
            outlineColor.a
        )
        SetEntityDrawOutlineShader(1)
        SetEntityCollision(entity, false, false)
        SetEntityCoords(entity, coords.x, coords.y, coords.z - 1.0)
    end

    if not isPhoneBox then
        PlaceObjectOnGroundProperly(entity)
    end

    FreezeEntityPosition(entity, true)
    SetModelAsNoLongerNeeded(modelHash)

    return entity
end