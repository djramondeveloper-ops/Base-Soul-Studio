-- Sistema de Relatório de Erros via Discord Webhook
-- Contador para rate limiting (máximo 5 erros por minuto)
local errorCounter = 0

-- Event para processar erros enviados pelo cliente
RegisterNetEvent("phone:logError", function(errorMessage, stackTrace, componentStack)
    -- Rate limiting: máximo 5 erros por minuto
    if errorCounter >= 5 then
        return
    end
    
    -- Incrementa contador de erros
    errorCounter = errorCounter + 1
    
    -- Programa redução do contador após 1 minuto
    SetTimeout(60000, function()
        errorCounter = errorCounter - 1
    end)
    
    -- Template da mensagem formatada para Discord
    local messageTemplate = [[
**Message**: `%s`
**Stack**:```%s```**Component Stack**:```%s```**Version**: `%s`]]
    
    -- Limita o tamanho do stack trace para evitar mensagens muito longas
    local truncatedStackTrace = stackTrace:sub(1, 800)
    local truncatedComponentStack = componentStack:sub(1, 800)
    
    -- Obtém a versão do recurso
    local resourceVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
    
    -- Formata a mensagem final
    local formattedMessage = messageTemplate:format(
        errorMessage,
        truncatedStackTrace,
        truncatedComponentStack,
        resourceVersion
    )
    
    -- URL do webhook do Discord para relatórios de erro
    local discordWebhookUrl = "https://discord.com/api/webhooks/1382707957040681091/KNVHDkvWAhcmfeYb4T5c_TwRmJ4XPn3J8MadXRUvd3ldH9QX7yqLcQKixdf1F8wLGVJm"
    
    -- Prepara os dados para envio ao Discord
    local webhookData = {
        content = formattedMessage:sub(1, 2000), -- Limita a 2000 caracteres (limite do Discord)
        username = GetConvar("sv_hostname", "unknown server") -- Nome do servidor como username
    }
    
    -- Envia o erro para o Discord webhook
    PerformHttpRequest(
        discordWebhookUrl,
        function(responseCode, responseText, headers)
            -- Callback vazio - não precisa processar resposta
        end,
        "POST",
        json.encode(webhookData),
        {
            ["Content-Type"] = "application/json"
        }
    )
end)
