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

function CreateProgressBarAtLocation()
    local progressBar = {
        rendering = false,
        text = "",
        progressText = "",
        progressbarTime = 10,
        percentageLeft = 1.0,
        originalProgressbarTime = 10,
        distance = 15,
        coords = vector3(0, 0, 0),
    }

    function progressBar.SetDescription(description)
        progressBar.text = description
    end

    function progressBar.SetProgressBarTime(durationMs)
        progressBar.progressbarTime = math.ceil(durationMs / 1000)
        progressBar.originalProgressbarTime = progressBar.progressbarTime
    end

    function progressBar.SetDistance(renderDistance)
        progressBar.distance = renderDistance
    end

    function progressBar.SetPosition(coords)
        progressBar.coords = coords
    end

    function progressBar.UpdateRenderingText()
        local colorCode = Config.ColorOfProgressBar or "b"
        progressBar.progressText = "~" .. colorCode .. "~"
        progressBar.percentageLeft = progressBar.progressbarTime / progressBar.originalProgressbarTime

        local filledBars = math.floor(30 * progressBar.percentageLeft) + 1

        for barIndex = filledBars, 30 do
            progressBar.progressText = progressBar.progressText .. "|"
        end

        progressBar.progressText = progressBar.progressText .. "~w~"

        for _ = 1, filledBars - 1 do
            progressBar.progressText = progressBar.progressText .. "|"
        end
    end

    function progressBar.Create()
        progressBar.rendering = true
        progressBar.UpdateRenderingText()

        CreateThread(function()
            local playerPed = PlayerPedId()

            while progressBar.rendering do
                Wait(0)

                if #(GetEntityCoords(playerPed) - progressBar.coords) < progressBar.distance then
                    draw3DText(
                        progressBar.coords,
                        string.format(
                            [=[%s

%.1f%%
[%s]]=],
                            progressBar.text,
                            100 - (100 * progressBar.percentageLeft),
                            progressBar.progressText
                        ),
                        { size = 0.6 }
                    )
                else
                    Wait(1000)
                end
            end
        end, "Draw 3D text for progress bar tread")

        CreateThread(function()
            while progressBar.rendering do
                Wait(1000)

                progressBar.progressbarTime = progressBar.progressbarTime - 1
                progressBar.UpdateRenderingText()

                if progressBar.progressbarTime < 0 then
                    progressBar.progressbarTime = 0
                    progressBar.UpdateRenderingText()
                    progressBar.progressText = _U("3d_text_completed")
                    return
                end
            end
        end, "progress bar with time update")
    end

    function progressBar.IsCompleted()
        return progressBar.progressbarTime <= 0
    end

    function progressBar.Delete()
        progressBar.rendering = false
    end

    return progressBar
end
