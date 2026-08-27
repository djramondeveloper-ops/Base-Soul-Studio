-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if not lib then
        if Config.PG == PG.OX then
            Config.PG = PG.NONE
            dbg.debug('Failed to detect ox_lib started, switching to standalone PG!')
        end
        return
    end
    if Config.PG == PG.OX then
        CancellableProgress = function(time, text, animDict, animName, flag, finish, cancel, opts)
            if not lib then
                return
            end
            if not text then
                text = ''
            end
            local preview = opts.previewSettings
            local plyPed = PlayerPedId()
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
                    key = 'X',
                    label = _U("PROGRESS_BAR.CANCEL_ACTION_LABEL")
                },
            }
            UI.HelpKeys({
                keys = keys
            }, true)
            if lib.progressBar({
                duration = time,
                label = text,
                useWhileDead = false,
                canCancel = true,
                disable = {
                    car = true,
                },
                anim = {
                    flag = flag,
                    dict = animDict,
                    clip = animName
                },
            }) then 
                finish()
                ClearPedTasksImmediately(plyPed)
                if opts.props and opts.props.entities then
                    UtilsService.DeleteCreatedProps(opts.props.entities)
                end
                UI.HelpKeys(nil, false)
            else 
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
            end
        end
    end
end)
