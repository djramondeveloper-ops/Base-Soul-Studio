BaseCallback("notes:create", function(source, tabletId, title, content)
    return MySQL.insert.await(
        "INSERT INTO lbtablet_notes (tablet_id, title, content) VALUES (?, ?, ?)",
        { tabletId, title, content }
    )
end)

BaseCallback("notes:save", function(source, tabletId, noteId, title, content)
    local affectedRows = MySQL.update.await(
        "UPDATE lbtablet_notes SET title = ?, content = ? WHERE id = ? AND tablet_id = ?",
        { title, content, noteId, tabletId }
    )

    return affectedRows > 0
end)

BaseCallback("notes:fetch", function(source, tabletId, page)
    local offset = (page or 0) * 15

    return MySQL.query.await([[
        SELECT id, title, content, updated_at
        FROM lbtablet_notes
        WHERE tablet_id = ?
        ORDER BY updated_at DESC
        LIMIT ?, 15
    ]], { tabletId, offset })
end)

BaseCallback("notes:remove", function(source, tabletId, noteId)
    local affectedRows = MySQL.update.await(
        "DELETE FROM lbtablet_notes WHERE id = ? AND tablet_id = ?",
        { noteId, tabletId }
    )

    return affectedRows > 0
end)