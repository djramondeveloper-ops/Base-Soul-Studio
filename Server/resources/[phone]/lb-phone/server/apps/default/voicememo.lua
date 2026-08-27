-- ================================================================
-- LB Phone - Voice Memo App Server Handler
-- Manages voice recording functionality for the phone voice memo application
-- ================================================================

-- Save a voice recording to the database
-- This callback handles voice memo recording storage with validation
-- Parameters: source, phoneNumber, recordingData (object with src, duration, title)
BaseCallback("voiceMemo:saveRecording", function(source, phoneNumber, recordingData)
    -- Validate that recording data contains required fields
    -- Both source URL and duration are mandatory for a valid recording
    if not recordingData.src or not recordingData.duration then
        debugprint("VoiceMemo: no src/duration, not saving")
        return -- Exit early if validation fails
    end
    
    -- Insert the voice recording into database with all required parameters
    local insertQuery = "INSERT INTO phone_voice_memos_recordings (phone_number, file_name, file_url, file_length) VALUES (?, ?, ?, ?)"
    local insertParams = {
        phoneNumber,                                    -- Phone number this recording belongs to
        recordingData.title or "Unknown",              -- Recording title (default to "Unknown" if not provided)
        recordingData.src,                              -- File URL/path to the audio recording
        recordingData.duration                          -- Duration of the recording in seconds/milliseconds
    }
    
    -- Execute the insert operation and return the result
    -- Usually returns the new recording ID for client reference
    return MySQL.insert.await(insertQuery, insertParams)
end)
-- Get all voice memos for a specific phone number
-- This callback retrieves all voice recordings from the database
-- Returns data formatted for the client-side voice memo interface
BaseCallback("voiceMemo:getMemos", function(source, phoneNumber)
    -- Query database for all voice recordings belonging to this phone number
    -- Results are ordered by creation date (newest first) for better UX
    -- Column aliases match the expected client-side format
    local memosQuery = "SELECT id, file_name AS `title`, file_url AS `src`, file_length AS `duration`, created_at AS `timestamp` FROM phone_voice_memos_recordings WHERE phone_number = ? ORDER BY created_at DESC"
    local queryParams = { phoneNumber }
    
    -- Execute the query and return formatted results directly to client
    -- Data is already aliased to match client expectations:
    -- - file_name becomes 'title'
    -- - file_url becomes 'src' 
    -- - file_length becomes 'duration'
    -- - created_at becomes 'timestamp'
    return MySQL.query.await(memosQuery, queryParams)
end, {})
-- Delete a specific voice memo recording
-- This callback permanently removes a voice recording from the database
-- Parameters: source, phoneNumber, memoId
BaseCallback("voiceMemo:deleteMemo", function(source, phoneNumber, memoId)
    -- Delete the specified voice memo with security validation
    -- Only allows deletion of recordings that belong to the requesting phone number
    local deleteQuery = "DELETE FROM phone_voice_memos_recordings WHERE id = ? AND phone_number = ?"
    local deleteParams = {
        memoId,         -- Specific voice memo ID to delete
        phoneNumber     -- Security: ensure memo belongs to this phone
    }
    
    -- Execute the delete operation
    local affectedRows = MySQL.update.await(deleteQuery, deleteParams)
    
    -- Return true if the voice memo was successfully deleted (affected rows > 0)
    -- Return false if memo wasn't found or didn't belong to this phone
    return affectedRows > 0
end)
-- Rename/retitle a voice memo recording
-- This callback updates the display name/title of an existing voice memo
-- Parameters: source, phoneNumber, memoId, newMemoName
BaseCallback("renameMemo", function(source, phoneNumber, memoId, newMemoName)
    -- Update the file name (display title) of the specified voice memo
    -- Security validation ensures only the memo owner can rename it
    local updateQuery = "UPDATE phone_voice_memos_recordings SET file_name = ? WHERE id = ? AND phone_number = ?"
    local updateParams = {
        newMemoName,    -- New display name/title for the voice memo
        memoId,         -- Specific voice memo ID to update
        phoneNumber     -- Security: ensure memo belongs to this phone
    }
    
    -- Execute the update operation
    local affectedRows = MySQL.update.await(updateQuery, updateParams)
    
    -- Return true if the voice memo was successfully renamed (affected rows > 0)
    -- Return false if memo wasn't found or didn't belong to this phone
    return affectedRows > 0
end)
