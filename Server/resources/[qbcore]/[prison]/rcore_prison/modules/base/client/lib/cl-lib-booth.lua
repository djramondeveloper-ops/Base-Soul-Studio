Booths = type(_G.Booths) == 'table' and _G.Booths or {
    callSessionState = false
}

NetworkService.RegisterNetEvent("EndCallAtBooth", function(shouldExitBooth)
    if not shouldExitBooth then
        return
    end

    if not Booths.callSessionState then
        return
    end

    Booths.callSessionState = false

    pcall(function()
        HandleInventoryOpenState(true)
    end)

    HelpKeys.Hide()
    BoothAnim:Exit()
    IsAtBooth = false
end)

function Booths.RequestOpen()
    IsAtBooth = true
    TriggerServerEvent("rcore_prison:server:requestBooth", SH.zoneId)
end

function Booths.RequestEndCall()
    dbg.debug("Booths.RequestEndCall")

    if not Booths.callSessionState then
        return
    end

    if not IsAtBooth then
        return
    end

    TriggerServerEvent("rcore_prison:server:requestBoothEndCall", SH.zoneId)
end

function Booths.OpenUI(interactionId)
    local boothData = SH.data.interaction[interactionId].booth
    if not boothData then
        return
    end

    FrontendService.HandleFocus(true)
    FrontendService.SendReactMessage(FE_EVENTS.LOAD_APP, {
        screen = Screens.BOOTH,
        visible = true,
        number = boothData.number
    })
end

function Booths.Reset()
    Booths.callSessionState = false
end

function Booths.EndCall(callId)
    if not Booths.callSessionState then
        return
    end

    Booths.callSessionState = false

    if callId then
        dbg.debug("Booths: Found active callId, removing from active call using %s", callId)
        exports["pma-voice"]:removePlayerFromCall(callId)
    end

    pcall(function()
        HandleInventoryOpenState(true)
    end)

    HelpKeys.Hide()
    BoothAnim:Exit()
    IsAtBooth = false

    dbg.debug("Booths.EndCall")
end

function CreateCameraAtEntity(entity)
    local headBone = GetPedBoneIndex(entity, 12844)
    local headPosition = GetWorldPositionOfEntityBone(entity, headBone)
    local forwardVector = GetEntityForwardVector(entity)
    local cameraPosition = headPosition + (forwardVector * 0.5)

    local camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(camera, cameraPosition.x, cameraPosition.y, cameraPosition.z)
    PointCamAtCoord(camera, headPosition.x, headPosition.y, headPosition.z)
    SetCamActive(camera, true)
    RenderScriptCams(true, false, 0, true, false)

    return camera
end

BoothAnim = {
    model = "sf_prop_sf_phonebox_01b_s",
    animDict = "anim@scripted@payphone_hits@male@",
    animName = "FXFR_PTD_1_INTRO_MALE",
    sceneCamera = "FXFR_PTD_1_CAM",
    scenePhone = "FXFR_PAV_1_INTRO_PHONE"
}

function BoothAnim.GetClosest(self)
    return GetClosestObjectOfType(
        self.plyCoords.x,
        self.plyCoords.y,
        self.plyCoords.z,
        2.0,
        joaat(self.model),
        false,
        false,
        false
    )
end

function BoothAnim.Prepare(self)
    self.ped = PlayerPedId()
    self.plyCoords = GetEntityCoords(self.ped)
    self.entity = self:GetClosest()

    RequestScriptAudioBank("payphone", false, -1)

    if not DoesEntityExist(self.entity) then
        return
    end

    SetFacialIdleAnimOverride(self.ped, self.animDict, "fxfr_phl_1_intro_male_facial")

    local networked, networkId = self:SetEntityAsNetworked()
    if not networked then
        return dbg.critical("Failed to set entity as networked")
    end

    self.heading = GetEntityRotation(self.entity)
    self.coords = GetOffsetFromEntityInWorldCoords(self.entity, vec3(0, 0, 0))

    return true
end

function BoothAnim.SetEntityAsNetworked(self)
    local networkId = nil

    if NetworkGetEntityIsNetworked(self.entity) then
        networkId = NetworkGetNetworkIdFromEntity(self.entity)
    end

    if not networkId then
        local entityCoords = GetEntityCoords(self.entity)

        self.entity = GetClosestObjectOfType(
            entityCoords.x,
            entityCoords.y,
            entityCoords.z,
            0.1,
            GetEntityModel(self.entity),
            true,
            true,
            true
        )

        local refreshedNetworkId = NetworkGetNetworkIdFromEntity(self.entity)
        if refreshedNetworkId ~= 0 then
            networkId = refreshedNetworkId
        end
    end

    if networkId then
        return true, networkId
    end
end

function BoothAnim.StartIntro(self)
    local scene = NetworkCreateSynchronisedScene(
        self.coords.x,
        self.coords.y,
        self.coords.z,
        self.heading.x,
        self.heading.y,
        self.heading.z,
        2,
        true,
        false,
        1.0,
        0,
        1.0
    )

    NetworkAddEntityToSynchronisedScene(
        self.entity,
        scene,
        self.animDict,
        self.scenePhone,
        4.0,
        -8.0,
        1
    )

    NetworkAddPedToSynchronisedScene(
        self.ped,
        scene,
        self.animDict,
        self.animName,
        4.0,
        -4.0,
        1033,
        0,
        1000.0,
        0
    )

    NetworkStartSynchronisedScene(scene)
end

function BoothAnim.Exit(self)
    local scene = NetworkCreateSynchronisedScene(
        self.coords.x,
        self.coords.y,
        self.coords.z,
        self.heading.x,
        self.heading.y,
        self.heading.z,
        2,
        true,
        false,
        1.0,
        0,
        1.0
    )

    NetworkAddEntityToSynchronisedScene(
        self.entity,
        scene,
        self.animDict,
        "wtf_exit_phone",
        4.0,
        -8.0,
        1
    )

    NetworkAddPedToSynchronisedScene(
        self.ped,
        scene,
        self.animDict,
        "wtf_exit_male",
        4.0,
        -4.0,
        1033,
        0,
        1000.0,
        0
    )

    NetworkStartSynchronisedScene(scene)

    local duration = GetAnimDuration(self.animDict, "wtf_exit_phone") * 1000
    Wait(duration)

    NetworkStopSynchronisedScene(scene)
    RemoveAnimDict(self.animDict)
end

RegisterNetEvent("phone:phone:endCall", function()
    if Booths.callSessionState then
        Booths.RequestEndCall()
    end
end)

RegisterNetEvent("phone:phone:connectCall", function(callData)
    if not Booths.callSessionState then
        return
    end

    local callStartTime = GetGameTimer()
    local prepared = BoothAnim:Prepare()

    if prepared then
        BoothAnim:StartIntro()
    end

    pcall(function()
        HandleInventoryOpenState(true)
    end)

    CreateThread(function()
        while true do
            if not Booths.callSessionState then
                break
            end

            Wait(1000)

            if not Booths.callSessionState then
                HelpKeys.Hide()
                break
            end

            local elapsedSeconds = tonumber(math.floor((GetGameTimer() - callStartTime) / 1000))

            HelpKeys.Show({
                {
                    label = _U("BOOTHS.HANGUP_LABEL"),
                    keyName = "BACKSPACE"
                },
                {
                    label = _U("BOOTHS.DURATION_LABEL", elapsedSeconds),
                    keyName = ""
                }
            }, "top-left")
        end
    end, "cl-lib-booth code name: Phoenix")
end)

function Booths.StartCall(phoneNumber, callId)
    if Booths.callSessionState then
        return
    end

    Booths.callSessionState = true

    if isResourceLoaded(Phones.LB) then
        return
    end

    local callStartTime = GetGameTimer()
    local prepared = BoothAnim:Prepare()

    pcall(function()
        HandleInventoryOpenState(false)
    end)

    if prepared then
        BoothAnim:StartIntro()
    end

    if callId then
        dbg.debug("Booths: Found active callId, adding to active call with id (%s)", callId)
        exports["pma-voice"]:addPlayerToCall(callId)
    end

    CreateThread(function()
        while true do
            if not Booths.callSessionState then
                break
            end

            dbg.debug("Booths: Call session state active.")
            Wait(1000)

            if not Booths.callSessionState then
                HelpKeys.Hide()
                break
            end

            local elapsedSeconds = tonumber(math.floor((GetGameTimer() - callStartTime) / 1000))

            HelpKeys.Show({
                {
                    label = _U("BOOTHS.HANGUP_LABEL"),
                    keyName = "BACKSPACE"
                },
                {
                    label = _U("BOOTHS.DURATION_LABEL", elapsedSeconds),
                    keyName = ""
                }
            }, "top-left")
        end
    end, "cl-lib-booth code name: Omega")
end

RegisterKey(Booths.RequestEndCall, "PHONE_BOOTH", "Cancel call", "BACK")