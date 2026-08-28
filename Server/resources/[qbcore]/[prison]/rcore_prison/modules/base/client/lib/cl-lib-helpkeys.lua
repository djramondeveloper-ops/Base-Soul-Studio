HelpKeys = type(_G.HelpKeys) == 'table' and _G.HelpKeys or {}

function HelpKeys.Show(helpKeys, position)
    FrontendService.SendReactMessage("loadApp", {
        visible = true,
        screen = Screens.HELPKEYS,
        help = {
            visible = true,
            helpKeys = helpKeys,
            position = position or "top-left",
            marginVertical = "30px",
            marginHorizontal = "30px",
            asColumn = true
        }
    })
end

function HelpKeys.Hide()
    FrontendService.SendReactMessage("loadApp", {
        visible = false,
        help = {
            visible = false
        }
    }, false)
end

function HelpKeys.ShowNavigationKeysInMenu()
    HelpKeys.Show({
        {
            label = _U("HELPKEYS_LABELS.CONFIRM"),
            keyName = "Enter"
        },
        {
            label = _U("HELPKEYS_LABELS.EXIT_MENU"),
            keyName = "BACKSPACE"
        }
    }, "top-left")
end

function HelpKeys.ShowZoneInteractionKeys()
    HelpKeys.Show({
        {
            label = _U("HELPKEYS_LABELS.INTERACT"),
            keyName = Config.Zone.HelpkeysInteractKeyName or "E"
        }
    }, Config.Helpkeys.Position)
end