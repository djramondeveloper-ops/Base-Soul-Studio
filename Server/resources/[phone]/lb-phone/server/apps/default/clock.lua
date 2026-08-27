-- ================================================================
-- LB Phone - Clock App Server Handler
-- Manages alarm system for the phone clock application
-- ================================================================

-- Get all alarms for a specific phone number
-- This callback retrieves all alarm entries from the database
-- including their configuration and enabled status
BaseCallback("clock:getAlarms", function(source, phoneNumber)
    -- Query database for all alarms belonging to this phone number
    -- Returns: id, hours, minutes, label, enabled status
    local alarmQuery = "SELECT id, hours, minutes, label, enabled FROM phone_clock_alarms WHERE phone_number = ?"
    local queryParams = { phoneNumber }
    
    -- Execute the query and return results directly to client
    return MySQL.query.await(alarmQuery, queryParams)
end, {})
-- Create a new alarm for the specified phone number
-- This callback handles alarm creation with all necessary parameters
-- Parameters: source, phoneNumber, alarmLabel, hours, minutes
BaseCallback("clock:createAlarm", function(source, phoneNumber, alarmLabel, hours, minutes)
    -- Insert new alarm into database with provided parameters
    -- The alarm will be created in enabled state by default
    local insertQuery = "INSERT INTO phone_clock_alarms (phone_number, hours, minutes, label) VALUES (@phoneNumber, @hours, @minutes, @label)"
    local insertParams = {
        ["@phoneNumber"] = phoneNumber,  -- Phone number this alarm belongs to
        ["@hours"] = hours,              -- Hour component (0-23)
        ["@minutes"] = minutes,          -- Minute component (0-59)
        ["@label"] = alarmLabel          -- User-defined alarm description
    }
    
    -- Execute insert and return the result (usually the new alarm ID)
    return MySQL.insert.await(insertQuery, insertParams)
end)
-- Delete a specific alarm by ID and phone number
-- This callback removes an alarm from the database with security validation
-- Parameters: source, phoneNumber, alarmId
BaseCallback("clock:deleteAlarm", function(source, phoneNumber, alarmId)
    -- Delete alarm with both ID and phone number validation
    -- This ensures users can only delete their own alarms
    local deleteQuery = "DELETE FROM phone_clock_alarms WHERE id = ? AND phone_number = ?"
    local deleteParams = { alarmId, phoneNumber }
    
    -- Execute the delete operation
    local affectedRows = MySQL.update.await(deleteQuery, deleteParams)
    
    -- Return true if the alarm was successfully deleted (affected rows > 0)
    -- Return false if alarm wasn't found or didn't belong to this phone
    return affectedRows > 0
end)
-- Toggle alarm enabled/disabled status
-- This callback enables or disables a specific alarm
-- Parameters: source, phoneNumber, alarmId, enabledStatus
BaseCallback("clock:toggleAlarm", function(source, phoneNumber, alarmId, enabledStatus)
    -- Update the enabled status of the specified alarm
    -- Only allows toggling alarms that belong to the requesting phone number
    local updateQuery = "UPDATE phone_clock_alarms SET enabled = ? WHERE id = ? AND phone_number = ?"
    local updateParams = {
        enabledStatus == true,  -- Convert to boolean (true/false)
        alarmId,               -- Specific alarm ID to update
        phoneNumber            -- Security: ensure alarm belongs to this phone
    }
    
    -- Execute the update operation
    MySQL.update.await(updateQuery, updateParams)
    
    -- Return the new enabled status to confirm the change
    return enabledStatus
end)
-- Update an existing alarm's properties
-- This callback modifies alarm label, hours, and minutes
-- Parameters: source, phoneNumber, alarmId, newLabel, newHours, newMinutes
BaseCallback("clock:updateAlarm", function(source, phoneNumber, alarmId, newLabel, newHours, newMinutes)
    -- Update all modifiable properties of the specified alarm
    -- Security validation ensures only the alarm owner can modify it
    local updateQuery = "UPDATE phone_clock_alarms SET label = ?, hours = ?, minutes = ? WHERE id = ? AND phone_number = ?"
    local updateParams = {
        newLabel,     -- Updated alarm description/label
        newHours,     -- Updated hour component (0-23)
        newMinutes,   -- Updated minute component (0-59)
        alarmId,      -- Specific alarm ID to update
        phoneNumber   -- Security: ensure alarm belongs to this phone
    }
    
    -- Execute the update operation
    local affectedRows = MySQL.update.await(updateQuery, updateParams)
    
    -- Return true if the alarm was successfully updated (affected rows > 0)
    -- Return false if alarm wasn't found or didn't belong to this phone
    return affectedRows > 0
end)
