RegisterNuiCallback("getLogs", function(data, cb)
    local logs = callback.await("rcore_prison:server:getAllLogs", false, data)
    cb(logs)
end)