local lobbyMenuId = MENU_ID_LIST.LOBBY_MENU

function OpenLobbyMenu()
    local rows = {
        {
            header = _U("MENU.LOBBY_TITLE"),
            isMenuHeader = true
        },
        {
            type = "button",
            header = _U("MENU.LOBBY_RESTORE_OUTFIT_TITLE"),
            description = _U("MENU.LOBBY_RESTORE_OUTFIT_DESC"),
            params = {
                isClient = true,
                event = "rcore_prison:executeTask",
                args = "restoreOutfit"
            }
        },
        {
            type = "button",
            header = _U("MENU.LOBBY_RETURN_STASHED_ITEMS_TITLE"),
            description = _U("MENU.LOBBY_RETURN_STASHED_ITEMS_DESC"),
            params = {
                isServer = true,
                event = "rcore_prison:server:requestStashedItems",
                args = SH.zoneId
            }
        }
    }

    Frontend:CreateMenu(
        lobbyMenuId,
        _U("MENU.LOBBY_TITLE"),
        rows,
        true
    )
end