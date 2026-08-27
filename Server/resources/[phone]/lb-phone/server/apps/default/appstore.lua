-- Sistema da App Store do Telefone
-- Gerencia compra de aplicativos pelos jogadores

-- Legacy callback para comprar aplicativos na App Store
RegisterLegacyCallback("appstore:buyApp", function(playerSource, callback, appPrice)
    -- Obtém o número do telefone equipado pelo jogador
    local phoneNumber = GetEquippedPhoneNumber(playerSource)
    
    -- Verifica se o jogador tem um telefone equipado
    if not phoneNumber then
        callback(false)
        return
    end
    
    -- Tenta remover o dinheiro do jogador para comprar o app
    local success = RemoveMoney(playerSource, appPrice)
    
    -- Retorna o resultado da transação via callback
    callback(success)
end)
