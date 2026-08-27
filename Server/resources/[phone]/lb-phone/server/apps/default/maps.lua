-- ================================================================
-- LB Phone - Maps App Server Handler
-- Manages saved locations and map markers for the phone maps application
-- ================================================================

-- Get all saved locations for a specific phone number
-- This callback retrieves all saved map locations from the database
-- and formats them for the client-side maps interface
BaseCallback("maps:getSavedLocations", function(source, phoneNumber)
    -- Query database for all saved locations belonging to this phone number
    -- Results are ordered alphabetically by name for better user experience
    local locationsQuery = "SELECT id, `name`, x_pos, y_pos FROM phone_maps_locations WHERE phone_number = ? ORDER BY `name` ASC"
    local queryParams = { phoneNumber }
    
    -- Execute the query to get raw location data
    local rawLocations = MySQL.query.await(locationsQuery, queryParams)
    
    -- Process each location to format the position data correctly
    -- Transform database format to client-expected format
    for i = 1, #rawLocations do
        local locationData = rawLocations[i]
        local formattedLocation = {
            id = locationData.id,           -- Unique location identifier
            name = locationData.name,       -- User-defined location name
            position = {                    -- Position array for map coordinates
                locationData.y_pos,         -- Y coordinate (latitude equivalent)
                locationData.x_pos          -- X coordinate (longitude equivalent)
            }
        }
        -- Replace raw data with formatted version
        rawLocations[i] = formattedLocation
    end
    
    -- Return the formatted locations array to the client
    return rawLocations
end, {})
-- Add a new saved location to the map
-- This callback creates a new map marker/location for the specified phone
-- Parameters: source, phoneNumber, locationName, xPosition, yPosition
BaseCallback("maps:addLocation", function(source, phoneNumber, locationName, xPosition, yPosition)
    -- Insert new location into the database with all required parameters
    -- The location will be associated with the requesting phone number
    local insertQuery = "INSERT INTO phone_maps_locations (phone_number, `name`, x_pos, y_pos) VALUES (?, ?, ?, ?)"
    local insertParams = {
        phoneNumber,    -- Phone number this location belongs to
        locationName,   -- User-defined name for this location
        xPosition,      -- X coordinate on the map (longitude equivalent)
        yPosition       -- Y coordinate on the map (latitude equivalent)
    }
    
    -- Execute the insert operation and return the result
    -- Usually returns the new location ID for client reference
    return MySQL.insert.await(insertQuery, insertParams)
end)
-- Rename an existing saved location
-- This callback updates the name/label of a saved map location
-- Parameters: source, phoneNumber, locationId, newLocationName
BaseCallback("maps:renameLocation", function(source, phoneNumber, locationId, newLocationName)
    -- Update the name of the specified location
    -- Security validation ensures only the location owner can rename it
    local updateQuery = "UPDATE phone_maps_locations SET `name` = ? WHERE id = ? AND phone_number = ?"
    local updateParams = {
        newLocationName,  -- New name for the location
        locationId,       -- Specific location ID to update
        phoneNumber       -- Security: ensure location belongs to this phone
    }
    
    -- Execute the update operation
    local affectedRows = MySQL.update.await(updateQuery, updateParams)
    
    -- Return true if the location was successfully renamed (affected rows > 0)
    -- Return false if location wasn't found or didn't belong to this phone
    return affectedRows > 0
end)
-- Remove a saved location from the map
-- This callback deletes a specific map location from the database
-- Parameters: source, phoneNumber, locationId
BaseCallback("maps:removeLocation", function(source, phoneNumber, locationId)
    -- Delete the specified location with security validation
    -- Only allows deletion of locations that belong to the requesting phone number
    local deleteQuery = "DELETE FROM phone_maps_locations WHERE id = ? AND phone_number = ?"
    local deleteParams = {
        locationId,     -- Specific location ID to delete
        phoneNumber     -- Security: ensure location belongs to this phone
    }
    
    -- Execute the delete operation
    local affectedRows = MySQL.update.await(deleteQuery, deleteParams)
    
    -- Return true if the location was successfully deleted (affected rows > 0)
    -- Return false if location wasn't found or didn't belong to this phone
    return affectedRows > 0
end)
