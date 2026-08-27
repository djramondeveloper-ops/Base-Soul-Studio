-- =====================================================
--  rcore_police · modules/base/server/storage/sv-st-groups.lua
--  Engineered by Eazy Fxap
--  Original: 754 lines → Cleaned: 267 lines
-- =====================================================

function GroupsStorage()
    local self = {}
    local GroupClass = {}
    GroupClass.__index = GroupClass
    
    local function safeCall(func, ...)
        local success, err = pcall(func, ...)
        if not success then
            print("Error:", err, func, ...)
        end
        return success, err
    end
    
    function GroupClass.new(name)
        local group = setmetatable({}, GroupClass)
        group.name = name
        group.society = { balance = 0 }
        group.garageStock = 0
        group.members = {}
        return group
    end
    
    function GroupClass:addMember(memberData)
        if self.members and next(self.members) then
            for _, member in ipairs(self.members) do
                if member.identifier == memberData.identifier then
                    return
                end
            end
        end
        
        table.insert(self.members, memberData)
        self:updateGlobalState()
        TriggerLocalServerEvent("onGroups", "addMember", memberData)
        self:SyncCount()
        dbg.debug("Group %s: Player %s (%s) was added.", self.name, GetPlayerName(memberData.playerId), memberData.playerId)
    end
    
    function GroupClass:updateMember(memberData)
        if not self.members then return end
        
        for idx, member in ipairs(self.members) do
            if member.identifier == memberData.identifier then
                self.members[idx] = memberData
                self:updateGlobalState()
                TriggerLocalServerEvent("onGroups", "updateMember", memberData)
                dbg.debug("Group %s: Player %s (%s) was updated.", self.name, GetPlayerName(memberData.playerId), memberData.playerId)
                return
            end
        end
    end
    
    function GroupClass:removeMember(identifier)
        for idx, member in ipairs(self.members) do
            if member.identifier == identifier then
                table.remove(self.members, idx)
                self:updateGlobalState()
                TriggerLocalServerEvent("onGroups", "removeMember", member)
                self:SyncCount()
                dbg.debug("Group %s: Player %s was removed.", self.name, identifier)
                return true
            end
        end
        return false
    end
    
    function GroupClass:getGlobalStateData()
        if self.society then
            self.society.balance = SocietyService.GetMoney(self.name)
        end
        if self.garageStock then
            self.garageStock = GarageService.GetStockCount(self.name)
        end
        return self
    end
    
    function GroupClass:updateGlobalState()
        if self.society then
            self.society.balance = SocietyService.GetMoney(self.name)
        end
        if self.garageStock then
            self.garageStock = GarageService.GetStockCount(self.name)
        end
        StartClient(-1, "UpdateSpecificGroupData", self.name, self)
    end
    
    function GroupClass:SyncCount()
        local count = GroupsService.GetAllDeparmentsCount()
        SetTimeout(500, function()
            TriggerClientEvent("police:SetCopCount", -1, count)
        end)
        if GlobalState then
            GlobalState["rcore_police_departments_count"] = count
        end
    end
    
    function GroupClass:StartEvent(eventName, ...)
        if not self.members or not next(self.members) then return end
        for _, member in pairs(self.members) do
            if member.playerId then
                StartClient(member.playerId, eventName, ...)
            end
        end
    end
    
    function GroupClass:Notify(msg)
        if not self.members or not next(self.members) then
            return dbg.critical("Group %s: Failed to send group message since no members found.", self.name)
        end
        for _, member in pairs(self.members) do
            if member.playerId then
                Framework.sendNotification(member.playerId, msg)
            end
        end
    end
    
    function GroupClass:HasMember(identifier)
        if self.members and next(self.members) then
            for _, member in pairs(self.members) do
                if member.identifier == identifier then
                    return true, member
                end
            end
        end
        return false
    end
    
    function GroupClass:GetSize()
        if self.members then
            return #self.members
        end
        return 0
    end
    
    self.groups = {}
    self.groupsRegistered = false
    
    function self.getGlobalStateData(groupName)
        local groupObj = self.groups[groupName]
        if not groupObj then
            dbg.critical("Groups storage: Group %s is not found as allowed in your config.lua.", groupName)
            return false
        end
        return groupObj:getGlobalStateData()
    end
    
    function self.countAllDepartments()
        local count = 0
        for _, groupObj in pairs(self.groups) do
            if groupObj.members then
                for _, member in pairs(groupObj.members) do
                    if member.duty then
                        count = count + 1
                    end
                end
            end
        end
        
        local status = count > 0 and "FOUND_ONLINE_PLAYERS" or "NO_ONLINE_PLAYERS"
        TriggerLocalServerEvent("onGroups", "GetPoliceOnline", count, GetInvokingResource())
        return count, status
    end
    
    function self.updateGlobalState(groupName)
        local groupObj = self.groups[groupName]
        if not groupObj then
            dbg.critical("Groups storage: Group %s is not found as allowed in your config.lua.", groupName)
            return false
        end
        groupObj:updateGlobalState(groupName)
    end
    
    function self.addPlayer(playerData)
        if not playerData then
            dbg.critical("Groups storage: Player model is not provided.")
            return false
        end
        if not playerData.group then
            dbg.critical("Groups storage: Player model group is not provided.")
            return false
        end
        if not playerData.identifier then
            dbg.critical("Groups storage: Player model player id is not provided.")
            return false
        end
        
        if not self.groupsRegistered then
            local ready = WaitFor(function() return self.groupsRegistered end, 12500)
            if not ready then
                dbg.critical("Failed to find registered groups!")
            end
        end
        
        local groupObj = self.groups[playerData.group]
        if not groupObj then
            dbg.critical("Groups storage: Group %s is not found as allowed in your config.lua.", playerData.group)
            return false
        end
        
        groupObj:addMember(playerData)
        return true
    end
    
    function self.updatePlayer(playerData)
        if not playerData then
            dbg.critical("Groups storage: Player model is not provided.")
            return false
        end
        if not playerData.group then
            dbg.critical("Groups storage: Player model group is not provided.")
            return false
        end
        if not playerData.identifier then
            dbg.critical("Groups storage: Player model player id is not provided.")
            return false
        end
        
        if not self.groupsRegistered then
            local ready = WaitFor(function() return self.groupsRegistered end, 12500)
            if not ready then
                dbg.critical("Failed to find registered groups!")
            end
        end
        
        local groupObj = self.groups[playerData.group]
        if not groupObj then
            dbg.critical("Groups storage: Group %s is not found as allowed in your config.lua.", playerData.group)
            return false
        end
        
        groupObj:updateMember(playerData)
        return true
    end
    
    function self.removePlayer(identifier, groupName)
        if groupName and self.groups[groupName] then
            return self.groups[groupName]:removeMember(identifier)
        end
        
        dbg.critical("Groups storage: Group %s is not found.", groupName)
    end
    
    function self.hasMember(identifier)
        for _, groupObj in pairs(self.groups) do
            local hasIt, member = groupObj:HasMember(identifier)
            if hasIt then
                return true, member
            end
        end
        return false, nil
    end
    
    function self.returnAllGroups()
        return self.groups
    end
    
    function self.getGroupPlayersByDerpartmentName(groupName)
        local groupObj = self.groups[groupName]
        if not groupObj then
            dbg.critical("Groups storage: Group %s is not found.", groupName)
            return {}
        end
        
        local players = {}
        if groupObj.members and next(groupObj.members) then
            for _, member in ipairs(groupObj.members) do
                if member.playerId then
                    table.insert(players, member.playerId)
                end
            end
        end
        return players
    end
    
    function self.registerGroups()
        dbg.debug("Groups storage: Initialization registering groups.")
        
        local jobGroupsCount = #Config.JobGroups
        if jobGroupsCount <= 0 then
            jobGroupsCount = table.size(Config.JobGroups)
        end
        
        if Config.JobGroups and next(Config.JobGroups) then
            for groupName, _ in pairs(Config.JobGroups) do
                if Config.JobGroups[groupName] then
                    if not self.groups[groupName] then
                        self.groups[groupName] = GroupClass.new(groupName)
                        
                        if DutyService.ActiveService then
                            safeCall(DutyService.ActiveService, groupName)
                        end
                        if SocietyService.Register then
                            safeCall(SocietyService.Register, groupName)
                        end
                    end
                end
            end
            
            dbg.debug("Groups storage: Groups were registered with size: %s", jobGroupsCount)
            self.groupsRegistered = true
            self.registerPlayers()
        end
    end
    
    function self.registerPlayers()
        for _, playerId in pairs(GetPlayers()) do
            local numId = tonumber(playerId)
            if numId then
                GroupsService.AddPlayer(numId)
            end
        end
    end
    
    return self
end

Object.registerStorage(STORAGE_GROUPS, GroupsStorage())

AddEventHandler("rcore_police:server:SetDuty", function(src)
    GroupsService.UpdatePlayer(src)
end)
