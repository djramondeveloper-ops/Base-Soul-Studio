ReactCallback("VoiceMemo", function(data)
    local action = data.action

    if action == "upload" then
        local memoData = data.data
        return AwaitCallback(
            "voiceMemo:saveRecording",
            memoData.src,
            memoData.duration,
            memoData.title
        )
    elseif action == "get" then
        return AwaitCallback("voiceMemo:getMemos")
    elseif action == "delete" then
        return AwaitCallback("voiceMemo:deleteMemo", data.id)
    elseif action == "rename" then
        return AwaitCallback("voiceMemo:renameMemo", data.id, data.title)
    end
end)