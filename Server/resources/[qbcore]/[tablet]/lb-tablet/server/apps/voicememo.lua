BaseCallback("voiceMemo:saveRecording", function(source, tabletId, fileUrl, duration, fileName)
    if not fileUrl or not duration then
        debugprint("VoiceMemo: no url/duration, not saving")
        return
    end

    return MySQL.insert.await(
        "INSERT INTO lbtablet_voice_memo_recordings (tablet_id, file_name, file_url, file_length) VALUES (?, ?, ?, ?)",
        {
            tabletId,
            fileName or "??",
            fileUrl,
            duration
        }
    )
end)

BaseCallback("voiceMemo:getMemos", function(source, tabletId)
    return MySQL.query.await(
        "SELECT id, file_name AS `title`, file_url AS `src`, file_length AS `duration`, created_at AS `timestamp` FROM lbtablet_voice_memo_recordings WHERE tablet_id = ? ORDER BY created_at DESC",
        { tabletId }
    )
end, {})

BaseCallback("voiceMemo:deleteMemo", function(source, tabletId, memoId)
    local affectedRows = MySQL.update.await(
        "DELETE FROM lbtablet_voice_memo_recordings WHERE id = ? AND tablet_id = ?",
        { memoId, tabletId }
    )

    return affectedRows > 0
end)

BaseCallback("renameMemo", function(source, tabletId, memoId, newName)
    local affectedRows = MySQL.update.await(
        "UPDATE lbtablet_voice_memo_recordings SET file_name = ? WHERE id = ? AND tablet_id = ?",
        { newName, memoId, tabletId }
    )

    return affectedRows > 0
end)