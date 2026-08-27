-- Sistema de Backup do Telefone
-- Permite aos jogadores fazer backup e restaurar seus dados do telefone

-- Callback para criar um novo backup do telefone
BaseCallback("backup:createBackup", function(playerSource, phoneNumber)
    -- Obtém o identificador único do jogador
    local playerIdentifier = GetIdentifier(playerSource)
    
    -- Cria ou atualiza o backup na base de dados
    local affectedRows = MySQL.update.await([[
        INSERT INTO phone_backups (id, phone_number) VALUES (@identifier, @phoneNumber)
        ON DUPLICATE KEY UPDATE phone_number = @phoneNumber
    ]], {
        ["@identifier"] = playerIdentifier,
        ["@phoneNumber"] = phoneNumber
    })
    
    -- Retorna true se o backup foi criado/atualizado com sucesso
    return affectedRows > 0
end)
-- Callback para aplicar/restaurar dados de um backup existente
BaseCallback("backup:applyBackup", function(playerSource, currentPhoneNumber, backupPhoneNumber)
    -- Obtém o identificador único do jogador
    local playerIdentifier = GetIdentifier(playerSource)
    
    -- Verifica se o backup existe para este jogador
    local backupExists = MySQL.scalar.await(
        "SELECT 1 FROM phone_backups WHERE id = ? AND phone_number = ?",
        { playerIdentifier, backupPhoneNumber }
    )
    
    -- Retorna false se o backup não existe ou se está tentando restaurar o mesmo número
    if not backupExists or currentPhoneNumber == backupPhoneNumber then
        return false
    end
    
    -- Parâmetros para buscar dados dos telefones
    local queryParams = {
        ["@number"] = backupPhoneNumber,
        ["@phoneNumber"] = currentPhoneNumber
    }
    
    -- Busca os dados dos dois telefones (atual e backup)
    local phoneData = MySQL.query.await(
        "SELECT settings, pin, face_id, phone_number FROM phone_phones WHERE phone_number = @number OR phone_number = @phoneNumber",
        queryParams
    )
    
    -- Identifica qual telefone é o atual e qual é o backup
    local currentPhoneData, backupPhoneData
    
    if phoneData[1] and phoneData[1].phone_number == currentPhoneNumber then
        currentPhoneData = phoneData[1]
        backupPhoneData = phoneData[2]
    else
        currentPhoneData = phoneData[2]
        backupPhoneData = phoneData[1]
    end
    
    -- Verifica se ambos os telefones existem
    if not currentPhoneData or not backupPhoneData then
        return false
    end
    
    -- Decodifica as configurações do backup para aplicar no telefone atual
    local backupSettings = json.decode(backupPhoneData.settings)
    currentPhoneData.settings = backupSettings
    
    -- Gerencia configurações de segurança - PIN Code
    if currentPhoneData.settings.security.pinCode then
        -- Se o backup tem PIN habilitado mas o telefone atual não tem PIN cadastrado,
        -- desabilita o PIN nas configurações
        if not currentPhoneData.pin then
            currentPhoneData.settings.security.pinCode = false
        end
    end
    
    -- Gerencia configurações de segurança - Face ID
    if currentPhoneData.settings.security.faceId then
        -- Se o backup tem Face ID habilitado mas o telefone atual não tem Face ID cadastrado,
        -- desabilita o Face ID nas configurações
        if not currentPhoneData.face_id then
            currentPhoneData.settings.security.faceId = false
        end
    end
    
    -- Atualiza as configurações do telefone atual com as do backup
    MySQL.update.await(
        "UPDATE phone_phones SET settings = ? WHERE phone_number = ?",
        { json.encode(currentPhoneData.settings), currentPhoneNumber }
    )
    
    -- Restaura fotos/vídeos do backup (evita duplicatas)
    MySQL.update.await([[
        INSERT IGNORE INTO phone_photos (phone_number, link, is_video, size, `timestamp`)
        SELECT @phoneNumber, link, is_video, size, `timestamp`
        FROM phone_photos
        WHERE phone_number = @number AND link NOT IN (SELECT link FROM phone_photos WHERE phone_number = @phoneNumber)
    ]], queryParams)
    
    -- Restaura contatos do backup (evita duplicatas)
    MySQL.update.await([[
        INSERT IGNORE INTO phone_phone_contacts (contact_phone_number, firstname, lastname, profile_image, favourite, phone_number)
        SELECT contact_phone_number, firstname, lastname, profile_image, favourite, @phoneNumber
        FROM phone_phone_contacts
        WHERE phone_number = @number AND contact_phone_number NOT IN (SELECT contact_phone_number FROM phone_phone_contacts WHERE phone_number = @phoneNumber)
    ]], queryParams)
    
    -- Restaura localizações salvas do backup (evita duplicatas)
    MySQL.update.await([[
        INSERT IGNORE INTO phone_maps_locations (id, phone_number, `name`, x_pos, y_pos)
        SELECT id, @phoneNumber, `name`, x_pos, y_pos
        FROM phone_maps_locations
        WHERE phone_number = @number AND id NOT IN (SELECT id FROM phone_maps_locations WHERE phone_number = @phoneNumber)
    ]], queryParams)
    
    -- Retorna true indicando que o backup foi aplicado com sucesso
    return true
end)
-- Callback para deletar um backup existente
BaseCallback("backup:deleteBackup", function(playerSource, currentPhoneNumber, backupPhoneNumber)
    -- Obtém o identificador único do jogador
    local playerIdentifier = GetIdentifier(playerSource)
    
    -- Remove o backup da base de dados
    local affectedRows = MySQL.update.await(
        "DELETE FROM phone_backups WHERE id = ? AND phone_number = ?",
        { playerIdentifier, backupPhoneNumber }
    )
    
    -- Retorna true se o backup foi deletado com sucesso
    return affectedRows > 0
end)
-- Callback para obter lista de backups disponíveis para o jogador
BaseCallback("backup:getBackups", function(playerSource, currentPhoneNumber)
    -- Obtém o identificador único do jogador
    local playerIdentifier = GetIdentifier(playerSource)
    
    -- Busca todos os backups do jogador
    return MySQL.query.await(
        "SELECT phone_number AS `number` FROM phone_backups WHERE id = ?",
        { playerIdentifier }
    )
end)
