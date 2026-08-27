-- =====================================================
--  rcore_police · modules/base/server/services/sv-se-groups.lua
--  Engineered by Eazy Fxap
--  Original: 615 lines → Cleaned: 257 lines
-- =====================================================

GroupsService = {}

function GroupsService.RemovePlayer(src, groupName)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then
        return false, ERROR_STATES.NO_STORAGE_FOUND
    end
    
    if not src then
        return false, ERROR_STATES.PLAYER_ID_IS_NOT_PROVIDED
    end
    
    if type(src) ~= "number" then
        return false, ERROR_STATES.PLAYER_ID_IS_NOT_A_NUMBER
    end
    
    if GetPlayerPed(src) <= 0 then
        return false, ERROR_STATES.PLAYER_WITH_THIS_ID_IS_OFFLINE
    end
    
    local success, identifier = pcall(function() return Framework.getIdentifier(src) end)
    if not success then
        return false, ERROR_STATES.PLAYER_IDENTIFIER_NOT_FOUND
    end
    
    local isMember, memberData = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then
        return false, ERROR_STATES.PLAYER_ALREADY_IN_GROUP
    end
    
    if not groupName and memberData then
        groupName = memberData.group
    end
    
    local removed = storage.removePlayer(identifier, groupName)
    return removed, "REMOVED_PLAYER"
end

function GroupsService.UpdateGlobalState(groupName)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then
        return false, ERROR_STATES.NO_STORAGE_FOUND
    end
    
    return storage.updateGlobalState(groupName)
end

function GroupsService.GetGlobalStateData(groupName)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then
        return false, ERROR_STATES.NO_STORAGE_FOUND
    end
    
    return storage.getGlobalStateData(groupName)
end

function GroupsService.GetGroups()
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then
        return false, ERROR_STATES.NO_STORAGE_FOUND
    end
    
    return storage.returnAllGroups()
end

function GroupsService.UpdatePlayer(src)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then
        return false, ERROR_STATES.NO_STORAGE_FOUND
    end
    
    if not src then
        return false, ERROR_STATES.PLAYER_ID_IS_NOT_PROVIDED
    end
    
    if type(src) ~= "number" then
        return false, ERROR_STATES.PLAYER_ID_IS_NOT_A_NUMBER
    end
    
    if GetPlayerPed(src) <= 0 then
        return false, ERROR_STATES.PLAYER_WITH_THIS_ID_IS_OFFLINE
    end
    
    local isMember = GroupsService.IsPlayerMemberOfGroup(src)
    if not isMember then
        return false, "UPDATE_NOT_IN_GROUP_TARGET_PLAYER"
    end
    
    local model = OfficerModel()
    
    local idSuccess, identifier = pcall(function() return Framework.getIdentifier(src) end)
    local jobSuccess, jobData = pcall(function()
        local job = Framework.getJob(src)
        if not job then return false end
        
        local struct = ConvertPlayerJobToStructure(job)
        if not struct then return false end
        return struct
    end)
    
    if not idSuccess then
        return false, ERROR_STATES.PLAYER_IDENTIFIER_NOT_FOUND
    end
    
    if not jobSuccess or not jobData then
        return false, ERROR_STATES.PLAYER_JOB_NOT_FOUND
    end
    
    if Config.JobGroups[jobData.group] == nil then
        return false, ERROR_STATES.PLAYER_JOB_GROUP_NOT_FOUND
    end
    
    model.playerId = src
    model.identifier = identifier
    model.group = jobData.group
    model.grade = jobData.grade
    model.grade_name = jobData.grade_name
    model.name = Framework.getCharacterShortName(src) or ""
    model.duty = DutyService.IsPlayerInService(src) or false
    
    local updated = storage.updatePlayer(model)
    return updated, "UPDATED_MEMBER"
end

function GroupsService.AddPlayer(src)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then
        return false, ERROR_STATES.NO_STORAGE_FOUND
    end
    
    if not src then
        return false, ERROR_STATES.PLAYER_ID_IS_NOT_PROVIDED
    end
    
    if type(src) ~= "number" then
        return false, ERROR_STATES.PLAYER_ID_IS_NOT_A_NUMBER
    end
    
    if GetPlayerPed(src) <= 0 then
        return false, ERROR_STATES.PLAYER_WITH_THIS_ID_IS_OFFLINE
    end
    
    local isMember = GroupsService.IsPlayerMemberOfGroup(src)
    if isMember then
        return false, ERROR_STATES.PLAYER_ALREADY_IN_GROUP
    end
    
    local model = OfficerModel()
    
    local idSuccess, identifier = pcall(function() return Framework.getIdentifier(src) end)
    local jobSuccess, jobData = pcall(function()
        local job = Framework.getJob(src)
        if not job then return false end
        
        local struct = ConvertPlayerJobToStructure(job)
        if not struct then return false end
        return struct
    end)
    
    if not idSuccess then
        return false, ERROR_STATES.PLAYER_IDENTIFIER_NOT_FOUND
    end
    
    if not jobSuccess or not jobData then
        return false, ERROR_STATES.PLAYER_JOB_NOT_FOUND
    end
    
    if Config.JobGroups[jobData.group] == nil then
        return false, ERROR_STATES.PLAYER_JOB_GROUP_NOT_FOUND
    end
    
    model.playerId = src
    model.identifier = identifier
    model.group = jobData.group
    model.grade = jobData.grade
    model.grade_name = jobData.grade_name
    model.name = Framework.getCharacterShortName(src) or ""
    model.duty = DutyService.IsPlayerInService(src) or false
    
    local added = storage.addPlayer(model)
    return added, ERROR_STATES.PLAYER_ADDED_TO_GROUP
end

function GroupsService.GetAllDeparmentsCount()
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then return end
    
    return storage.countAllDepartments()
end

function GroupsService.GetGroupByName(groupName)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then return end
    
    return storage.groups[groupName]
end

function GroupsService.GetGroupPlayersByDerpartmentName(groupName)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then return end
    
    return storage.getGroupPlayersByDerpartmentName(groupName)
end

function GroupsService.IsPlayerMemberOfGroup(src)
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then return false end
    
    if not src then return false end
    if type(src) ~= "number" then return false end
    if GetPlayerPed(src) <= 0 then return false end
    
    local success, identifier = pcall(function() return Framework.getIdentifier(src) end)
    if not success then return false end
    
    return storage.hasMember(identifier)
end

function GroupsService.HandlePlayerJobUpdate(src, newJob, reason)
    local struct = ConvertPlayerJobToStructure(newJob)
    local newGroupName = struct.group
    
    local isMember, memberData = GroupsService.IsPlayerMemberOfGroup(src)
    
    local isTargetGroupAllowed = (Config.JobGroups[newGroupName] ~= nil)
    local currentGroupName = isMember and memberData.group or nil
    
    if not isTargetGroupAllowed and isMember and currentGroupName then
        GroupsService.RemovePlayer(src, currentGroupName)
        dbg.debug("Removed player %s (%s) from group %s", src, GetPlayerName(src), currentGroupName)
    end
    
    if isTargetGroupAllowed then
        if not isMember then
            GroupsService.AddPlayer(src)
            dbg.debug("Added player %s (%s) to group %s", src, GetPlayerName(src), newGroupName)
        elseif currentGroupName ~= newGroupName then
            GroupsService.RemovePlayer(src, currentGroupName)
            GroupsService.AddPlayer(src)
            dbg.debug("Switched player %s (%s) from group %s to group %s", src, GetPlayerName(src), currentGroupName, newGroupName)
        else
            GroupsService.UpdatePlayer(src)
            dbg.debug("Updated player %s (%s) in group %s", src, GetPlayerName(src), newGroupName)
        end
    end
    
    local groupObj = GroupsService.GetGroupByName(newGroupName)
    if groupObj then
        local size = groupObj:GetSize()
        dbg.debug("Player %s (%s) job updated to %s for reason: %s | Group size: %s", src, GetPlayerName(src), newGroupName, reason or "N/A", size)
    end
end
