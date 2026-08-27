-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



function HandleBossMenuAction(playerId, data)
    local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
    if not state then
        return dbg.debug('Boss menu actions: Failed to execute action, since player %s is not part of department.', GetPlayerName(playerId))
    end
    if not playerData then
        return
    end
    local job = Framework.getJob(playerId)
    if not job or not job.isBoss then
        return dbg.debug('Boss menu actions: Failed to execute action, since player %s is not boss.', GetPlayerName(playerId))
    end
    local action = data.type
    local amount = data.amount
    local departmentAccount = SocietyService.GetAccount(playerData.group)
    local targetPlayer = data.selectedPlayer
    local hasAnyUpdate = false

    if action == BOSS_MENU_ACTIONS.HIRE_CITIZEN then
        local passport = tonumber(data.passport)
        if not passport or passport <= 0 then
            return Framework.sendNotification(playerId, _U('BOSS_MENU.INVALID_PASSPORT'), 'error')
        end

        -- Seoul vRP multiframework: Passport == QBCore citizenid.
        -- GetPlayerByCitizenId is implemented by the current Seoul QBCore compatibility layer.
        local qb = Framework.object
        local targetObject = qb
            and qb.Functions
            and qb.Functions.GetPlayerByCitizenId
            and qb.Functions.GetPlayerByCitizenId(tostring(passport))
            or nil

        local targetId = targetObject
            and targetObject.PlayerData
            and tonumber(targetObject.PlayerData.source)
            or nil

        if not targetId or targetId <= 0 or GetPlayerPed(targetId) <= 0 then
            return Framework.sendNotification(playerId, _U('HELP_MESSAGES.NO_TARGET_OFFLINE'), 'error')
        end

        if targetId == playerId then
            return Framework.sendNotification(playerId, _U('BOSS_MENU.PLAYER_ALREADY_EMPLOYEE'), 'error')
        end

        if not Utils.IsPlayerNearAnotherPlayer(playerId, targetId, Config.CheckDistance) then
            return Framework.sendNotification(playerId, _U('NO_CITIZEN_NEARBY'), 'error')
        end

        local targetJob = Framework.getJob(targetId)
        local alreadyMember = GroupsService.IsPlayerMemberOfGroup(targetId)
        if alreadyMember or (targetJob and Config.JobGroups[targetJob.name]) then
            return Framework.sendNotification(playerId, _U('BOSS_MENU.PLAYER_ALREADY_EMPLOYEE'), 'error')
        end

        -- Uses the existing Seoul/QBCore SetJob path:
        -- grade 0 maps to the entry rank (LSPD Cadete / PRPD Estagiário).
        local hired = Framework.SetPlayerJob(targetId, playerData.group, 0)
        if hired then
            local targetName = Framework.getCharacterShortName(targetId) or GetPlayerName(targetId) or tostring(passport)
            Framework.sendNotification(targetId, _U('BOSS_MENU.YOU_HIRED_BY_INITIATOR', playerData.group, Framework.getCharacterShortName(playerId) or GetPlayerName(playerId)), 'success')
            Framework.sendNotification(playerId, _U('BOSS_MENU.YOU_HIRED_PLAYER', targetName), 'success')
            hasAnyUpdate = true
        end
    end
    if action == BOSS_MENU_ACTIONS.SET_BONUS and HasEnoughMoneyInSociety(playerData.group, amount) then
        if departmentAccount and targetPlayer then
            local selectedPlayerBankAccount = Framework.GetBankAccount(targetPlayer.playerId)
            if selectedPlayerBankAccount and next(selectedPlayerBankAccount) and amount > 0 then
                selectedPlayerBankAccount.AddMoney(amount)
                departmentAccount.RemoveMoney(amount) 
                Framework.sendNotification(playerId, _U('BOSS_MENU_ACTIONS.SET_BONUS', targetPlayer.name, amount, Config.BossMenu.MoneySymbol), 'success')
                hasAnyUpdate = true
            end
        end
    end
    if action == BOSS_MENU_ACTIONS.DEPOSIT_SOCIETY_MONEY then
        if departmentAccount then
            local selectedPlayerBankAccount = Framework.GetBankAccount(playerId)
            if selectedPlayerBankAccount and next(selectedPlayerBankAccount) then
                local balance = selectedPlayerBankAccount.GetMoney()
                if balance >= amount then
                    selectedPlayerBankAccount.RemoveMoney(amount)
                    departmentAccount.AddMoney(amount) 
                    Framework.sendNotification(playerId, _U('BOSS_MENU_ACTIONS.DEPOSIT_SOCIETY_MONEY', amount, Config.BossMenu.MoneySymbol), 'success')
                    hasAnyUpdate = true
                end
            end
        end
    end
    if action == BOSS_MENU_ACTIONS.WIDTHRAW_SOCIETY_MONEY and HasEnoughMoneyInSociety(playerData.group, amount) then
        if departmentAccount then
            local selectedPlayerBankAccount = Framework.GetBankAccount(playerId)
            if selectedPlayerBankAccount and next(selectedPlayerBankAccount) then
                local balance = departmentAccount.GetBalance()
                if balance >= amount then
                    selectedPlayerBankAccount.AddMoney(amount)
                    departmentAccount.RemoveMoney(amount) 
                    Framework.sendNotification(playerId, _U('BOSS_MENU_ACTIONS.WIDTHRAW_SOCIETY_MONEY', amount, Config.BossMenu.MoneySymbol), 'success')
                    hasAnyUpdate = true
                end
            end
        end
    end
    if action == BOSS_MENU_ACTIONS.UPDATE_GRADE and targetPlayer and data.label then
        local retval = Framework.SetPlayerJob(targetPlayer.playerId, playerData.group, amount)
        if retval then
            Framework.sendNotification(playerId, _U('BOSS_MENU_ACTIONS.PROMOTE_CITIZEN', targetPlayer.name, data.label), 'success')
            hasAnyUpdate = true
        end
    end
    if action == BOSS_MENU_ACTIONS.FIRE_CITIZEN and targetPlayer then
        local retval = Framework.SetPlayerJob(targetPlayer.playerId, 'unemployed', 0)
        if retval then
            Framework.sendNotification(playerId, _U('BOSS_MENU_ACTIONS.FIRE_CITIZEN', targetPlayer.name), 'success')
            hasAnyUpdate = true
        end
    end
    if hasAnyUpdate then
        GroupsService.UpdateGlobalState(playerData.group) 
    end
end
function HasEnoughMoneyInSociety(group, amount)
    if not group then
        return false
    end
    local account = SocietyService.GetAccount(group)
    if not account then
        return false
    end
    local balance = tonumber(account.GetBalance())
    if balance and balance >= amount then
        return true
    end
    return false
end
