-- Sistema de Segurança do Telefone
-- Gerencia PIN e Face ID para autenticação

-- Legacy callback para obter identificador do jogador
RegisterLegacyCallback("security:getIdentifier", function(playerSource, callback)
    -- Obtém o identificador único do jogador
    local identifier = GetIdentifier(playerSource)
    callback(identifier)
end)
-- Callback para definir PIN do telefone
BaseCallback("security:setPin", function(playerSource, phoneNumber, newPin, currentPin)
    -- Validação do PIN: deve ser string com exatamente 4 caracteres
    if type(newPin) ~= "string" or #newPin ~= 4 then
        debugprint("Failed to set pin: invalid type or length")
        return false
    end
    
    -- Atualiza o PIN na base de dados
    -- Só permite alterar se o PIN atual coincide ou se não há PIN definido
    local affectedRows = MySQL.update.await(
        "UPDATE phone_phones SET pin = ? WHERE phone_number = ? AND (pin = ? OR pin IS NULL)",
        { newPin, phoneNumber, currentPin or "" }
    )
    
    local success = affectedRows > 0
    
    -- Log da operação para debugging
    debugprint("phone:security:setPin", GetPlayerName(playerSource), success, phoneNumber, newPin, currentPin)
    
    return success
end, false)
-- Callback para remover PIN do telefone
BaseCallback("security:removePin", function(playerSource, phoneNumber, currentPin)
    -- Validação do PIN atual: deve ser string com exatamente 4 caracteres
    if type(currentPin) ~= "string" or #currentPin ~= 4 then
        debugprint("Failed to remove pin: invalid type or length")
        return false
    end
    
    -- Remove PIN e Face ID da base de dados
    -- Só permite remover se o PIN atual coincide ou se não há PIN definido
    local affectedRows = MySQL.update.await(
        "UPDATE phone_phones SET pin = NULL, face_id = NULL WHERE phone_number = ? AND (pin = ? OR pin IS NULL)",
        { phoneNumber, currentPin }
    )
    
    return affectedRows > 0
end, false)
-- Callback para verificar PIN do telefone
BaseCallback("security:verifyPin", function(playerSource, phoneNumber, enteredPin)
    -- Validação do PIN: deve ser string com exatamente 4 caracteres
    if type(enteredPin) ~= "string" or #enteredPin ~= 4 then
        debugprint("Failed to verify pin: invalid type or length")
        return false
    end
    
    -- Busca o PIN armazenado na base de dados
    local storedPin = MySQL.scalar.await(
        "SELECT pin FROM phone_phones WHERE phone_number = ?",
        { phoneNumber }
    )
    
    -- Verifica se o PIN coincide ou se não há PIN definido (NULL)
    local isValid = storedPin == nil or storedPin == enteredPin
    
    -- Log da operação para debugging
    debugprint("phone:security:verifyPin", GetPlayerName(playerSource), isValid, storedPin, enteredPin)
    
    return isValid
end, false)
-- Callback para habilitar Face ID no telefone
BaseCallback("security:enableFaceUnlock", function(playerSource, phoneNumber, currentPin)
    -- Validação do PIN: deve ser string com exatamente 4 caracteres
    if type(currentPin) ~= "string" or #currentPin ~= 4 then
        debugprint("Failed to enable face unlock: invalid type or length")
        return false
    end
    
    -- Obtém o identificador único do jogador para Face ID
    local playerIdentifier = GetIdentifier(playerSource)
    
    -- Ativa Face ID apenas se o PIN atual estiver correto
    local affectedRows = MySQL.update.await(
        "UPDATE phone_phones SET face_id = ? WHERE phone_number = ? AND pin = ?",
        { playerIdentifier, phoneNumber, currentPin }
    )
    
    return affectedRows > 0
end, false)
-- Callback para desabilitar Face ID no telefone
BaseCallback("security:disableFaceUnlock", function(playerSource, phoneNumber, currentPin)
    -- Validação do PIN: deve ser string com exatamente 4 caracteres
    if type(currentPin) ~= "string" or #currentPin ~= 4 then
        debugprint("Failed to disable face unlock: invalid type or length")
        return false
    end
    
    -- Remove Face ID se o PIN atual estiver correto ou se não há PIN definido
    return MySQL.update.await(
        "UPDATE phone_phones SET face_id = NULL WHERE phone_number = ? AND (pin = ? OR pin IS NULL)",
        { phoneNumber, currentPin }
    )
end, false)
-- Callback para verificar Face ID do telefone
BaseCallback("security:verifyFace", function(playerSource, phoneNumber)
    -- Obtém o identificador único do jogador atual
    local currentPlayerIdentifier = GetIdentifier(playerSource)
    
    -- Busca o identificador registrado para Face ID na base de dados
    local storedFaceId = MySQL.scalar.await(
        "SELECT face_id FROM phone_phones WHERE phone_number = ?",
        { phoneNumber }
    )
    
    -- Log da operação para debugging
    debugprint("phone:security:verifyFace", GetPlayerName(playerSource), storedFaceId, currentPlayerIdentifier)
    
    -- Verifica se o Face ID coincide com o identificador atual
    return storedFaceId == currentPlayerIdentifier
end, false)
-- Função para resetar toda a segurança de um telefone
function ResetSecurity(phoneNumber)
    -- Validação do parâmetro
    assert(type(phoneNumber) == "string", 
           "Invalid argument #1 to ResetSecurity, expected string, got " .. type(phoneNumber))
    
    -- Remove PIN e Face ID da base de dados
    MySQL.update.await(
        "UPDATE phone_phones SET pin = NULL, face_id = NULL WHERE phone_number = ?",
        { phoneNumber }
    )
    
    -- Se o jogador estiver online, notifica o cliente sobre o reset
    local playerSource = GetSourceFromNumber(phoneNumber)
    if playerSource then
        TriggerClientEvent("phone:security:reset", playerSource, phoneNumber)
    end
end
-- Export para obter PIN de um telefone
exports("GetPin", function(phoneNumber)
    -- Validação do parâmetro
    assert(type(phoneNumber) == "string", 
           "Invalid argument #1 to GetPin, expected string, got " .. type(phoneNumber))
    
    -- Busca o PIN na base de dados
    return MySQL.scalar.await(
        "SELECT pin FROM phone_phones WHERE phone_number = ?",
        { phoneNumber }
    )
end)

-- Export da função ResetSecurity para outros recursos
exports("ResetSecurity", ResetSecurity)
