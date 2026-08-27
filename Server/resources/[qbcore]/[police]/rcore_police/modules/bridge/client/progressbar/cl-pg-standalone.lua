-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local IsCancelled = false
CreateThread(function()
    CancellableProgressStandaone = function(time, text, animDict, animName, flag, finish, cancel, opts)
        IsCancelled = false
        local ped = PlayerPedId()
        if not opts then opts = {} end
        if animDict then
            LoadAnimDict(animDict)
            TaskPlayAnim(ped, animDict, animName, opts.speedIn or 1.0, opts.speedOut or 1.0, -1, flag, 0, 0, 0, 0)
        end
        if not text then
            text = ''
        end
        local preview = opts.previewSettings
        if opts and next(opts.previewObject) then
            if not preview then
                return
            end
            if not preview.entity then
                preview.entity = UtilsService.SpawnObject(preview.model, preview.pos, false, false)
                SetEntityHeading(preview.entity, preview.heading)
            end
            UtilsService.HandleEntityFade(preview.entity, preview.fadeType, time)
        end
        if opts.props then
            opts.props.entities = UtilsService.CreateProps(opts.props)
        end
        local keys = {
            {
                key = 'E',
                label = _U("PROGRESS_BAR.CANCEL_ACTION_LABEL")
            },
        }
        UI.HelpKeys({
            keys = keys
        }, true)
        StartCancellableProgressBar(time, text)
        LastHp = GetEntityHealth(ped)
        local timeLeft = time
        while true do
            Wait(0)
            timeLeft = timeLeft - (GetFrameTime() * 1000)
            if timeLeft <= 0 then
                break
            end
            DisableControlAction(0, 38, true)
            if IsControlPressed(0, 38) or IsDisabledControlPressed(0, 38) then
                IsCancelled = true
            end
            if not IsEntityPlayingAnim(ped, animDict, animName, 3) then
                TaskPlayAnim(ped, animDict, animName, opts.speedIn or 1.0, opts.speedOut or 1.0, -1, flag, 0, 0, 0, 0)
            end
            if IsCancelled then
                ClearPedTasksImmediately(ped)
                if cancel then
                    StopCancellableProgressBar()
                    if preview.entity and DoesEntityExist(preview.entity) and preview.fadeType == "fadeOut" then
                        UtilsService.StopCurrentFade()
                        SetEntityAlpha(preview.entity, 255, false)
                    end
                    if preview.entity and DoesEntityExist(preview.entity) and preview.fadeType == "fadeIn" then
                        DeleteEntity(preview.entity)
                    end
                    if opts.props and opts.props.entities then
                        UtilsService.DeleteCreatedProps(opts.props.entities)
                    end
                    cancel()
                    return
                end
            end
        end
        if animDict then
            StopAnimTask(ped, animDict, animName, 1.0)
        end
        if finish then
            if opts.props and opts.props.entities then
                UtilsService.DeleteCreatedProps(opts.props.entities)
            end
            UI.HelpKeys(nil, false)
            finish()
        end
    end
    function StartCancellableProgressBar(time, text)
        IsProgressbarDisplayed = true
        local maxProgressWidth = 0.2
        local curProgressWidth = 0.0
        FreezeEntityPosition(PlayerPedId(), true)
        local border = 0.007
        time = time / 1000
        local distFromTop = 0.91
        Citizen.CreateThread(function()
            while IsProgressbarDisplayed and curProgressWidth < 1.0 do
                Wait(0)
                curProgressWidth = curProgressWidth + (GetFrameTime() / time)
                DrawRect(
                    0.5, distFromTop,
                    maxProgressWidth, 0.05,
                    0, 0, 0, 200
                )
                DrawRect(
                    0.5, distFromTop - 0.0005,
                    maxProgressWidth * curProgressWidth * 0.999, 0.05 - border,
                    0, 255, 255, 200
                )
                SetTextFont(0)
                SetTextScale(0.0, 0.35)
                SetTextColour(255, 255, 255, 255)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextJustification(0)
                SetTextEntry("STRING")
                AddTextComponentString(text)
                DrawText(0.5, 0.897)
            end
            IsProgressbarDisplayed = false
            FreezeEntityPosition(PlayerPedId(), false)
        end)
    end
    function StopCancellableProgressBar()
        UI.HelpKeys(nil, false)
        IsProgressbarDisplayed = false
    end
    function LoadAnimDict(dict)
        while (not HasAnimDictLoaded(dict)) do
            RequestAnimDict(dict)
            Citizen.Wait(100)
        end
    end
    if Config.PG == PG.NONE then
        function CancellableProgress(time, text, animDict, animName, flag, finish, cancel, opts)
            return CancellableProgressStandaone(time, text, animDict, animName, flag, finish, cancel, opts)
        end
    end
end)
