-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL SCRIPTS ENTITY COMPAT
-----------------------------------------------------------------------------------------------------------------------------------------
local function deleteNetEntity(netId)
    netId = tonumber(netId)
    if not netId then return end
    local entity = NetworkGetEntityFromNetworkId(netId)
    if entity and entity ~= 0 and DoesEntityExist(entity) then
        DeleteEntity(entity)
    end
end

RegisterNetEvent('tryCleanEntity', function(netId)
    deleteNetEntity(netId)
end)

RegisterNetEvent('tryDeletePed', function(netId)
    deleteNetEntity(netId)
end)

RegisterNetEvent('seoul_scripts:deleteEntity', function(netId)
    deleteNetEntity(netId)
end)
