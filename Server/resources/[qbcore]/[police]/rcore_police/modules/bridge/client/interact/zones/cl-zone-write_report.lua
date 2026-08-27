-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function WriteReport(internalZone)
    if not internalZone then
        return
    end
    local zone = internalZone.getZoneData()
    local retval = UI.Input(_U("REPORTS.INPUT_TITLE"), {
        {
            label = _U("REPORTS.INPUT_YOUR_NAME"),
            placeholder = "",
            type = "input",
            required = true
        },
        {
            label = _U("REPORTS.INPUT_PHONE_NUMBER"),
            placeholder = "",
            type = "input",
            required = true
        },
        {
            label = _U("REPORTS.INPUT_DETAILS"),
            placeholder = "",
            type = "textarea",
            required = true,
            limit = Config.Reports.InputWriteLimit or 60
        },
    })
    if not retval then return end
    local name = retval[tostring(0)]
    local phone = retval[tostring(1)]
    local message = retval[tostring(2)]
    local payload = {
        player = name,
        phone = phone,
        message = message,
    }
    TriggerServerEvent("rcore_police:server:sendReport", zone, payload)
end
