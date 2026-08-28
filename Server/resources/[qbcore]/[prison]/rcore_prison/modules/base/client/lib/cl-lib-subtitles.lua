Subtitles = type(_G.Subtitles) == 'table' and _G.Subtitles or {}

function Subtitles.Show(text)
    FrontendService.SendReactMessage(FE_EVENTS.SUBTITLES, {
        visible = true,
        text = text,
        position = Config.Subtitles.Position or "bottom-center",
    })
end

function Subtitles.Hide()
    FrontendService.SendReactMessage(FE_EVENTS.SUBTITLES, {
        visible = false,
    })
end