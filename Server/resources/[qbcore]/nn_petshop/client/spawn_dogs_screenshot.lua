-- ============================================================
-- nn_petshop | Dog Spawner (Client-side)
-- ============================================================
-- Registers two commands:
--   /spawndogs  - Spawns all dogs defined in Config.Dogs in a
--                 line in front of the player, playing a sitting
--                 animation.
--   /cleardogs  - Deletes all spawned dogs and clears the list.
-- ============================================================

-- ----------------------------------------------------------------
-- Constants
-- ----------------------------------------------------------------

-- Spacing (in metres) between each dog in the spawned line
local DOG_SPACING = 3.0

-- Animation dictionary and clip used to make dogs sit
local ANIM_DICT = "creatures@rottweiler@amb@world_dog_sitting"
local ANIM_CLIP = "base"

-- ----------------------------------------------------------------
-- State
-- ----------------------------------------------------------------

-- Tracks all currently spawned dog ped handles so they can be
-- cleaned up later with /cleardogs
local spawnedDogs = {}

-- ----------------------------------------------------------------
-- clearDogs()
-- Iterates over every tracked dog entity and deletes it from the
-- world, then resets the tracking table.
-- Called both by /cleardogs and at the start of /spawndogs to
-- ensure no duplicates accumulate.
-- ----------------------------------------------------------------
local function clearDogs()
    for _, dogPed in ipairs(spawnedDogs) do
        if DoesEntityExist(dogPed) then
            DeleteEntity(dogPed)
        end
    end

    spawnedDogs = {}
end

-- ----------------------------------------------------------------
-- spawnDogs()
-- Reads Config.Dogs and spawns each entry as a sitting dog ped
-- in a straight line in front of the player.
--
-- Positioning logic:
--   - The "forward" direction from the player is computed using
--     the player's heading angle (in radians).
--   - Each dog is offset along the perpendicular (side) axis by
--     DOG_SPACING * (index - 1), creating a line parallel to the
--     player's facing direction.
--   - Dogs are placed at ground level (z - 1.0 acts as an offset
--     corrected by PlaceObjectOnGroundProperly).
--   - Dogs face 90 degrees to the right of the player's heading
--     so they appear to be sitting in a row facing the same way.
-- ----------------------------------------------------------------
local function spawnDogs()
    -- Clear any previously spawned dogs first
    clearDogs()

    -- Validate that a local player ped exists
    local playerPed = PlayerPedId()
    if not playerPed or playerPed == 0 then
        return
    end

    -- Gather player position and facing information
    local playerCoords  = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)   -- degrees
    local headingRad    = math.rad(playerHeading)       -- radians

    -- Unit vector components for the player's forward direction
    local forwardX =  math.sin(headingRad)  -- +X component of forward
    local forwardY =  math.cos(headingRad)  -- +Y component of forward

    -- Perpendicular (right-side) unit vector components, used to
    -- space dogs out in a line beside the player
    local sideX    =  math.cos(headingRad)  -- +X component of right
    local sideY    = -math.sin(headingRad)  -- +Y component of right

    -- Spawn origin: 3 metres directly in front of the player
    local spawnOriginX = playerCoords.x + (DOG_SPACING * forwardX)
    local spawnOriginY = playerCoords.y + (DOG_SPACING * forwardY)
    local spawnOriginZ = playerCoords.z

    -- Dogs will face 90 degrees to the right of the player
    local dogFacingHeading = playerHeading + 90.0

    -- ----------------------------------------------------------------
    -- Validate Config.Dogs
    -- ----------------------------------------------------------------
    local dogConfigs = Config.Dogs
    if not dogConfigs then
        dogConfigs = {}
    end

    if #dogConfigs == 0 then
        print("[nn_petshop] No dogs in Config.Dogs")
        return
    end

    -- ----------------------------------------------------------------
    -- Load the sitting animation dictionary (with timeout guard)
    -- ----------------------------------------------------------------
    RequestAnimDict(ANIM_DICT)

    local animWaitTicks = 0
    while not HasAnimDictLoaded(ANIM_DICT) and animWaitTicks < 100 do
        Wait(10)
        animWaitTicks = animWaitTicks + 1
    end

    -- ----------------------------------------------------------------
    -- Spawn each dog from the config list
    -- ----------------------------------------------------------------
    for index, dogConfig in ipairs(dogConfigs) do

        -- Resolve the model name; fall back to golden retriever if unset
        local modelName = (type(dogConfig.model) == "string" and dogConfig.model)
                          or "a_c_retriever"

        local modelHash = GetHashKey(modelName)

        -- Request the model asset with a timeout guard
        RequestModel(modelHash)

        local modelWaitTicks = 0
        while not HasModelLoaded(modelHash) and modelWaitTicks < 100 do
            Wait(10)
            modelWaitTicks = modelWaitTicks + 1
        end

        -- Skip this dog if the model failed to stream in time
        if not HasModelLoaded(modelHash) then
            print("[nn_petshop] Failed to load model: " .. tostring(modelName))

        else
            -- Calculate this dog's position along the side axis
            -- index 1 → offset 0, index 2 → offset DOG_SPACING, etc.
            local sideOffset = (index - 1) * DOG_SPACING
            local dogX = spawnOriginX + (sideX * sideOffset)
            local dogY = spawnOriginY + (sideY * sideOffset)
            local dogZ = spawnOriginZ - 1.0   -- slight downward offset;
                                               -- corrected by PlaceObjectOnGroundProperly

            -- CreatePed arguments:
            --   pedType  = 28      (animal)
            --   model    = modelHash
            --   x, y, z  = world position
            --   heading  = dogFacingHeading
            --   isNet    = false   (local entity, not networked)
            --   bScriptHostPed = false
            local dogPed = CreatePed(28, modelHash, dogX, dogY, dogZ,
                                     dogFacingHeading, false, false)

            if not dogPed or dogPed == 0 then
                -- Ped creation failed; release the model and move on
                SetModelAsNoLongerNeeded(modelHash)

            else
                -- Mark as a mission entity so the game engine won't
                -- clean it up automatically while the script is running
                SetEntityAsMissionEntity(dogPed, true, true)

                -- Prevent the AI from reacting to world events
                -- (stops dogs from running away or entering combat)
                SetBlockingOfNonTemporaryEvents(dogPed, true)

                -- Disable all flee behaviour (flee flag bitmask = 0)
                SetPedFleeAttributes(dogPed, 0, false)

                -- Enable the "always fight" combat attribute (flag 46)
                -- so the ped stays in its scripted state
                SetPedCombatAttributes(dogPed, 46, true)

                -- Snap the ped down onto the ground surface properly
                PlaceObjectOnGroundProperly(dogPed)

                -- Play the sitting animation if the dict loaded in time
                if HasAnimDictLoaded(ANIM_DICT) then
                    TaskPlayAnim(
                        dogPed,
                        ANIM_DICT,
                        ANIM_CLIP,
                        8.0,    -- blend in speed
                        -8.0,   -- blend out speed
                        -1,     -- duration (-1 = loop forever)
                        1,      -- flag (1 = loop)
                        0,      -- playback rate
                        false,  -- lock X axis
                        false,  -- lock Y axis
                        false   -- lock Z axis
                    )
                end

                -- Release the model from memory now that the ped exists
                SetModelAsNoLongerNeeded(modelHash)

                -- Track the ped so /cleardogs can remove it later
                table.insert(spawnedDogs, dogPed)
            end
        end
    end

    -- ----------------------------------------------------------------
    -- Confirm how many dogs were successfully spawned
    -- ----------------------------------------------------------------
    if #spawnedDogs > 0 then
        print("[nn_petshop] Spawned " .. #spawnedDogs
              .. " dogs in a line. Use /cleardogs to remove.")
    end
end

-- ----------------------------------------------------------------
-- Command: /spawndogs
-- Clears any existing dogs and spawns a fresh line from Config.Dogs.
-- The third argument (false) means no ACE permission is required.
-- ----------------------------------------------------------------
RegisterCommand("spawndogs", function()
    spawnDogs()
end, false)

-- ----------------------------------------------------------------
-- Command: /cleardogs
-- Deletes all currently tracked dog entities.
-- ----------------------------------------------------------------
RegisterCommand("cleardogs", function()
    clearDogs()
    print("[nn_petshop] Cleared spawned dogs.")
end, false)