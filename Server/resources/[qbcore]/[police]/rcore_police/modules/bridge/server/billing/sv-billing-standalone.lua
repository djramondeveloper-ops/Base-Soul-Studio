-- Seoul Base integration: invoices table is the same source used by Creative Bank and LB Tablet.
if Config.Invoices == Invoices.NONE then
    local function insertInvoice(issuerId, targetId, amount, reason)
        amount = math.floor(tonumber(amount) or 0)
        issuerId = tonumber(issuerId) or 0
        targetId = tonumber(targetId) or 0
        if amount <= 0 or targetId <= 0 then return false end
        reason = tostring(reason or 'Multa policial')
        local inserted = MySQL.insert.await(
            'INSERT INTO invoices (Passport,Received,Reason,Price,Timestamp) VALUES (?, ?, ?, ?, ?)',
            { issuerId, targetId, reason, amount, os.time() }
        )
        return inserted ~= nil
    end

    RegisterNetEvent('rcore_police:server:requestInvoice', function(target, amount)
        local playerId = source
        target = tonumber(target)
        amount = math.floor(tonumber(amount) or 0)
        if not target or amount <= 0 then return end
        if not Utils.IsPlayerNearAnotherPlayer(playerId, target, Config.CheckDistance + 0.5) then return end
        local state, playerData = GroupsService.IsPlayerMemberOfGroup(playerId)
        if not state or not playerData then return end
        local issuer = tonumber(Framework.getIdentifier(playerId)) or 0
        local receiver = tonumber(Framework.getIdentifier(target)) or 0
        if issuer <= 0 or receiver <= 0 or issuer == receiver then return end
        local officerName = Framework.getCharacterShortName(playerId) or 'Policial'
        local reason = ('Multa %s - %s'):format(playerData.group or 'Policia', officerName)
        if insertInvoice(issuer, receiver, amount, reason) then
            Framework.sendNotification(playerId, ('Fatura de R$%s emitida.'):format(amount), 'success')
            Framework.sendNotification(target, ('Voce recebeu uma fatura policial de R$%s.'):format(amount), 'primary')
        end
    end)

    CreateInvoice = function(playerId, targetPlayerId, amount, data)
        if not playerId or not targetPlayerId then return false end
        local isMember = GroupsService.IsPlayerMemberOfGroup(playerId)
        if not isMember then return false end
        if not Utils.IsPlayerNearAnotherPlayer(playerId, targetPlayerId, Config.CheckDistance + 0.5) then return false end
        local issuer = tonumber(Framework.getIdentifier(playerId)) or 0
        local receiver = tonumber(Framework.getIdentifier(targetPlayerId)) or 0
        if issuer <= 0 or receiver <= 0 or issuer == receiver then return false end
        return insertInvoice(issuer, receiver, amount, data and data.reason or 'Multa policial')
    end

    CreateInvoiceToPlayerInVehicle = function(playerId, targetPlayerId, amount, data)
        if not targetPlayerId then return false end
        local issuer = tonumber(data and data.issuer) or 0
        local receiver = tonumber(Framework.getIdentifier(targetPlayerId)) or 0
        if receiver <= 0 then return false end
        local reason = data and data.reason or 'Multa automatica de velocidade'
        return insertInvoice(issuer, receiver, amount, reason)
    end

    -- InvoiceMode 2 requires billing an offline vehicle owner. Seoul ownership is Passport-based.
    CreateOfflineInvoiceForVehicle = function(vehiclePlate, fineAmount, vehicleSpeed, issuerPassport)
        local owned, info = db.GetVehicleOwnerInfoByPlate(vehiclePlate)
        if not owned or not info or not info.identifier then return false end
        local ownerPassport = tonumber(info.identifier) or 0
        if ownerPassport <= 0 then return false end
        local reason = ('Multa automatica de velocidade (%s)'):format(tostring(vehicleSpeed or ''))
        return insertInvoice(tonumber(issuerPassport) or 0, ownerPassport, fineAmount, reason)
    end
end
