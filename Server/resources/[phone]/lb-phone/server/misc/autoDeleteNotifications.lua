-- Sistema de auto-deletar notificações antigas
-- Verifica se a funcionalidade está habilitada na configuração
if not Config.AutoDeleteNotifications then
    return
end

-- Valida e define o valor padrão para o tempo de retenção das notificações
if type(Config.AutoDeleteNotifications) ~= "number" then
    -- Define 168 horas (7 dias) como padrão se não for um número válido
    Config.AutoDeleteNotifications = 168
end
-- Aguarda o DatabaseChecker finalizar antes de iniciar a limpeza automática
while true do
    if DatabaseCheckerFinished then
        break
    end
    Wait(500) -- Aguarda 500ms antes de verificar novamente
end
-- Loop infinito para limpeza automática das notificações antigas
while true do
    debugprint("Deleting all old notifications..")
    
    -- Marca o tempo de início da operação para performance tracking
    local startTime = os.nanotime()
    
    -- Executa query para deletar notificações antigas
    MySQL.update(
        "DELETE FROM phone_notifications WHERE `timestamp` < DATE_SUB(NOW(), INTERVAL ? HOUR)",
        { Config.AutoDeleteNotifications },
        function(affectedRows)
            -- Calcula o tempo total da operação
            local endTime = os.nanotime()
            local executionTime = (endTime - startTime) / 1000000.0 -- Converte para milissegundos
            
            -- Determina se deve usar singular ou plural para "notification"
            local notificationText = "notification" .. (affectedRows == 1 and "" or "s")
            
            -- Log do resultado da operação
            debugprint("Deleted " .. affectedRows .. " " .. notificationText .. " in " .. executionTime .. " ms")
        end
    )
    
    -- Aguarda 1 hora (3600000ms) antes da próxima limpeza
    Wait(3600000)
end
