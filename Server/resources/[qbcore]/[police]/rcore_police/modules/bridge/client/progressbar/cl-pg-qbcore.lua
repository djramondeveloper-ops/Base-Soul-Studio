-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.PG == PG.QB then
        CancellableProgress = function(time, text, animDict, animName, flag, finish, cancel, opts)
            if not Framework.object then
                return
            end
            if not text then
                text = ''
            end
            local preview = opts.previewSettings
            local plyPed = PlayerPedId()
            if opts.checkDistance then
                CreateThread(function()
                    local targetPed = UtilsService.GetPlayerPedFromServerId(opts.target)
                    while true do
                        Wait(100)
                        local mePed = PlayerPedId()
                        local meCoords = GetEntityCoords(mePed)
                        local targetCoords = GetEntityCoords(targetPed)
                        local distance = #(meCoords - targetCoords)
                        if distance >= 3.0 then
                            cancel()
                            TriggerEvent('progressbar:client:cancel')
                            UI.HelpKeys(nil, false)
                            break
                        end
                    end
                end)
            end
            if opts.previewObject then
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
                    key = "ESC",
                    label = _U("PROGRESS_BAR.CANCEL_ACTION_LABEL")
                },
            }
            if not isResourcePresentProvideless('17mov_Hud') then
                UI.HelpKeys({
                    keys = keys
                }, true)
            end
            Framework.object.Functions.Progressbar(GetCurrentResourceName(), text, time, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = animDict,
                anim = animName,
                flags = flag,
            }, {}, {}, function()
                finish()
                ClearPedTasksImmediately(plyPed)
                if opts.props and opts.props.entities then
                    UtilsService.DeleteCreatedProps(opts.props.entities)
                end
                UI.HelpKeys(nil, false)
            end, function()
                cancel()
                ClearPedTasksImmediately(plyPed)
                if opts.props and opts.props.entities then
                    UtilsService.DeleteCreatedProps(opts.props.entities)
                end
                UI.HelpKeys(nil, false)
                if preview and preview.entity and DoesEntityExist(preview.entity) and preview.fadeType == "fadeOut" then
                    UtilsService.StopCurrentFade()
                    SetEntityAlpha(preview.entity, 255, false)
                end
                if preview and preview.entity and DoesEntityExist(preview.entity) and preview.fadeType == "fadeIn" then
                    DeleteEntity(preview.entity)
                end
            end)
            Wait(time)
            if isResourcePresentProvideless('17mov_Hud') then
                finish()
                ClearPedTasksImmediately(plyPed)
                if opts.props and opts.props.entities then
                    UtilsService.DeleteCreatedProps(opts.props.entities)
                end
                UI.HelpKeys(nil, false)
            end
        end
    end
end)
