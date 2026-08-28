ChatService = {}

function ChatService.RegisterAllSuggestions(target)
    if not Config.RegisterChatSuggestions then
        return
    end

    dbg.debug("Registering all chat suggestions for %s", target or "all players")

    if not (Config.Commands and next(Config.Commands)) then
        return
    end

    local suggestionTarget = target or -1

    for _, commandName in pairs(Config.Commands) do
        local commandPrefix = ("/%s"):format(commandName)
        local localeKey = ("CHAT.COMMAND_%s"):format(commandName:upper())
        local chatSuggestions = Config.ChatSuggestions[commandName]

        TriggerClientEvent(
            "chat:addSuggestion",
            suggestionTarget,
            commandPrefix,
            _U(localeKey),
            chatSuggestions
        )
    end
end

Object.registerService(SERVICE_CHAT, ChatService)
