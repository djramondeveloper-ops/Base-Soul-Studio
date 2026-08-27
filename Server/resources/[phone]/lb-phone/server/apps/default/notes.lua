-- ================================================================
-- LB Phone - Notes App Server Handler
-- Manages note-taking functionality for the phone notes application
-- ================================================================

-- Create a new note for the specified phone number
-- This callback handles note creation with title and content
-- Parameters: source, phoneNumber, noteTitle, noteContent
BaseCallback("notes:createNote", function(source, phoneNumber, noteTitle, noteContent)
    -- Insert new note into database with all required parameters
    -- The note will be automatically timestamped by the database
    local insertQuery = "INSERT INTO phone_notes (phone_number, title, content) VALUES (?, ?, ?)"
    local insertParams = {
        phoneNumber,    -- Phone number this note belongs to
        noteTitle,      -- Title/subject of the note
        noteContent     -- Main content/body of the note
    }
    
    -- Execute the insert operation and return the result
    -- Usually returns the new note ID for client reference
    return MySQL.insert.await(insertQuery, insertParams)
end)
-- Save/update an existing note
-- This callback modifies the title and content of an existing note
-- Parameters: source, phoneNumber, noteId, newTitle, newContent
BaseCallback("notes:saveNote", function(source, phoneNumber, noteId, newTitle, newContent)
    -- Update both title and content of the specified note
    -- Security validation ensures only the note owner can modify it
    local updateQuery = "UPDATE phone_notes SET title = ?, content = ? WHERE id = ? AND phone_number = ?"
    local updateParams = {
        newTitle,       -- Updated note title/subject
        newContent,     -- Updated note content/body
        noteId,         -- Specific note ID to update
        phoneNumber     -- Security: ensure note belongs to this phone
    }
    
    -- Execute the update operation
    local affectedRows = MySQL.update.await(updateQuery, updateParams)
    
    -- Return true if the note was successfully updated (affected rows > 0)
    -- Return false if note wasn't found or didn't belong to this phone
    return affectedRows > 0
end)
-- Remove/delete a specific note
-- This callback permanently deletes a note from the database
-- Parameters: source, phoneNumber, noteId
BaseCallback("notes:removeNote", function(source, phoneNumber, noteId)
    -- Delete the specified note with security validation
    -- Only allows deletion of notes that belong to the requesting phone number
    local deleteQuery = "DELETE FROM phone_notes WHERE id = ? AND phone_number = ?"
    local deleteParams = {
        noteId,         -- Specific note ID to delete
        phoneNumber     -- Security: ensure note belongs to this phone
    }
    
    -- Execute the delete operation
    local affectedRows = MySQL.update.await(deleteQuery, deleteParams)
    
    -- Return true if the note was successfully deleted (affected rows > 0)
    -- Return false if note wasn't found or didn't belong to this phone
    return affectedRows > 0
end)
-- Get all notes for a specific phone number
-- This callback retrieves all notes from the database for display
-- Parameters: source, phoneNumber
BaseCallback("notes:getNotes", function(source, phoneNumber)
    -- Query database for all notes belonging to this phone number
    -- Includes all note data: ID, title, content, and creation timestamp
    local notesQuery = "SELECT id, title, content, `timestamp` FROM phone_notes WHERE phone_number = ?"
    local queryParams = { phoneNumber }
    
    -- Execute the query and return all notes directly to client
    -- Results will be automatically formatted for the notes interface
    return MySQL.query.await(notesQuery, queryParams)
end)
