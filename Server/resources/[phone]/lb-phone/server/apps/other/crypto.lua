-- Verifica se o módulo de crypto está habilitado
if not Config.Crypto or not Config.Crypto.Enabled then
    debugprint("crypto disabled")
    return
end

-- Define os limites padrão caso não estejam configurados
local cryptoLimits = Config.Crypto.Limits or {
    Buy = 1000000,
    Sell = 1000000
}
-- Contador de requisições para evitar spam à API
local requestCount = 0

-- Função para fazer requisições HTTP à API do CoinGecko
function PerformAPIRequest(endpoint)
    -- Limita a 5 requisições por minuto para evitar rate limiting
    if requestCount >= 5 then
        return false
    end
    
    requestCount = requestCount + 1
    
    -- Reset do contador após 1 minuto
    SetTimeout(60000, function()
        requestCount = requestCount - 1
    end)
    
    local promise = promise.new()
    local url = "https://api.coingecko.com/api/v3/" .. endpoint
    
    PerformHttpRequest(url, function(statusCode, responseData)
        local decodedData = false
        
        if responseData then
            decodedData = json.decode(responseData) or false
        end
        
        promise:resolve(decodedData)
    end, "GET", "", {
        ["Content-Type"] = "application/json"
    })
    
    return Citizen.Await(promise)
end
-- Estrutura global para armazenar dados das criptomoedas
local cryptoData = {
    hasFetched = false,
    coins = {},
    customCoins = {}
}

-- String com IDs das moedas configuradas para a API
local coinIdsString = nil
if Config.Crypto.Coins and #Config.Crypto.Coins > 0 then
    coinIdsString = table.concat(Config.Crypto.Coins, ",")
end
-- Função para buscar dados das criptomoedas da API ou cache
function FetchCryptoData()
    -- Verifica cache local primeiro
    local lastFetched = GetResourceKvpInt("lb-phone:crypto:lastFetched") or 0
    local currentTime = os.time()
    local cacheExpireTime = currentTime - (Config.Crypto.Refresh / 1000)
    
    -- Se o cache ainda é válido, usa os dados salvos
    if lastFetched > cacheExpireTime then
        local cachedData = GetResourceKvpString("lb-phone:crypto:coins")
        if cachedData then
            cryptoData.coins = json.decode(cachedData)
            
            -- Adiciona moedas customizadas aos dados
            for coinId, coinData in pairs(cryptoData.customCoins) do
                cryptoData.coins[coinId] = coinData
            end
            
            debugprint("crypto: using kvp cache")
            return
        end
    end
    
    -- Busca dados da API se há moedas configuradas
    local apiData = {}
    if coinIdsString then
        local endpoint = "coins/markets?vs_currency=" .. Config.Crypto.Currency .. 
                        "&sparkline=true&order=market_cap_desc&precision=full&per_page=100&page=1&ids=" .. coinIdsString
        apiData = PerformAPIRequest(endpoint) or {}
    end
    
    if not apiData then
        debugprint("failed to fetch coins")
        return
    end
    
    -- Processa dados da API e formata para uso interno
    for i = 1, #apiData do
        local coinInfo = apiData[i]
        local formattedCoin = {
            id = coinInfo.id,
            name = coinInfo.name,
            symbol = coinInfo.symbol,
            image = coinInfo.image,
            current_price = coinInfo.current_price,
            prices = coinInfo.sparkline_in_7d and coinInfo.sparkline_in_7d.price or nil,
            change_24h = coinInfo.price_change_percentage_24h
        }
        
        cryptoData.coins[coinInfo.id] = formattedCoin
    end
    
    -- Adiciona moedas customizadas
    for coinId, coinData in pairs(cryptoData.customCoins) do
        cryptoData.coins[coinId] = coinData
    end
    
    -- Salva no cache
    SetResourceKvpInt("lb-phone:crypto:lastFetched", os.time())
    SetResourceKvp("lb-phone:crypto:coins", json.encode(cryptoData.coins))
    
    debugprint("fetched coins")
end
-- Thread principal para atualizar dados de crypto periodicamente
CreateThread(function()
    while true do
        FetchCryptoData()
        cryptoData.hasFetched = true
        
        -- Envia dados atualizados para todos os clientes
        TriggerClientEvent("phone:crypto:updateCoins", -1, cryptoData.coins)
        
        -- Aguarda o intervalo configurado antes da próxima atualização
        Wait(Config.Crypto.Refresh)
    end
end)
-- Função auxiliar para adicionar criptomoedas ao banco de dados
function AddCryptoToDatabase(playerId, coinId, amount, investedAmount)
    local invested = investedAmount or 0
    
    MySQL.update.await(
        "INSERT INTO phone_crypto (id, coin, amount, invested) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE amount = amount + VALUES(amount), invested = invested + VALUES(invested)",
        {playerId, coinId, amount, invested}
    )
end
-- Callback para obter dados de criptomoedas do jogador
RegisterCallback("crypto:get", function(source)
    local playerId = GetIdentifier(source)
    
    -- Aguarda até que os dados sejam carregados e o database checker termine
    while not cryptoData.hasFetched or not DatabaseCheckerFinished do
        Wait(500)
    end
    
    -- Busca as criptomoedas do jogador no banco de dados
    local playerCrypto = MySQL.query.await(
        "SELECT coin, amount, invested FROM phone_crypto WHERE id = ?",
        {playerId}
    )
    
    -- Faz uma cópia profunda dos dados das moedas
    local coinData = table.deep_clone(cryptoData.coins)
    
    -- Adiciona informações de propriedade do jogador
    for i = 1, #playerCrypto do
        local cryptoRecord = playerCrypto[i]
        if cryptoRecord and coinData[cryptoRecord.coin] then
            coinData[cryptoRecord.coin].owned = cryptoRecord.amount
            coinData[cryptoRecord.coin].invested = cryptoRecord.invested
        end
    end
    
    return coinData
end)
-- Callback para comprar criptomoedas
RegisterCallback("crypto:buy", function(source, coinId, purchaseAmount)
    local playerId = GetIdentifier(source)
    local playerBalance = GetBalance(source)
    
    -- Validação de quantidade
    if purchaseAmount <= 0 then
        return {success = false, msg = "INVALID_AMOUNT"}
    end
    
    -- Verifica limite de compra
    if purchaseAmount > cryptoLimits.Buy then
        debugprint(purchaseAmount, "is above crypto buy limit")
        return {success = false, msg = "INVALID_AMOUNT"}
    end
    
    -- Verifica se o jogador tem dinheiro suficiente
    if purchaseAmount > playerBalance then
        return {success = false, msg = "NO_MONEY"}
    end
    
    -- Verifica se a moeda existe
    local coinData = cryptoData.coins[coinId]
    if not coinData then
        return {success = false, msg = "INVALID_COIN"}
    end
    
    -- Verifica se o jogador tem identificador válido
    if not playerId then
        return {success = false, msg = "NO_IDENTIFIER"}
    end
    
    -- Calcula quantidade de moedas a receber
    local coinAmount = purchaseAmount / coinData.current_price
    
    -- Adiciona moedas ao banco de dados
    AddCryptoToDatabase(playerId, coinId, coinAmount, purchaseAmount)
    
    -- Remove dinheiro do jogador
    RemoveMoney(source, purchaseAmount)
    
    -- Log da transação
    Log("Crypto", source, "success", 
        L("BACKEND.LOGS.BOUGHT_CRYPTO"),
        L("BACKEND.LOGS.CRYPTO_DETAILS", {
            coin = coinId,
            amount = coinAmount,
            price = purchaseAmount
        })
    )
    
    return {success = true}
end, {preventSpam = true})
-- Callback para vender criptomoedas
RegisterCallback("crypto:sell", function(source, coinId, sellAmount)
    local playerId = GetIdentifier(source)
    
    -- Validação de quantidade
    if sellAmount <= 0 then
        return {success = false, msg = "INVALID_AMOUNT"}
    end
    
    -- Verifica quantas moedas o jogador possui
    local playerCrypto = MySQL.single.await(
        "SELECT amount, invested FROM phone_crypto WHERE id = ? AND coin = ?",
        {playerId, coinId}
    )
    
    if not playerCrypto then
        return {success = false, msg = "NO_COINS"}
    end
    
    -- Verifica se tem moedas suficientes para vender
    if sellAmount > playerCrypto.amount then
        return {success = false, msg = "NOT_ENOUGH_COINS"}
    end
    
    -- Verifica se a moeda existe
    local coinData = cryptoData.coins[coinId]
    if not coinData then
        return {success = false, msg = "INVALID_COIN"}
    end
    
    -- Calcula valor da venda
    local saleValue = sellAmount * coinData.current_price
    
    -- Verifica limite de venda
    if saleValue > cryptoLimits.Sell then
        debugprint(saleValue, "is above crypto sell limit")
        return {success = false, msg = "INVALID_AMOUNT"}
    end
    
    -- Remove moedas do banco de dados
    MySQL.update.await(
        "UPDATE phone_crypto SET amount = amount - ?, invested = invested - ? WHERE id = ? AND coin = ?",
        {sellAmount, saleValue, playerId, coinId}
    )
    
    -- Adiciona dinheiro ao jogador
    AddMoney(source, saleValue)
    
    -- Log da transação
    Log("Crypto", source, "error",  -- Nota: era "error" no código original
        L("BACKEND.LOGS.SOLD_CRYPTO"),
        L("BACKEND.LOGS.CRYPTO_DETAILS", {
            coin = coinId,
            amount = sellAmount,
            price = saleValue
        })
    )
    
    return {success = true}
end, {preventSpam = true})
-- Callback para transferir criptomoedas entre jogadores
BaseCallback("crypto:transfer", function(source, senderNumber, coinId, transferAmount, recipientNumber)
    -- Verifica se a moeda existe
    local coinData = cryptoData.coins[coinId]
    if not coinData then
        return {success = false, msg = "INVALID_COIN"}
    end
    
    -- Tenta encontrar o destinatário online primeiro
    local recipientSource = GetSourceFromNumber(recipientNumber)
    local recipientId = nil
    
    if recipientSource then
        recipientId = GetIdentifier(recipientSource)
    else
        -- Se não está online, busca no banco de dados
        if not Config.Item.Unique then
            recipientId = MySQL.scalar.await(
                "SELECT id FROM phone_phones WHERE phone_number = ?",
                {recipientNumber}
            )
        else
            recipientId = MySQL.scalar.await(
                "SELECT owned_id FROM phone_phones WHERE phone_number = ?",
                {recipientNumber}
            )
        end
    end
    
    -- Verifica se o número é válido
    if not recipientId then
        return {success = false, msg = "INVALID_NUMBER"}
    end
    
    local senderId = GetIdentifier(source)
    
    -- Validação de quantidade
    if transferAmount <= 0 then
        return {success = false, msg = "INVALID_AMOUNT"}
    end
    
    -- Verifica quantas moedas o remetente possui
    local senderAmount = MySQL.scalar.await(
        "SELECT amount FROM phone_crypto WHERE id = ? AND coin = ?",
        {senderId, coinId}
    ) or 0
    
    if transferAmount > senderAmount then
        return {success = false, msg = "INVALID_AMOUNT"}
    end
    
    -- Remove moedas do remetente
    MySQL.update.await(
        "UPDATE phone_crypto SET amount = amount - ? WHERE id = ? AND coin = ?",
        {transferAmount, senderId, coinId}
    )
    
    -- Adiciona moedas ao destinatário
    AddCryptoToDatabase(recipientId, coinId, transferAmount)
    
    -- Envia notificação ao destinatário
    local transferValue = math.floor(transferAmount * coinData.current_price + 0.5)
    SendNotification(recipientNumber, {
        app = "Crypto",
        title = L("BACKEND.CRYPTO.RECEIVED_TRANSFER_TITLE", {coin = coinData.name}),
        content = L("BACKEND.CRYPTO.RECEIVED_TRANSFER_DESCRIPTION", {
            amount = transferAmount,
            coin = coinData.name,
            value = transferValue
        })
    })
    
    -- Log da transação
    Log("Crypto", source, "error",  -- Nota: era "error" no código original
        L("BACKEND.LOGS.TRANSFERRED_CRYPTO"),
        L("BACKEND.LOGS.TRANSFERRED_CRYPTO_DETAILS", {
            coin = coinId,
            amount = transferAmount,
            to = recipientNumber,
            from = senderNumber
        })
    )
    
    -- Atualiza cliente se o destinatário estiver online
    if recipientSource then
        TriggerClientEvent("phone:crypto:changeOwnedAmount", recipientSource, coinId, transferAmount)
    end
    
    return {success = true}
end, {preventSpam = true})
-- Export para adicionar criptomoedas a um jogador
exports("AddCrypto", function(source, coinId, amount)
    local playerId = GetIdentifier(source)
    
    -- Verifica se a moeda é válida
    if not cryptoData.coins[coinId] then
        print("invalid coin", coinId)
        return false
    end
    
    -- Verifica se o jogador tem identificador válido
    if not playerId then
        print("no identifier")
        return false
    end
    
    -- Adiciona moedas ao banco de dados
    AddCryptoToDatabase(playerId, coinId, amount)
    
    -- Atualiza o cliente
    TriggerClientEvent("phone:crypto:changeOwnedAmount", source, coinId, amount)
    
    return true
end)
-- Export para remover criptomoedas de um jogador
exports("RemoveCrypto", function(source, coinId, amount)
    local playerId = GetIdentifier(source)
    
    -- Verifica se a moeda é válida
    if not cryptoData.coins[coinId] then
        print("invalid coin", coinId)
        return false
    end
    
    -- Verifica se o jogador tem identificador válido
    if not playerId then
        print("no identifier")
        return false
    end
    
    -- Remove moedas do banco de dados
    MySQL.Async.execute(
        "UPDATE phone_crypto SET amount = amount - ? WHERE id = ? AND coin = ?",
        {amount, playerId, coinId}
    )
    
    -- Atualiza o cliente (quantidade negativa para indicar remoção)
    TriggerClientEvent("phone:crypto:changeOwnedAmount", source, coinId, -amount)
    
    return true
end)
-- Export para adicionar moedas customizadas ao sistema
exports("AddCustomCoin", function(coinId, coinName, coinSymbol, coinImage, currentPrice, priceHistory, change24h)
    -- Validações de tipo
    assert(type(coinId) == "string", "id must be a string")
    assert(type(coinName) == "string", "name must be a string")
    assert(type(coinSymbol) == "string", "symbol must be a string")
    assert(type(coinImage) == "string", "image must be a string")
    assert(type(currentPrice) == "number", "currentPrice must be a number")
    assert(type(priceHistory) == "table", "prices must be a table")
    assert(type(change24h) == "number", "change24h must be a number")
    
    -- Cria estrutura da moeda customizada
    local customCoin = {
        id = coinId,
        name = coinName,
        symbol = coinSymbol,
        image = coinImage,
        current_price = currentPrice,
        prices = priceHistory,
        change_24h = change24h
    }
    
    -- Adiciona às listas de moedas
    cryptoData.customCoins[coinId] = customCoin
    cryptoData.coins[coinId] = customCoin
    
    -- Atualiza cache
    SetResourceKvp("lb-phone:crypto:coins", json.encode(cryptoData.coins))
    
    -- Notifica todos os clientes
    TriggerClientEvent("phone:crypto:updateCoins", -1, cryptoData.coins)
end)
-- Export para obter informações de uma moeda específica
exports("GetCoin", function(coinId)
    return cryptoData.coins[coinId]
end)
