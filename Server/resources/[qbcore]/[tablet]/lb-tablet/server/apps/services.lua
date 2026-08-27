local lastCompaniesRefresh = 0
local companiesRefreshInterval = 60

BaseCallback("services:getCompanies", function(source, tabletId)
    if (lastCompaniesRefresh + companiesRefreshInterval) < os.time() then
        if RefreshCompanies then
            RefreshCompanies()
            lastCompaniesRefresh = os.time()
        end
    end

    return Config.Services.Companies
end)

BaseCallback("services:getEmployeeList", function(source, tabletId, companyName)
    local seeEmployees = Config.Services.SeeEmployees

    if not seeEmployees or seeEmployees == "none" or not GetEmployeeList then
        return false
    end

    if seeEmployees == "employees" then
        local job = GetJob(source)

        if not job or job.name ~= companyName then
            return false
        end
    end

    return GetEmployeeList(companyName)
end)

BaseCallback("services:getRecentMessages", function(source, tabletId, page)
    page = page or 0

    local job = GetJob(source)
    if not job or not job.name then
        return {}
    end

    return MySQL.query.await([[
        SELECT
            id,
            phone_number AS `number`,
            company,
            last_message AS lastMessage,
            `timestamp`
        FROM
            phone_services_channels
        WHERE
            company = ?
            AND last_message IS NOT NULL
        ORDER BY
            `timestamp` DESC
        LIMIT
            ?, ?
    ]], {
        job.name,
        page * 25,
        25
    })
end)

BaseCallback("services:getMessages", function(source, tabletId, channelId, lastMessageId)
    local params = { channelId }
    local extraFilter = ""

    if lastMessageId then
        extraFilter = "AND id < ?"
        params[#params + 1] = lastMessageId
    end

    return MySQL.query.await(([[
        SELECT
            id,
            sender,
            message AS content,
            x_pos,
            y_pos,
            `timestamp`
        FROM
            phone_services_messages
        WHERE
            channel_id = ?
            %s
        ORDER BY
            id DESC
        LIMIT
            25
    ]]):format(extraFilter), params)
end)