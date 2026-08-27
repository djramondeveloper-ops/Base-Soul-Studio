local errorCount = 0

RegisterNetEvent("tablet:logError", function(message, stack, componentStack)
    if errorCount >= 5 then
        return
    end

    errorCount = errorCount + 1

    SetTimeout(3600000, function()
        errorCount = errorCount - 1
    end)

    local version = GetResourceMetadata(GetCurrentResourceName(), "version", 0) or "unknown"

    print(("[lb-tablet] UI error captured | version=%s | message=%s"):format(version, tostring(message)))
    if stack and stack ~= "" then
        print(("[lb-tablet] stack: %s"):format(tostring(stack):sub(1, 800)))
    end
    if componentStack and componentStack ~= "" then
        print(("[lb-tablet] componentStack: %s"):format(tostring(componentStack):sub(1, 800)))
    end
end)
