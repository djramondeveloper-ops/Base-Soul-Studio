CreateThread(function()
    if Config.Inventories ~= Inventories.NONE then
        Inventory.registerUsableItem(Config.UseableItems and Config.UseableItems['Tablet'] or 'prison_tablet',
            function(source)
                if not Framework.canPerformJobCommand(source, Config.Commands.JailCP) then
                    Framework.sendNotification(source, _U('GENERAL.YOU_NEED_TO_BE_IN_JOB'), 'error')
                    dbg.info("Cannot perform this command - you are not job member!", source)
                    return
                end

                StartClient(source, 'openMDW', true)
            end)
    end
end)
