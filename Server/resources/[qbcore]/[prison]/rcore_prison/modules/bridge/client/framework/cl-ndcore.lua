CreateThread(function()
    if Config.Framework == Framework.NDCore then
        function HandleInventoryOpenState(state)
            local ply = LocalPlayer
        
            if not ply then
                return
            end
        end
        
        function GetCharacterIdentifier()
            return nil
        end

        function Framework.showHelpNotification(text)
            DisplayHelpTextThisFrame(text, false)
            BeginTextCommandDisplayHelp(text)
            EndTextCommandDisplayHelp(0, false, false, -1)
        end
    
        function Framework.sendNotification(message, type)
            TriggerEvent('chat:addMessage', {
                multiline = true,
                args = { message }
            })
        end
    end    
end, "cl-ndcore code name: Phoenix")