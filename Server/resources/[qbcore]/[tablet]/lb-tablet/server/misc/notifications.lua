local function PrepareNotificationParams(data)
    if data.title and not data.content then
        data.content = data.title
        data.title = data.app
    end

    assert(type(data.app) == "string", "app must be a string")
    assert(type(data.title) == "string", "title must be a string")
    assert(type(data.content) == "string", "content must be a string")
    assert(data.thumbnail == nil or type(data.thumbnail) == "string", "thumbnail must be a string or nil")
    assert(data.avatar == nil or type(data.avatar) == "string", "avatar must be a string or nil")
    assert(data.showAvatar == nil or type(data.showAvatar) == "boolean", "showAvatar must be a boolean or nil")
    assert(data.customData == nil or type(data.customData) == "table", "customData must be a table or nil")

    return {
        ["@app"] = data.app,
        ["@title"] = data.title,
        ["@content"] = data.content,
        ["@thumbnail"] = data.thumbnail,
        ["@avatar"] = data.avatar,
        ["@showAvatar"] = data.showAvatar == true,
        ["@customData"] = data.customData and json.encode(data.customData) or nil
    }
end

function SendNotification(data)
    local tabletId = data.tabletId
    local source = data.source
    local notificationId = nil

    if not tabletId and not source then
        error("tabletId or source must be provided")
    end

    local params = PrepareNotificationParams(data)

    if source ~= -1 and not tabletId then
        tabletId = GetEquippedTablet(source)
    end

    if tabletId and not source then
        source = GetSourceFromTablet(tabletId)
    end

    if source ~= -1 and tabletId and not data.dontSaveToDatabase then
        params["@tabletId"] = tabletId

        notificationId = MySQL.insert.await([[
            INSERT INTO lbtablet_notifications
                (tablet_id, app, title, content, thumbnail, avatar, show_avatar, custom_data)
            VALUES
                (@tabletId, @app, @title, @content, @thumbnail, @avatar, @showAvatar, @customData)
        ]], params)
    end

    if source then
        data.id = notificationId
        TriggerClientEvent("tablet:notifications:new", source, data)
    end

    return notificationId
end

exports("SendNotification", SendNotification)

function NotifyEveryone(data, saveToDatabase)
    local params = PrepareNotificationParams(data)

    if saveToDatabase then
        MySQL.update([[
            INSERT INTO lbtablet_notifications
                (tablet_id, app, title, content, thumbnail, avatar, show_avatar, custom_data)
            SELECT
                id, @app, @title, @content, @thumbnail, @avatar, @showAvatar, @customData
            FROM
                lbtablet_tablets
        ]], params)
    end

    TriggerClientEvent("tablet:notifications:new", -1, data)
end

exports("NotifyEveryone", NotifyEveryone)

function NotifyTablets(tabletIds, data, excludeTablets)
    if not tabletIds or #tabletIds == 0 then
        debugprint("NotifyTablets: No tablet ids provided")
        return
    end

    local params = PrepareNotificationParams(data)
    params["@tabletIds"] = tabletIds
    params["@excludeTablets"] = excludeTablets

    debugprint("NotifyTablets", params)

    local query = [[
        INSERT INTO lbtablet_notifications
            (tablet_id, app, title, content, thumbnail, avatar, show_avatar, custom_data)
        SELECT
            id, @app, @title, @content, @thumbnail, @avatar, @showAvatar, @customData
        FROM
            lbtablet_tablets
        WHERE
            id IN (@tabletIds)
    ]]

    if excludeTablets then
        query = query .. " AND id NOT IN (@excludeTablets)"
    end

    query = query .. [[
        RETURNING
            id, tablet_id
    ]]

    MySQL.query(query, params, function(results)
        for i = 1, #results do
            local row = results[i]
            local targetSource = GetSourceFromTablet(row.tablet_id)

            if targetSource then
                data.id = row.id
                TriggerClientEvent("tablet:notifications:new", targetSource, data)
            end
        end
    end)
end

exports("NotifyTablets", NotifyTablets)

BaseCallback("notifications:get", function(_, tabletId)
    return MySQL.query.await([[
        SELECT
            id,
            app,
            title,
            content,
            thumbnail,
            avatar,
            show_avatar AS showAvatar,
            custom_data AS customData,
            received_at AS `timestamp`
        FROM
            lbtablet_notifications
        WHERE
            tablet_id = ?
        ORDER BY
            received_at DESC
    ]], { tabletId })
end)

BaseCallback("notifications:delete", function(_, tabletId, notificationId)
    local affectedRows = MySQL.update.await(
        "DELETE FROM lbtablet_notifications WHERE id = ? AND tablet_id = ?",
        { notificationId, tabletId }
    )

    return affectedRows > 0
end)

BaseCallback("notifications:clear", function(_, tabletId, app)
    local affectedRows = MySQL.update.await(
        "DELETE FROM lbtablet_notifications WHERE tablet_id = ? AND app = ?",
        { tabletId, app }
    )

    return affectedRows > 0
end)

MySQL.ready(function()
    if not Config.AutoDeleteNotifications then
        return
    end

    while not DatabaseCheckerFinished do
        Wait(500)
    end

    local maxHours = 168

    if type(Config.AutoDeleteNotifications) == "number" and Config.AutoDeleteNotifications > 0 then
        maxHours = math.floor(Config.AutoDeleteNotifications)
    end

    SetInterval(function()
        debugprint("Deleting old notifications...")

        local deletedRows = MySQL.update.await(
            "DELETE FROM lbtablet_notifications WHERE received_at < DATE_SUB(NOW(), INTERVAL ? HOUR)",
            { maxHours }
        )

        debugprint("Deleted " .. deletedRows .. " old notifications")
    end, 3600000)
end)