-- Constante que define quantos posts são retornados por página nas páginas amarelas
local POSTS_PER_PAGE = 10

-- Callback para obter posts das páginas amarelas com paginação e filtros
BaseCallback("yellowPages:getPosts", function(source, phoneNumber, page, filters)
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
    local sqlQuery = [[
        SELECT
            id,
            phone_number AS `number`,
            title,
            description,
            attachment,
            price,
            `timestamp`
        FROM
            phone_yellow_pages_posts
        {WHERE}
        ORDER BY
            `timestamp` DESC
        LIMIT ?, ?
    ]]
    
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
end)
-- Callback para criar um novo post nas páginas amarelas
BaseCallback("yellowPages:createPost", function(source, phoneNumber, postData)
    -- Validações básicas - verifica se título e descrição existem
    if not (postData and postData.title and postData.description) then
        return false
    end
    
    -- Verifica se o título contém palavras banidas
    if ContainsBlacklistedWord(source, "Pages", postData.title) then
        return false
    end
    
    -- Verifica se a descrição contém palavras banidas
    if ContainsBlacklistedWord(source, "Pages", postData.description) then
        return false
    end
    
    -- Insere o post no banco de dados usando parâmetros nomeados
    local postId = MySQL.insert.await(
        "INSERT INTO phone_yellow_pages_posts (phone_number, title, description, attachment, price) VALUES (@number, @title, @description, @attachment, @price)",
        {
            ["@number"] = phoneNumber,
            ["@title"] = postData.title,
            ["@description"] = postData.description,
            ["@attachment"] = postData.attachment,
            ["@price"] = tonumber(postData.price)
        }
    )
    
    -- Verifica se a inserção foi bem-sucedida
    if not postId then
        return false
    end
    
    -- Adiciona informações adicionais ao objeto postData para notificações
    postData.id = postId
    postData.number = phoneNumber
    
    -- Notifica todos os clientes sobre o novo post
    TriggerClientEvent("phone:yellowPages:newPost", -1, postData)
    
    -- Dispara evento server-side para outros recursos
    TriggerEvent("lb-phone:pages:newPost", postData)
    
    -- Registra log da criação do post
    Log("YellowPages", source, "info",
        L("BACKEND.LOGS.YELLOWPAGES_NEW_TITLE"),
        L("BACKEND.LOGS.YELLOWPAGES_NEW_DESCRIPTION", {
            title = postData.title,
            description = postData.description,
            attachment = postData.attachment or "",
            id = postData.id
        })
    )
    
    -- Retorna o ID do post criado
    return postId
end)
-- Callback para deletar um post das páginas amarelas
BaseCallback("yellowPages:deletePost", function(source, phoneNumber, postId)
    -- Verifica se o usuário é admin
    local isAdmin = IsAdmin(source)
    
    -- Monta a query de deleção
    local deleteQuery = "DELETE FROM phone_yellow_pages_posts WHERE id = @id"
    
    -- Se não for admin, adiciona verificação de proprietário
    if not isAdmin then
        deleteQuery = deleteQuery .. " AND phone_number = @number"
    end
    
    -- Executa a query de deleção usando parâmetros nomeados
    local rowsAffected = MySQL.update.await(deleteQuery, {
        ["@id"] = postId,
        ["@number"] = phoneNumber
    })
    
    -- Se alguma linha foi afetada (post foi deletado)
    if rowsAffected > 0 then
        -- Notifica todos os clientes sobre a remoção do post
        TriggerClientEvent("phone:yellowPages:deletePost", -1, postId)
        
        -- Dispara evento server-side para outros recursos
        TriggerEvent("lb-phone:pages:deletePost", postId)
        
        -- Registra log da deleção do post
        Log("YellowPages", source, "info",
            L("BACKEND.LOGS.YELLOWPAGES_DELETED"),
            ("**ID**: %s"):format(postId)
        )
        
        return true
    end
    
    -- Retorna false se nenhum post foi deletado
    return false
end)
