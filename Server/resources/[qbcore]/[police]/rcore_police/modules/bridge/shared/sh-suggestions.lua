-- =====================================================
--  rcore_police · modules/bridge/shared/sh-suggestions.lua
--  Engineered by Eazy Fxap
--  Original: 104 lines → Cleaned: 45 lines
-- =====================================================

-- ============================================================
--  ADMIN-ONLY COMMANDS (skip chat suggestions for these)
-- ============================================================

local adminOnlyCommands = {
    [Config.Commands.SET_PLAYER_JOB]    = true,
    [Config.Commands.REMOVE_PLAYER_JOB] = true,
}

local frameworkOnlyCommands = {
    [Config.Commands.FREE_PLAYER]        = true,
    [Config.Commands.SEARCH_PLAYER_QB]   = true,
}

-- ============================================================
--  REGISTER CHAT SUGGESTIONS ON CLIENT SIDE
-- ============================================================

CreateThread(function()
    if IsDuplicityVersion() then return end

    for cmdKey in pairs(Config.Commands) do
        local cmdName = Config.Commands[cmdKey]
        local fullCmd = ("/%s"):format(cmdName)

        -- Skip framework-only commands
        if frameworkOnlyCommands[cmdName] then goto continue end

        local params = Config.ChatSuggestions and Config.ChatSuggestions[cmdName] or {}
        local localeKey = ("COMMANDS_HELP_TEXT.%s"):format(cmdKey)
        local description = localeKey and _U(localeKey) or nil

        if params and next(params) then
            -- Skip admin-only commands if framework is not NONE
            if adminOnlyCommands[cmdName] and Config.Framework ~= Framework.NONE then
                goto continue
            end
            TriggerEvent("chat:addSuggestion", fullCmd, description, params)
        end

        ::continue::
    end
end)
