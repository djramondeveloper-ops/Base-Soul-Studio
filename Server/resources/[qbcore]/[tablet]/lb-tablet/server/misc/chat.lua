function GetChatMessages(accountTableSuffix, roomId, beforeMessageId)
    local params = { roomId }

    if beforeMessageId then
        params[#params + 1] = beforeMessageId
    end

    local query = [[
        SELECT
            m.id,
            m.message,
            m.attachments,
            m.sent_at,
            m.author,
            a.avatar,
            a.display_name
        FROM lbtablet_chat_rooms_messages m
        LEFT JOIN lbtablet_]] .. accountTableSuffix .. [[_accounts a
            ON a.id = m.author
        WHERE room_id = ?
    ]]

    if beforeMessageId then
        query = query .. " AND m.id < ?"
    end

    query = query .. [[
        ORDER BY sent_at DESC
        LIMIT 25
    ]]

    return MySQL.query.await(query, params)
end

function GetUndreadChatNotifications(_, accountId)
    local total = MySQL.scalar.await(
        "SELECT SUM(notifications) FROM lbtablet_chat_rooms_members WHERE `account` = ? AND notifications > 0",
        { accountId }
    )

    total = tonumber(total) or 0
    return total
end

function GetPublicChatRooms(job, tabletId, page, search)
    if search ~= "" and type(search) ~= "string" then
        search = nil
    end

    local query = [[
        SELECT
            id,
            label,
            icon AS avatar,
            creator,
            last_message AS lastMessage,
            last_updated AS `timestamp`
        FROM lbtablet_chat_rooms
        WHERE terminal_type = @job AND private = 0
    ]]

    if search then
        query = query .. " AND label LIKE @search"
    end

    query = query .. [[
        ORDER BY last_updated DESC
        LIMIT @page, @perPage
    ]]

    return MySQL.query.await(query, {
        ["@job"] = job,
        ["@search"] = "%" .. (search or "") .. "%",
        ["@tabletId"] = tabletId,
        ["@page"] = (page or 0) * 25,
        ["@perPage"] = 25
    })
end

function GetChatRooms(job, tabletId, page, search)
    if search ~= "" and type(search) ~= "string" then
        search = nil
    end

    local query = [[
        SELECT
            id,
            label,
            icon AS avatar,
            creator,
            last_message AS lastMessage,
            last_updated AS `timestamp`,
            m.notifications,
            private
        FROM lbtablet_chat_rooms
        INNER JOIN lbtablet_chat_rooms_members m
            ON m.room_id = lbtablet_chat_rooms.id
        WHERE
            terminal_type = @job
            AND m.account = @tabletId
    ]]

    if search then
        query = query .. " AND label LIKE @search"
    end

    query = query .. [[
        ORDER BY last_updated DESC
        LIMIT @page, @perPage
    ]]

    local rooms = MySQL.query.await(query, {
        ["@job"] = job,
        ["@tabletId"] = tabletId,
        ["@search"] = "%" .. (search or "") .. "%",
        ["@page"] = (page or 0) * 25,
        ["@perPage"] = 25
    })

    for i = 1, #rooms do
        rooms[i].creator = rooms[i].creator == tabletId
    end

    return rooms
end

function CreateChatRoom(job, creatorTabletId, label, isPrivate)
    local roomId = MySQL.insert.await([[
        INSERT INTO lbtablet_chat_rooms (terminal_type, label, private, creator)
        VALUES (?, ?, ?, ?)
    ]], {
        job,
        label,
        isPrivate == true,
        creatorTabletId
    })

    MySQL.update.await(
        "INSERT INTO lbtablet_chat_rooms_members (room_id, account) VALUES (?, ?)",
        { roomId, creatorTabletId }
    )

    return roomId
end

function ToggleChatRoomPrivate(roomId, isPrivate)
    local changed = MySQL.update.await(
        "UPDATE lbtablet_chat_rooms SET private = ? WHERE id = ?",
        { isPrivate, roomId }
    ) > 0

    if changed then
        TriggerClientEvent("tablet:chat:setPrivate", -1, roomId, isPrivate)
    end

    return changed
end

function SetChatRoomIcon(roomId, icon)
    local changed = MySQL.update.await(
        "UPDATE lbtablet_chat_rooms SET icon = ? WHERE id = ?",
        { icon, roomId }
    ) > 0

    if changed then
        TriggerClientEvent("tablet:chat:setIcon", -1, roomId, icon)
    end

    return changed
end

function AddToChatRoom(job, roomId, accountId)
    local added = MySQL.update.await(
        "INSERT IGNORE INTO lbtablet_chat_rooms_members (room_id, account) VALUES (?, ?)",
        { roomId, accountId }
    ) > 0

    local targetSource = GetSourceFromIdentifier(accountId)

    if added and targetSource then
        local room = MySQL.single.await([[
            SELECT
                id,
                label,
                icon AS avatar,
                last_message AS lastMessage,
                last_updated AS `timestamp`,
                m.notifications,
                private
            FROM lbtablet_chat_rooms
            INNER JOIN lbtablet_chat_rooms_members m
                ON m.room_id = lbtablet_chat_rooms.id
            WHERE
                terminal_type = ?
                AND m.account = ?
                AND lbtablet_chat_rooms.id = ?
        ]], {
            job,
            accountId,
            roomId
        })

        if room then
            TriggerClientEvent("tablet:chat:joinRoom", targetSource, room)
        end
    end

    return added
end

function GetChatRoomMembers(accountTableSuffix, roomId)
    local query = [[
        SELECT
            a.display_name AS `name`,
            m.account AS id
        FROM lbtablet_chat_rooms_members m
        LEFT JOIN lbtablet_]] .. accountTableSuffix .. [[_accounts a
            ON a.id = m.account
        WHERE m.room_id = ?
    ]]

    return MySQL.query.await(query, { roomId })
end

function RemoveMemberFromChatRoom(roomId, accountId)
    local removed = MySQL.update.await(
        "DELETE FROM lbtablet_chat_rooms_members WHERE room_id = ? AND account = ?",
        { roomId, accountId }
    ) > 0

    local targetSource = GetSourceFromIdentifier(accountId)

    if removed and targetSource then
        TriggerClientEvent("tablet:chat:leaveRoom", targetSource, roomId)
    end

    return removed
end

function LeaveChatRoom(accountId, roomId)
    local removed = MySQL.update.await(
        "DELETE FROM lbtablet_chat_rooms_members WHERE room_id = ? AND account = ?",
        { roomId, accountId }
    ) > 0

    if not removed then
        return false
    end

    local isPrivate = MySQL.scalar.await(
        "SELECT private FROM lbtablet_chat_rooms WHERE id = ?",
        { roomId }
    )

    if not isPrivate then
        return true
    end

    local memberCount = MySQL.scalar.await(
        "SELECT COUNT(1) FROM lbtablet_chat_rooms_members WHERE room_id = ?",
        { roomId }
    )

    if memberCount == 0 then
        MySQL.update.await("DELETE FROM lbtablet_chat_rooms WHERE id = ?", { roomId })
    end

    return true
end

function SendChatMessage(sender, roomId, content, attachments)
    local authorId = sender.id

    if type(content) ~= "string" or #content == 0 then
        content = nil
    end

    if type(attachments) ~= "table" or #attachments == 0 then
        attachments = nil
    end

    if not content and not attachments then
        return false
    end

    local messageId = MySQL.insert.await([[
        INSERT INTO lbtablet_chat_rooms_messages (room_id, author, message, attachments)
        VALUES (@roomId, @author, @message, @attachments)
    ]], {
        ["@roomId"] = roomId,
        ["@author"] = authorId,
        ["@message"] = content,
        ["@attachments"] = attachments and json.encode(attachments) or nil
    })

    if not messageId then
        return false
    end

    MySQL.update.await(
        "UPDATE lbtablet_chat_rooms_members SET notifications = notifications + 1 WHERE room_id = ? AND account != ?",
        { roomId, authorId }
    )

    MySQL.update.await(
        "UPDATE lbtablet_chat_rooms SET last_message = ? WHERE id = ?",
        { content or "<!ATTACHMENT!>", roomId }
    )

    TriggerClientEvent("tablet:chat:newMessage", -1, {
        id = roomId,
        message = {
            id = messageId,
            content = content,
            attachments = attachments,
            timestamp = os.time() * 1000,
            sender = sender
        }
    })

    return messageId
end