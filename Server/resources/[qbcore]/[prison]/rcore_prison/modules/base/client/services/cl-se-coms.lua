COMSService = {}

local function getCOMSStorage()
    return Object.getStorage(STORAGE_COMS)
end

function COMSService.RequestMenu(data)
    OpenStartCOMS(data)
end

function COMSService.SendHeartbeat(eventName, ...)
    TriggerEvent("rcore_prison:client:heartbeat", eventName, ...)
end

function COMSService.GetUser()
    local storage = getCOMSStorage()
    if not storage then
        return false
    end

    return storage.GetCOMS()
end

function COMSService.RenderPerollTime()
    local storage = getCOMSStorage()
    if not storage then
        return false
    end

    if not Config.COMS.RenderPerollTime then
        return
    end

    if SH.isRenderingTime then
        return
    end

    SH.isRenderingTime = true

    local waitPromise = promise.new()
    local resolved = false

    CreateThread(function()
        while SH.isRenderingTime do
            Wait(0)

            local comsData = storage.GetCOMS()
            local progressLabel = ("%s / %s"):format(comsData.perollAmount, comsData.perollTarget)

            if comsData.perollAmount < comsData.perollTarget then
                if Config.COMS.RenderPerollTime then
                    PrisonService.DisplayTime(_U("CS.DISPLAY_PEROLL_TIME", progressLabel))
                end
            else
                SH.isRenderingTime = false
                Text.Hide()

                if not resolved then
                    resolved = true
                    waitPromise:resolve(true)
                end
            end

            Wait(1000)
        end
    end, "cl-se-coms code name: Phoenix")

    Citizen.Await(waitPromise)

    dbg.debug("RequestRelease: COMS parolle has finished - release citizen. 2/2.")
    TriggerServerEvent("rcore_prison:server:requestPerollRelease")
end

function COMSService.RegisterSession(sessionData)
    local storage = getCOMSStorage()
    if not storage then
        return
    end

    return storage.RegisterActiveCOMS(sessionData)
end

function COMSService.ClearUserData()
    local storage = getCOMSStorage()
    if not storage then
        return
    end

    SH.isRenderingTime = false
    SH.screen = nil
    SH.zoneId = nil

    storage.UnregisterActiveCOMS()

    HelpKeys.Hide()
    Text.Hide()

    FrontendService.SendReactMessage(FE_EVENTS.LOAD_APP, {
        visible = false,
        screen = nil
    })

    DestroyAllMenus()
    ClearAllHelpMessages()
    BusyspinnerOff()
    TextService.Hide()
end
