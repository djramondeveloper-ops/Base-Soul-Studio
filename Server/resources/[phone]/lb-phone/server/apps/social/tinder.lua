-- Callback para criar uma nova conta no Tinder/Spark
BaseCallback("tinder:createAccount", function(source, phoneNumber, accountData)
    -- Verifica se já existe uma conta para este número de telefone
    local accountExists = MySQL.scalar.await(
        "SELECT TRUE FROM phone_tinder_accounts WHERE phone_number = ?",
        { phoneNumber }
    )
    
    -- Se já existe uma conta, retorna false
    if accountExists then
        return false
    end
    
    -- Cria a nova conta no banco de dados
    local rowsAffected = MySQL.update.await([[
        INSERT INTO phone_tinder_accounts
            (`name`, phone_number, photos, bio, dob, is_male, interested_men, interested_women)
        VALUES
            (@name, @phoneNumber, @photos, @bio, @dob, @isMale, @showMen, @showWomen)
    ]], {
        ["@name"] = accountData.name,
        ["@phoneNumber"] = phoneNumber,
        ["@photos"] = json.encode(accountData.photos),
        ["@bio"] = accountData.bio,
        ["@dob"] = accountData.dob,
        ["@isMale"] = accountData.isMale,
        ["@showMen"] = accountData.showMen,
        ["@showWomen"] = accountData.showWomen
    })
    
    -- Retorna true se a conta foi criada com sucesso
    return rowsAffected > 0
end, false)
-- Callback para deletar uma conta do Tinder/Spark
BaseCallback("tinder:deleteAccount", function(source, phoneNumber)
    -- Verifica se a deleção de contas está habilitada na configuração
    if not Config.DeleteAccount.Spark then
        infoprint("warning", 
            ("%s tried to delete their spark account, but it's not enabled in the config."):format(source)
        )
        return false
    end
    
    -- Remove a conta principal
    local accountDeleted = MySQL.update.await(
        "DELETE FROM phone_tinder_accounts WHERE phone_number = ?",
        { phoneNumber }
    )
    
    -- Se a conta não foi encontrada, retorna false
    if not (accountDeleted > 0) then
        return false
    end
    
    -- Remove todos os swipes relacionados a esta conta
    MySQL.update(
        "DELETE FROM phone_tinder_swipes WHERE swiper = ? OR swipee = ?",
        { phoneNumber, phoneNumber }
    )
    
    -- Remove todos os matches relacionados a esta conta
    MySQL.update(
        "DELETE FROM phone_tinder_matches WHERE phone_number_1 = ? OR phone_number_2 = ?",
        { phoneNumber, phoneNumber }
    )
    
    -- Remove todas as mensagens relacionadas a esta conta
    MySQL.update(
        "DELETE FROM phone_tinder_messages WHERE sender = ? OR recipient = ?",
        { phoneNumber, phoneNumber }
    )
    
    -- Retorna true indicando que a conta foi deletada com sucesso
    return true
end)
-- Callback para atualizar uma conta existente do Tinder/Spark
BaseCallback("tinder:updateAccount", function(source, phoneNumber, accountData)
    -- Atualiza os dados da conta no banco de dados
    local rowsAffected = MySQL.update.await([[
        UPDATE phone_tinder_accounts
        SET
            `name`=@name,
            photos=@photos,
            bio=@bio,
            is_male=@isMale,
            interested_men=@showMen,
            interested_women=@showWomen,
            `active`=@active
        WHERE phone_number=@phoneNumber
    ]], {
        ["@name"] = accountData.name,
        ["@photos"] = json.encode(accountData.photos),
        ["@bio"] = accountData.bio,
        ["@isMale"] = accountData.isMale,
        ["@showMen"] = accountData.showMen,
        ["@showWomen"] = accountData.showWomen,
        ["@active"] = accountData.active,
        ["@phoneNumber"] = phoneNumber
    })
    
    -- Retorna true se a conta foi atualizada com sucesso
    return rowsAffected > 0
end, false)
-- Callback para verificar se o usuário está logado e obter dados da conta
BaseCallback("tinder:isLoggedIn", function(source, phoneNumber)
    -- Busca os dados da conta do usuário
    local accountData = MySQL.single.await(
        "SELECT `name`, photos, bio, dob, is_male, interested_men, interested_women, `active` FROM phone_tinder_accounts WHERE phone_number = ?",
        { phoneNumber }
    )
    
    -- Se a conta existe, atualiza o timestamp de última visualização
    if accountData then
        MySQL.update.await(
            "UPDATE phone_tinder_accounts SET last_seen = NOW() WHERE phone_number = ?",
            { phoneNumber }
        )
    end
    
    -- Retorna os dados da conta (ou nil se não existir)
    return accountData
end, false)
-- Callback para obter o feed de perfis compatíveis (algoritmo de matching)
BaseCallback("tinder:getFeed", function(source, phoneNumber, page)
    -- Query complexa que implementa o algoritmo de matching do Tinder
    return MySQL.query.await([[
        SELECT
            a.`name`, a.phone_number, a.photos, a.bio, a.dob
        FROM
            phone_tinder_accounts a
        JOIN
            phone_tinder_accounts b
        ON
            b.phone_number = @phoneNumber
        WHERE
            a.phone_number != @phoneNumber
            AND a.`active` = 1
            -- Verifica compatibilidade de gênero baseada nas preferências
            -- Se 'a' é homem e 'b' tem interesse em homens, OU 'a' não é homem e 'b' não tem interesse apenas em mulheres
            AND (a.is_male = b.interested_men OR a.is_male=(NOT b.interested_women))
            -- Verifica se 'a' tem interesse no gênero de 'b'
            AND (a.interested_men=b.is_male OR a.interested_women=(NOT b.is_male))
            -- Exclui perfis que já foram avaliados (swipados)
            AND NOT EXISTS (SELECT TRUE FROM phone_tinder_swipes WHERE swiper = @phoneNumber AND swipee = a.phone_number)
        ORDER BY a.phone_number
        LIMIT @page, @perPage
    ]], {
        ["@phoneNumber"] = phoneNumber,
        ["@page"] = page * 10,  -- Calcula o offset baseado na página
        ["@perPage"] = 10       -- 10 perfis por página
    })
end, {})
-- Callback para processar swipes (curtir/rejeitar) e detectar matches
BaseCallback("tinder:swipe", function(source, swiperNumber, swipeeNumber, liked)
    -- Registra o swipe no banco de dados
    local swipeResult = MySQL.query.await(
        "INSERT INTO phone_tinder_swipes (swiper, swipee, liked) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE liked = ?",
        { swiperNumber, swipeeNumber, liked, liked }
    )
    
    -- Se houve erro na inserção ou foi um dislike, retorna false
    if swipeResult == 0 or not liked then
        return false
    end
    
    -- Verifica se a outra pessoa também curtiu (mutual like = match)
    local mutualLike = MySQL.scalar.await(
        "SELECT liked FROM phone_tinder_swipes WHERE swiper = ? AND swipee = ?",
        { swipeeNumber, swiperNumber }
    )
    
    -- Se não houve curtida mútua, não é um match
    if mutualLike ~= true then
        return false
    end
    
    -- Cria o match no banco de dados
    MySQL.update.await(
        "INSERT INTO phone_tinder_matches (phone_number_1, phone_number_2) VALUES (?, ?)",
        { swiperNumber, swipeeNumber }
    )
    
    -- Obtém dados do usuário que fez o swipe para a notificação
    local swiperData = MySQL.single.await(
        "SELECT `name`, photos FROM phone_tinder_accounts WHERE phone_number = ?",
        { swiperNumber }
    )
    
    -- Se não conseguiu obter os dados, retorna sem notificação
    if not swiperData then
        return
    end
    
    -- Envia notificação de match para o usuário que recebeu o like
    SendNotification(swipeeNumber, {
        app = "Tinder",
        title = L("BACKEND.TINDER.NEW_MATCH"),
        content = L("BACKEND.TINDER.MATCHED_WITH", { name = swiperData.name }),
        thumbnail = json.decode(swiperData.photos)[1]  -- Primeira foto do perfil
    })
    
    -- Retorna true indicando que houve um match
    return true
end)
-- Callback para obter todos os matches do usuário
BaseCallback("tinder:getMatches", function(source, phoneNumber)
    -- Busca todos os matches do usuário com dados dos perfis
    return MySQL.query.await([[
        SELECT
            a.`name`, a.phone_number, a.photos, a.dob, a.bio, a.is_male, b.latest_message
        FROM
            phone_tinder_accounts a
        JOIN
            phone_tinder_matches b
        ON
            -- Match pode estar em qualquer ordem (phone_number_1 ou phone_number_2)
            (b.phone_number_1 = @phoneNumber AND b.phone_number_2 = a.phone_number)
            OR
            (b.phone_number_2 = @phoneNumber AND b.phone_number_1 = a.phone_number)
        ORDER BY b.latest_message_timestamp DESC
    ]], {
        ["@phoneNumber"] = phoneNumber
    })
end)
-- Callback para enviar mensagens entre matches
BaseCallback("tinder:sendMessage", function(source, senderNumber, recipientNumber, content, attachments)
    -- Verifica se a mensagem contém palavras banidas
    if ContainsBlacklistedWord(source, "Spark", content) then
        return false
    end
    
    -- Obtém dados do remetente para notificações
    local senderData = MySQL.single.await(
        "SELECT `name`, photos FROM phone_tinder_accounts WHERE phone_number = ?",
        { senderNumber }
    )
    
    -- Se não encontrou o remetente, retorna true (sem erro mas sem processar)
    if not senderData then
        return true
    end
    
    -- Insere a mensagem no banco de dados
    local messageId = MySQL.insert.await(
        "INSERT INTO phone_tinder_messages (sender, recipient, content, attachments) VALUES (?, ?, ?, ?)",
        { senderNumber, recipientNumber, content, attachments }
    )
    
    -- Se houve erro na inserção, retorna false
    if not messageId then
        return false
    end
    
    -- Atualiza a última mensagem no match para ordenação
    MySQL.update.await(
        "UPDATE phone_tinder_matches SET latest_message = ? WHERE (phone_number_1 = ? AND phone_number_2 = ?) OR (phone_number_2 = ? AND phone_number_1 = ?)",
        { content, senderNumber, recipientNumber, senderNumber, recipientNumber }
    )
    
    -- Obtém o source do destinatário (se estiver online)
    local recipientSource = GetSourceFromNumber(recipientNumber)
    
    -- Se o destinatário está online, envia evento em tempo real
    if recipientSource then
        TriggerClientEvent("phone:tinder:receiveMessage", recipientSource, {
            sender = senderNumber,
            recipient = recipientNumber,
            content = content,
            attachments = attachments,
            timestamp = os.time() * 1000  -- Timestamp em millisegundos
        })
    end
    
    -- Prepara thumbnail para notificação (primeira imagem dos anexos, se houver)
    local thumbnail = nil
    if attachments then
        local attachmentData = json.decode(attachments)
        thumbnail = attachmentData[1]
    end
    
    -- Envia notificação push para o destinatário
    SendNotification(recipientNumber, {
        app = "Tinder",
        title = senderData.name,
        content = content,
        thumbnail = thumbnail,
        avatar = json.decode(senderData.photos)[1],  -- Primeira foto do perfil do remetente
        showAvatar = true
    })
    
    -- Retorna true indicando sucesso
    return true
end)
-- Callback para obter mensagens de uma conversa específica
BaseCallback("tinder:getMessages", function(source, phoneNumber, targetNumber, page)
    -- Busca mensagens entre dois usuários com paginação
    return MySQL.query.await([[
        SELECT
            sender, recipient, content, attachments, timestamp
        FROM
            phone_tinder_messages
        WHERE
            (sender = @phoneNumber AND recipient = @number)
            OR
            (recipient = @phoneNumber AND sender = @number)
        ORDER BY timestamp DESC
        LIMIT @page, @perPage
    ]], {
        ["@phoneNumber"] = phoneNumber,
        ["@number"] = targetNumber,
        ["@page"] = page * 25,  -- Calcula offset baseado na página
        ["@perPage"] = 25       -- 25 mensagens por página
    })
end)
-- Thread para desativação automática de contas inativas
CreateThread(function()
    -- Verifica se a desativação automática está habilitada
    if not Config.AutoDisableSparkAccounts then
        return
    end
    
    -- Configurações padrão
    local checkInterval = 3600000  -- 1 hora em millisegundos
    local inactiveDays = 7         -- 7 dias padrão
    
    -- Se a configuração for um número específico de dias
    if type(Config.AutoDisableSparkAccounts) == "number" then
        inactiveDays = math.max(Config.AutoDisableSparkAccounts, 1) -- Mínimo 1 dia
    end
    
    -- Aguarda o banco de dados estar pronto
    while true do
        if DatabaseCheckerFinished then
            break
        end
        Wait(500)
    end
    
    -- Loop principal de verificação
    while true do
        -- Desativa contas que não foram acessadas por X dias
        MySQL.update(
            "UPDATE phone_tinder_accounts SET active = 0 WHERE active = 1 AND last_seen < NOW() - INTERVAL ? DAY",
            { inactiveDays },
            function(affectedRows)
                debugprint("Disabled", affectedRows, "inactive Spark accounts.")
            end
        )
        
        -- Aguarda antes da próxima verificação
        Wait(checkInterval)
    end
end)
