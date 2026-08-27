local dui = {}
local screenW, screenH = GetActualScreenResolution()

function dui.register()
    if dui.instance then
        dui.instance:remove()
    end

    dui.instance = lib.dui:new(
        {
            url = ('nui://%s/web/hidden.html'):format(cache.resource),
            width = screenW,
            height = screenH,
        }
    )
end

dui.register()

return dui
