--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

Animation = {}

local playerPropEntities = {}
local pedPropEntitiesByPed = {}
local lastAnimation = { dict = "", name = "" }
local animationGeneration = {}
local activeAnimations = {}

local scenarioHandlers = {
    MaleScenario = function(ped, scenarioName)
        if IsPedInAnyVehicle(ped, false) then
            return false
        end

        if IsPedMale(ped) then
            ClearPedTasks(ped)
            TaskStartScenarioInPlace(ped, scenarioName, 0, true)
            return true
        end
        return false
    end,
    ScenarioObject = function(ped, scenarioName)
        if IsPedInAnyVehicle(ped, false) then
            return false
        end

        local scenarioPosition = GetOffsetFromEntityInWorldCoords(ped, 0.0, -0.5, -0.5)
        ClearPedTasks(ped)
        TaskStartScenarioAtPosition(
            ped,
            scenarioName,
            scenarioPosition.x,
            scenarioPosition.y,
            scenarioPosition.z,
            GetEntityHeading(ped),
            0,
            1,
            false
        )
        return true
    end,
    Scenario = function(ped, scenarioName)
        if IsPedInAnyVehicle(ped, false) then
            return false
        end

        ClearPedTasks(ped)
        TaskStartScenarioInPlace(ped, scenarioName, 0, true)
        return true
    end,
}

function WaitForAssetLoad(requestFn, loadedFn, assetName)
    requestFn(assetName)

    for _ = 1, 60 do
        if loadedFn(assetName) then
            return true
        end

        Wait(33)
    end

    return false
end

function AttachAnimationProp(ped, propModel, propBone, propPosition, propRotation, generation)
    if not ped or not DoesEntityExist(ped) then return end

    local modelHash = type(propModel) == "number" and propModel or GetHashKey(propModel)
    if not WaitForAssetLoad(RequestModel, HasModelLoaded, modelHash) then
        return
    end

    if not DoesEntityExist(ped) or (generation and animationGeneration[ped] ~= generation) then
        SetModelAsNoLongerNeeded(modelHash)
        return
    end

    local pedCoords = GetEntityCoords(ped)
    local propEntity = CreateObject(modelHash, pedCoords.x, pedCoords.y, pedCoords.z, true, true, true)

    if not propEntity or propEntity == 0 or not DoesEntityExist(propEntity) then
        SetModelAsNoLongerNeeded(modelHash)
        return
    end

    AttachEntityToEntity(
        propEntity,
        ped,
        GetPedBoneIndex(ped, propBone),
        propPosition.x,
        propPosition.y,
        propPosition.z,
        propRotation.x,
        propRotation.y,
        propRotation.z,
        true,
        true,
        false,
        true,
        1,
        true
    )

    SetModelAsNoLongerNeeded(modelHash)

    if ped == PlayerPedId() then
        table.insert(playerPropEntities, propEntity)
    else
        if not pedPropEntitiesByPed[ped] then
            pedPropEntitiesByPed[ped] = {}
        end

        table.insert(pedPropEntitiesByPed[ped], propEntity)
    end
end

function SpawnEmoteProps(ped, animationOptions, generation)
    if not animationOptions.Prop then
        return
    end

    -- Props belong to the animation from its first frame, not after its duration.
    if generation and animationGeneration[ped] ~= generation then return end

    AttachAnimationProp(
        ped,
        animationOptions.Prop,
        animationOptions.PropBone,
        {
            x = animationOptions.PropPlacement[1],
            y = animationOptions.PropPlacement[2],
            z = animationOptions.PropPlacement[3],
        },
        {
            x = animationOptions.PropPlacement[4],
            y = animationOptions.PropPlacement[5],
            z = animationOptions.PropPlacement[6],
        },
        generation
    )

    if animationOptions.SecondProp then
        AttachAnimationProp(
            ped,
            animationOptions.SecondProp,
            animationOptions.SecondPropBone,
            {
                x = animationOptions.SecondPropPlacement[1],
                y = animationOptions.SecondPropPlacement[2],
                z = animationOptions.SecondPropPlacement[3],
            },
            {
                x = animationOptions.SecondPropPlacement[4],
                y = animationOptions.SecondPropPlacement[5],
                z = animationOptions.SecondPropPlacement[6],
            },
            generation
        )
    end
end

function LoadEmoteParticleFx(_ped, animationOptions)
    if not animationOptions.PtfxAsset then
        return
    end

    if not WaitForAssetLoad(RequestNamedPtfxAsset, HasNamedPtfxAssetLoaded, animationOptions.PtfxAsset) then
        return
    end

    UseParticleFxAssetNextCall(animationOptions.PtfxAsset)
end

function GetEmoteAnimFlag(animationOptions, ped)
    local flag = animationOptions.EmoteLoop and 1 or 0
    if animationOptions.EmoteMoving or animationOptions.EmoteStuck
        or IsPedInAnyVehicle(ped or PlayerPedId(), false) then
        flag = flag + 48 -- upper body + secondary task
    end
    return flag
end

function RemoveAnimationProps(ped)
    local propList

    if ped and ped ~= PlayerPedId() then
        propList = pedPropEntitiesByPed[ped]
        pedPropEntitiesByPed[ped] = {}
    else
        propList = playerPropEntities
        playerPropEntities = {}
    end

    for _, propEntity in ipairs(propList or {}) do
        if DoesEntityExist(propEntity) then
            DetachEntity(propEntity, true, true)
            DeleteEntity(propEntity)
        end
    end
end

function Animation.GetLastAnimationDict()
    return lastAnimation.dict
end

function Animation.GetLastAnimationName()
    return lastAnimation.name
end

function Animation.Play(ped, emoteName)
    if type(ped) == "string" then
        emoteName = ped
        ped = PlayerPedId()
    end
    if not ped or not DoesEntityExist(ped) or IsEntityDead(ped) then return false end

    local emoteData = AnimationList[emoteName]
    if not emoteData then
        print(string.format("^1[%s]^7 Emote '%s' does not exist.", GetCurrentResourceName(), emoteName))
        return false
    end

    local animDict, animName = table.unpack(emoteData)
    local scenarioHandler = scenarioHandlers[animDict]
    Animation.ResetAll(ped)
    local generation = animationGeneration[ped]

    if scenarioHandler then
        local played = scenarioHandler(ped, animName)
        if played then activeAnimations[ped] = { scenario = true } end
        return played
    end
    if not WaitForAssetLoad(RequestAnimDict, HasAnimDictLoaded, animDict) then
        return false
    end
    if animationGeneration[ped] ~= generation or not DoesEntityExist(ped) or IsEntityDead(ped) then
        RemoveAnimDict(animDict)
        return false
    end

    local animationOptions = emoteData.AnimationOptions or {}
    local emoteDuration = animationOptions.EmoteDuration or -1
    local animFlag = GetEmoteAnimFlag(animationOptions, ped)

    lastAnimation = {
        dict = animDict,
        name = animName,
    }

    LoadEmoteParticleFx(ped, animationOptions)
    if animationGeneration[ped] ~= generation or not DoesEntityExist(ped) or IsEntityDead(ped) then
        RemoveAnimDict(animDict)
        return false
    end
    activeAnimations[ped] = { dict = animDict, name = animName }

    TaskPlayAnim(
        ped,
        animDict,
        animName,
        2.0,
        2.0,
        emoteDuration,
        animFlag,
        0.0, -- Start at the beginning; 1.0 can skip a non-looping clip to its end.
        false,
        false,
        false
    )

    SpawnEmoteProps(ped, animationOptions, generation)
    RemoveAnimDict(animDict)

    return animationGeneration[ped] == generation
end

function Animation.RemoveProps(ped)
    RemoveAnimationProps(ped)
end

function Animation.ResetAll(ped)
    ped = ped or PlayerPedId()
    animationGeneration[ped] = (animationGeneration[ped] or 0) + 1
    RemoveAnimationProps(ped)
    local active = activeAnimations[ped]
    activeAnimations[ped] = nil
    if DoesEntityExist(ped) and active then
        if active.scenario then
            ClearPedTasks(ped)
        else
            StopAnimTask(ped, active.dict, active.name, 2.0)
        end
    end
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    Animation.ResetAll()
    for ped in pairs(animationGeneration) do
        if ped ~= PlayerPedId() then Animation.ResetAll(ped) end
    end
end)
