Quest = type(_G.Quest) == 'table' and _G.Quest or {
    currentQuests = {}
}
Quest.currentQuests = Quest.currentQuests or {}

RegisterNuiCallback("executeObjective", function(data, cb)
    local payload = {
        action = data.action,
        id = data.id,
        zoneId = SH.zoneId
    }

    if payload.action == Actions.PRISON_BREAK then
        HideApp()
    end

    TriggerServerEvent("rcore_prison:server:handleQuestTask", payload)
    cb("ok")
end)

function PointCameraAtEntityHead(entity)
    local headBone = GetPedBoneIndex(entity, 12844)
    local headCoords = GetWorldPositionOfEntityBone(entity, headBone)
    local forwardVector = GetEntityForwardVector(entity)
    local cameraCoords = headCoords + (forwardVector * 0.5)

    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

    SetCamCoord(camera, cameraCoords.x, cameraCoords.y, cameraCoords.z)
    PointCamAtCoord(camera, headCoords.x, headCoords.y, headCoords.z)
    SetCamActive(camera, true)
    RenderScriptCams(true, false, 0, true, false)

    return camera
end

function Quest.RequestOpen(zoneId)
    local interaction = SH.data.interaction[zoneId]
    if not interaction then
        return
    end

    local questData = interaction.quest
    if not questData then
        return dbg.debug("No quest found for zoneId %s", zoneId)
    end

    local interactEntity = interaction.entity or PlayerPedId()
    if not interactEntity then
        return dbg.debug("No interactPed found for zoneId %s", zoneId)
    end

    DisplayRadar(false)

    if Config.Release.AtCheckpoint and interaction.releasePlayerOption then
        if not Quest.appendState then
            Quest.appendState = true

            questData.options[#questData.options + 1] = {
                label = _U("RELEASE.LABEL"),
                action = Actions.RELEASE_PLAYER
            }
        end
    end

    Quest.activeCamera = PointCameraAtEntityHead(interactEntity)

    HelpKeys.Hide()
    FrontendService.HandleFocus(true)

    FrontendService.SendReactMessage(FE_EVENTS.LOAD_APP, {
        screen = Screens.QUEST,
        visible = true,
        quest = questData
    })
end