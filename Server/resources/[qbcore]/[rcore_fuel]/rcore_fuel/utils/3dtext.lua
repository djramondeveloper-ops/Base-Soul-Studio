--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

if not Config.Debug then
    return
end

local markers3d = {}
local nearMarkers3d = {}
local hasNearbyMarkers3d = false

CreateThread(function()
    while true do
        Wait(1000)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        hasNearbyMarkers3d = false

        for index, marker in pairs(markers3d) do
            if #(playerCoords - marker.position) < 15 then
                nearMarkers3d[marker.id] = marker
                hasNearbyMarkers3d = true
            else
                marker.rendering = false
                markers3d[index] = marker
                nearMarkers3d[marker.id] = nil
            end
        end
    end
end, "caching near v2 markers")

CreateThread(function()
    while true do
        Wait(333)

        if not hasNearbyMarkers3d then
            Wait(1000)
        end

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for index, marker in pairs(nearMarkers3d) do
            local canRenderForJob = true
            local renderJob = marker.getRenderJob()

            if renderJob ~= nil then
                canRenderForJob = IsAtJob(renderJob)
            end

            local distance = #(playerCoords - marker.position)

            if distance <= marker.renderDistance and not marker.destroyed and canRenderForJob then
                marker.rendering = true

                if distance <= marker.inRadius then
                    if marker.isIn == false and marker.onEnter ~= nil then
                        marker.onEnter()
                    end

                    marker.isIn = true
                elseif marker.isIn then
                    if marker.onLeave ~= nil then
                        marker.onLeave()
                    end

                    marker.isIn = false
                end
            else
                marker.rendering = false
            end

            nearMarkers3d[index] = marker
        end
    end
end)

CreateThread(function()
    while true do
        local sleep = 500

        if hasNearbyMarkers3d then
            for _, marker in pairs(nearMarkers3d) do
                local canRenderForJob = true
                local renderJob = marker.getRenderJob()

                if renderJob ~= nil then
                    canRenderForJob = IsAtJob(renderJob)
                end

                if marker.rendering and not marker.destroyed and marker.stopRendering == false and canRenderForJob then
                    sleep = 0
                    if marker.isIn then
                        for _, control in pairs(marker.keys) do
                            if IsControlJustReleased(0, control) and marker.onKey ~= nil then
                                marker.onKey(control)
                            end
                        end
                    end

                    draw3DText(marker.position, marker.text, marker)
                end
            end
        end

        Wait(sleep)
    end
end)

function create3DText(initialText)
    local marker = {
        id = #markers3d + 1,
        resource = GetCurrentResourceName(),
        text = initialText or "",
        renderDistance = 20,
        position = vector3(0, 0, 0),
        font = nil,
        scale = 0.1,
        size = 1.4,
        rendering = false,
        stopRendering = false,
        keys = {},
        onEnter = nil,
        onLeave = nil,
        onKey = nil,
        isIn = false,
        inRadius = 1.5,
        firstUpdate = true,
        destroyed = false,
        jobRendered = nil,
        color = { r = 255, g = 255, b = 255, a = 255 },
    }

    function marker.setRenderJob(jobName)
        marker.jobRendered = jobName
    end

    function marker.getRenderJob()
        return marker.jobRendered
    end

    function marker.getId()
        return marker.id
    end

    function marker.setScale(scale)
        marker.scale = scale
        marker.update()
        return marker
    end

    function marker.getScale()
        return marker.scale
    end

    function marker.setSize(size)
        marker.size = size
        marker.update()
        return marker
    end

    function marker.getSize()
        return marker.size
    end

    function marker.setPosition(position)
        marker.position = position
        marker.update()
        return marker
    end

    function marker.getPosition()
        return marker.position
    end

    function marker.setColor(color)
        marker.color = color
        marker.update()
    end

    function marker.getColor()
        return marker.color
    end

    function marker.setAlpha(alpha)
        marker.color.a = alpha
        marker.update()
    end

    function marker.getAlpha()
        return marker.color.a
    end

    function marker.setRed(red)
        marker.color.r = red
        marker.update()
    end

    function marker.getRed()
        return marker.color.r
    end

    function marker.setGreen(green)
        marker.color.g = green
        marker.update()
    end

    function marker.getGreen()
        return marker.color.g
    end

    function marker.setBlue(blue)
        marker.color.b = blue
        marker.update()
    end

    function marker.getBlue()
        return marker.color.b
    end

    function marker.setRenderDistance(renderDistance)
        marker.renderDistance = renderDistance
        marker.update()
        return marker
    end

    function marker.getRenderDistance()
        return marker.renderDistance
    end

    function marker.setFont(font)
        marker.font = font
        marker.update()
        return marker
    end

    function marker.getFont()
        return marker.font
    end

    function marker.setInRadius(inRadius)
        marker.inRadius = inRadius
        marker.update()
    end

    function marker.getInRadius()
        return marker.inRadius
    end

    function marker.render()
        marker.firstUpdate = false
        marker.stopRendering = false
        marker.update()
        return marker
    end

    function marker.stopRender()
        marker.stopRendering = true
        marker.rendering = false
        marker.update()
    end

    function marker.destroy(isDestroying)
        marker.stopRendering = true
        marker.rendering = false
        marker.destroyed = true
        marker.update(isDestroying)
    end

    function marker.isRendering()
        return marker.rendering
    end

    function marker.setKeys(keys)
        marker.keys = keys
        marker.update()
        return marker
    end

    function marker.setText(text)
        marker.text = text
        marker.update()
        return marker
    end

    function marker.getText()
        return marker.text
    end

    function marker.getKeys()
        return marker.keys
    end

    function marker.on(eventName, callback)
        eventName = string.lower(eventName)

        if eventName == "enter" then
            marker.onEnter = callback
        elseif eventName == "leave" then
            marker.onLeave = callback
        elseif eventName == "key" then
            marker.onKey = callback
        end

        marker.update()
    end

    function marker.update(isDestroying)
        if marker.firstUpdate then
            return
        end

        if isDestroying then
            for index, cachedMarker in pairs(nearMarkers3d) do
                if cachedMarker.getId() == marker.getId() then
                    nearMarkers3d[index] = nil
                end
            end

            for index, storedMarker in pairs(markers3d) do
                if storedMarker.getId() == marker.getId() then
                    markers3d[index] = nil
                end
            end
        else
            for index, storedMarker in pairs(markers3d) do
                if storedMarker.getId() == marker.getId() then
                    markers3d[index] = storedMarker
                end
            end
        end
    end

    table.insert(markers3d, marker)
    return marker
end

exports("create3DText", create3DText)

AddEventHandler("onResourceStop", function(resourceName)
    for _, marker in pairs(markers3d) do
        if marker.resource == resourceName then
            marker.destroy()
        end
    end
end)
