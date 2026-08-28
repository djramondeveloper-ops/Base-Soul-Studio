local jobMenuId = MENU_ID_LIST.JOB_MENU
local jobMenuRows = {}

function OpenJobMenu()
    local rows = {
        {
            header = _U("MENU.JOB_TITLE"),
            isMenuHeader = true
        }
    }

    jobMenuRows = rows

    for jobIndex = 1, #SH.data.jobs do
        local jobData = SH.data.jobs[jobIndex]

        rows[#rows + 1] = {
            header = jobData.name,
            description = jobData.description or "No description",
            order = jobIndex,
            params = {
                isServer = true,
                event = "rcore_prison:server:requestJob",
                args = jobIndex
            }
        }
    end

    Frontend:CreateMenu(
        jobMenuId,
        _U("MENU.JOB_TITLE"),
        jobMenuRows,
        true
    )
end