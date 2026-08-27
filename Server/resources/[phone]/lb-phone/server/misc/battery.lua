-- Sistema de Gerenciamento de Bateria do Telefone
-- Cache temporário para armazenar níveis de bateria dos telefones
local batteryCache = {}

-- Event para definir o nível de bateria de um telefone
RegisterNetEvent("phone:battery:setBattery", function(batteryLevel)
    local playerSource = source
    
    -- Verifica se o sistema de bateria está habilitado
    if not Config.Battery.Enabled then
        debugprint("setBattery: battery system disabled")
        return
    end
    
    -- Valida o nível de bateria (deve ser número entre 0 e 100)
    if type(batteryLevel) ~= "number" or batteryLevel < 0 or batteryLevel > 100 then
        debugprint("setBattery: invalid battery level")
        return
    end
    
    -- Obtém o número do telefone equipado pelo jogador
    local phoneNumber = GetEquippedPhoneNumber(playerSource)
    if not phoneNumber then
        return
    end
    
    -- Armazena o nível de bateria no cache
    batteryCache[phoneNumber] = batteryLevel
end)
-- Função para verificar se o telefone está com bateria esgotada
function IsPhoneDead(phoneNumber)
    -- Se o sistema de bateria não está habilitado, telefone nunca está morto
    if not Config.Battery.Enabled then
        return false
    end
    
    -- Verifica se a bateria está em 0%
    return batteryCache[phoneNumber] == 0
end

-- Export da função IsPhoneDead para outros recursos
exports("IsPhoneDead", IsPhoneDead)
-- Função para salvar o nível de bateria na base de dados
function SaveBattery(playerSource)
    -- Obtém o número do telefone equipado pelo jogador
    local phoneNumber = GetEquippedPhoneNumber(playerSource)
    
    -- Verifica se o jogador tem telefone e se há dados de bateria no cache
    if not phoneNumber or not batteryCache[phoneNumber] then
        return
    end
    
    local batteryLevel = batteryCache[phoneNumber]
    
    -- Log da operação de salvamento
    debugprint(("saving battery level (%s) for %s"):format(batteryLevel, phoneNumber))
    
    -- Atualiza o nível de bateria na base de dados
    MySQL.update(
        "UPDATE phone_phones SET battery = ? WHERE phone_number = ?",
        { batteryLevel, phoneNumber },
        function()
            -- Remove do cache após salvar na base de dados
            batteryCache[phoneNumber] = nil
        end
    )
end

-- Export da função SaveBattery para outros recursos
exports("SaveBattery", SaveBattery)
-- Função para salvar todos os níveis de bateria de todos os jogadores
function SaveAllBatteries()
    debugprint("saving all battery levels")
    
    -- Obtém lista de todos os jogadores online
    local players = GetPlayers()
    
    -- Salva a bateria de cada jogador
    for i = 1, #players do
        SaveBattery(players[i])
    end
end

-- Export da função SaveAllBatteries para outros recursos
exports("SaveAllBatteries", SaveAllBatteries)
-- Event Handler: Salva bateria quando jogador desconecta
AddEventHandler("playerDropped", function()
    SaveBattery(source)
end)

-- Event Handler: Salva todas as baterias 1 minuto antes do restart programado
AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
    if eventData.secondsRemaining == 60 then
        SaveAllBatteries()
    end
end)

-- Event Handler: Salva todas as baterias quando servidor está sendo desligado
AddEventHandler("txAdmin:events:serverShuttingDown", SaveAllBatteries)

-- Event Handler: Salva todas as baterias quando este recurso está sendo parado
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        SaveAllBatteries()
    end
end)
