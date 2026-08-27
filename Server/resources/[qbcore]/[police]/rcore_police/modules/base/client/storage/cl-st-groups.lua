-- =====================================================
--  rcore_police · modules/base/client/storage/cl-st-groups.lua
--  Engineered by Eazy Fxap
--  Original: 86 lines → Cleaned: 37 lines
-- =====================================================

function GroupsStorage()
    local self = {}
    self.storage = {}

    function self.updateStorageSpecific(groupId, data)
        local idStr = tostring(groupId)
        if not self.storage[idStr] then
            self.storage[idStr] = data
        end
        UpdateBossMenuData(data)
        return true
    end

    function self.getStorageSpecificById(groupId)
        return self.storage[groupId]
    end

    function self.getCharacterDataByServerId(serverId)
        if not self.storage or not next(self.storage) then
            return nil
        end
        
        for _, groupData in pairs(self.storage) do
            if groupData.members then
                for _, member in pairs(groupData.members) do
                    if member.playerId == serverId then
                        return member
                    end
                end
            end
        end
        return nil
    end

    return self
end

Object.registerStorage(STORAGE_GROUPS, GroupsStorage())
