-- =====================================================
--  rcore_police · modules/base/client/services/cl-se-groups.lua
--  Engineered by Eazy Fxap
--  Original: 89 lines → Cleaned: 39 lines
-- =====================================================

local copsCount = 0

RegisterNetEvent("police:SetCopCount", function(count)
    copsCount = count
end)

GroupsService = {}

function GroupsService.GetAllDeparmentsCount()
    if copsCount <= 0 then
        copsCount = GlobalState["rcore_police_departments_count"] or 0
    end
    return copsCount
end

function GroupsService.GetCharacterDataByServerId(serverId)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then return dbg.critical("Client storage is not available") end
    
    return storage.getCharacterDataByServerId(serverId)
end

function GroupsService.GetStorageSpecificById(groupId)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then return dbg.critical("Client storage is not available") end
    
    return storage.getStorageSpecificById(groupId)
end

function GroupsService.UpdateSpecificGroupData(groupId, data)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then return dbg.critical("Client storage is not available") end
    
    return storage.updateStorageSpecific(groupId, data)
end
