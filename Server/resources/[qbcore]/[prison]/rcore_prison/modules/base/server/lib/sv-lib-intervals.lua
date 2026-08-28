SIntervals = {}

RegisterCommand("intervals", function(source)
    if source == 0 and next(SIntervals) then
        tprint(SIntervals)
    end
end, false)

function SetServerInterval(intervalId, intervalMs, callback, onClear)
    if not intervalMs then
        return
    end

    local alreadyRunning = SIntervals[intervalId]

    if alreadyRunning then
        SIntervals[intervalId] = intervalMs
        return
    end

    SIntervals[intervalId] = intervalMs

    CreateThread(function()
        while true do
            local currentInterval = SIntervals[intervalId]

            if currentInterval == -1 then
                if onClear then
                    onClear(intervalId)
                end

                SIntervals[intervalId] = nil
                break
            end

            Wait(currentInterval)
            callback(currentInterval)

            if SIntervals[intervalId] == -1 then
                if onClear then
                    onClear(intervalId)
                end

                SIntervals[intervalId] = nil
                break
            end
        end
    end, "sv-lib-intervals code name: Phoenix")
end

function IsServerIntervalRunning(intervalId)
    return SIntervals[intervalId] ~= nil
end

function ClearServerInterval(intervalId)
    if SIntervals[intervalId] then
        SIntervals[intervalId] = -1
        dbg.debug("Interval with ID %s was cleared.", intervalId)
    end
end
