-- Constante que define quantos posts são retornados por página
local POSTS_PER_PAGE = 15
-- Função para buscar posts do marketplace com filtros e paginação
function GetMarketplacePosts(page, filters)
    -- Define página padrão como 0 se não fornecida
    page = page or 0
    
    local queryParams = {}
    local whereConditions = {}
    
    -- Adiciona filtros de busca se fornecidos
    if filters and filters.search then
        -- Busca no título e descrição
        table.insert(whereConditions, "(title LIKE ? OR description LIKE ?)")
        local searchPattern = "%" .. filters.search .. "%"
        table.insert(queryParams, searchPattern)
        table.insert(queryParams, searchPattern)
        
        -- Se não está filtrando por usuário específico, inclui busca por número de telefone
        if not filters.from then
            table.insert(whereConditions, "OR phone_number LIKE ?")
            table.insert(queryParams, searchPattern)
        end
    end
    
    -- Adiciona filtro por número de telefone específico se fornecido
    if filters and filters.from then
        local condition = "phone_number = ?"
        
        -- Adiciona AND se já existem outras condições
        if #whereConditions > 0 then
            condition = "AND " .. condition
        end
        
        table.insert(whereConditions, condition)
        table.insert(queryParams, filters.from)
    end
    
    -- Monta a query SQL base
    local sqlQuery = [[SELECT id, phone_number AS `number`, title, description, attachments, price,  `timestamp` FROM phone_marketplace_posts {WHERE} ORDER BY `timestamp` DESC LIMIT ?, ?]]
    
    -- Substitui o placeholder {WHERE} pelas condições se existirem
    local whereClause = ""
    if #whereConditions > 0 then
        whereClause = "WHERE " .. table.concat(whereConditions, " ")
    end
    sqlQuery = sqlQuery:gsub("{WHERE}", whereClause)
    
    -- Adiciona parâmetros de paginação
    table.insert(queryParams, page * POSTS_PER_PAGE)  -- OFFSET
    table.insert(queryParams, POSTS_PER_PAGE)         -- LIMIT
    
    -- Executa a consulta no banco de dados
    return MySQL.query.await(sqlQuery, queryParams)
end
-- Callback para obter posts do marketplace com paginação e filtros
BaseCallback("marketplace:getPosts", function(source, phoneNumber, requestData)
    -- Extrai dados da requisição
    local page = requestData.page
    local filters = {
        from = requestData.from,    -- Filtrar por número de telefone específico
        search = requestData.query  -- Termo de busca
    }
    
    -- Chama a função de busca e retorna os resultados
    return GetMarketplacePosts(page, filters)
end)
-- Callback para criar um novo post no marketplace
BaseCallback("marketplace:createPost", function(source, phoneNumber, postData)
    -- Extrai dados do post
    local title = postData.title
    local description = postData.description
    local attachments = postData.attachments
    local price = postData.price
    
    -- Validações básicas
    if not (title and description and attachments and price) or price < 0 then
        return false
    end
    
    -- Verifica se o título contém palavras banidas
    if ContainsBlacklistedWord(source, "MarketPlace", title) then
        return false
    end
    
    -- Verifica se a descrição contém palavras banidas
    if ContainsBlacklistedWord(source, "MarketPlace", description) then
        return false
    end
    
    -- Insere o post no banco de dados
    local insertResult = MySQL.insert.await(
        "INSERT INTO phone_marketplace_posts (phone_number, title, description, attachments, price) VALUES (?, ?, ?, ?, ?)",
        {
            phoneNumber,
            title,
            description,
            json.encode(attachments),
            price
        }
    )
    
    -- Verifica se a inserção foi bem-sucedida
    if not insertResult then
        return false
    end
    
    -- Adiciona informações adicionais ao objeto postData para notificações
    postData.number = phoneNumber
    postData.id = insertResult
    
    -- Notifica todos os clientes sobre o novo post
    TriggerClientEvent("phone:marketplace:newPost", -1, postData)
    
    -- Dispara evento server-side para outros recursos
    TriggerEvent("lb-phone:marketplace:newPost", postData)
    
    -- Registra log da criação do post
    Log("Marketplace", source, "info",
        L("BACKEND.LOGS.MARKETPLACE_NEW_TITLE"),
        L("BACKEND.LOGS.MARKETPLACE_NEW_DESCRIPTION", {
            seller = FormatNumber(phoneNumber),
            title = title,
            price = price,
            description = description,
            attachments = json.encode(attachments),
            id = insertResult
        })
    )
    
    -- Retorna o ID do post criado
    return insertResult
end)
-- Callback para deletar um post do marketplace
BaseCallback("marketplace:deletePost", function(source, phoneNumber, postId)
    -- Verifica se o usuário é admin
    local isAdmin = IsAdmin(source)
    
    -- Prepara os parâmetros para a query
    local queryParams = { postId }
    
    -- Define a query SQL base
    local deleteQuery = "DELETE FROM phone_marketplace_posts WHERE id = ?"
    
    -- Se não for admin, adiciona verificação de proprietário
    if not isAdmin then
        deleteQuery = deleteQuery .. " AND phone_number = ?"
        table.insert(queryParams, phoneNumber)
    end
    
    -- Executa a query de deleção
    local rowsAffected = MySQL.update.await(deleteQuery, queryParams)
    
    -- Se alguma linha foi afetada (post foi deletado)
    if rowsAffected > 0 then
        -- Notifica todos os clientes sobre a remoção do post
        TriggerClientEvent("phone:marketplace:deletePost", -1, postId)
        
        -- Dispara evento server-side para outros recursos
        TriggerEvent("lb-phone:marketplace:deletePost", postId)
        
        -- Registra log da deleção do post
        Log("Marketplace", source, "info",
            L("BACKEND.LOGS.MARKETPLACE_DELETED"),
            ("**ID**: %s"):format(postId)
        )
        
        return true
    end
    
    -- Retorna false se nenhum post foi deletado
    return false
end)
