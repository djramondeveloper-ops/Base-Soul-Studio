Text = type(_G.Text) == 'table' and _G.Text or {}

function Text.Show(label, position)
    FrontendService.SendReactMessage(FE_EVENTS.TEXT_UI, {
        text = {
            visible = true,
            text = {
                {
                    label = label,
                },
            },
            position = position or "bottom-right",
            marginVertical = "30px",
            marginHorizontal = "30px",
            asColumn = true,
        },
    })
end

function Text.Hide()
    FrontendService.SendReactMessage(FE_EVENTS.TEXT_UI, {
        text = {
            visible = false,
            text = {},
        },
    }, false)
end