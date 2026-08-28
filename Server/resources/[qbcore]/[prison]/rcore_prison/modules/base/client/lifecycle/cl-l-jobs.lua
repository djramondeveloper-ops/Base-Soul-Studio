local function onStartJob(success, jobId, ...)
    if not success then
        return
    end

    Jobs.Init(jobId, ...)
end

NetworkService.RegisterNetEvent("startJob", onStartJob)

local function onOpenJobMenu(success)
    if not success then
        return
    end

    OpenJobMenu()
end

NetworkService.RegisterNetEvent("openJobMenu", onOpenJobMenu)