-- Sistema de Estatísticas e Tracking do lb-phone
-- Coleta e envia dados de uso para análise e melhorias

-- Obtém a versão do recurso
local resourceVersion = GetResourceMetadata(GetCurrentResourceName(), "version", 0)
if not resourceVersion then
    resourceVersion = "0.0.0"
end

-- Verifica se está usando versão de desenvolvimento (UI não compilada)
local isDevVersion = GetResourceMetadata(GetCurrentResourceName(), "ui_page", 0) ~= "ui/dist/index.html"

-- Configurações do sistema de estatísticas
local maxEventsPerBatch = 25
local videoExtensions = {"webm", "mp4", "mov"}

-- Variáveis de controle
local eventQueue = {}
local eventCount = 0
local serverId = nil
-- Valida o formato da versão (deve ser x.x.x)
if not resourceVersion:match("^%d+%.%d+%.%d+$") then
    resourceVersion = "0.0.0"
end
-- Função principal para enviar estatísticas para o servidor de tracking
local function SendStatistics(forceSubmit)
    -- Só envia se tiver eventos suficientes ou se for forçado
    if not forceSubmit and eventCount < maxEventsPerBatch then
        return
    end
    
    -- Se não há eventos para enviar, retorna
    if eventCount == 0 then
        return
    end
    
    -- Obtém ou gera o ID do servidor na primeira execução
    if not serverId then
        local webBaseUrl = GetConvar("web_baseUrl", "")
        if webBaseUrl == "" then
            return -- Sem URL base, não pode obter server ID
        end
        
        -- Extrai o server ID da URL base (formato: xxx-xxxx.users.cfx.re)
        local urlLength = #webBaseUrl
        local reversedUrl = webBaseUrl:reverse()
        local dashPosition = reversedUrl:find("-")
        
        if not dashPosition then
            dashPosition = urlLength + 1
        end
        
        local startPos = urlLength - dashPosition + 2
        local endPos = urlLength - #".users.cfx.re"
        
        serverId = string.sub(webBaseUrl, startPos, endPos)
    end
    
    -- Prepara os dados para envio
    local statisticsData = {
        serverId = serverId,
        version = resourceVersion,
        events = eventQueue
    }
    
    local jsonData = json.encode(statisticsData)
    
    -- Reset das variáveis para próximo lote
    eventCount = 0
    eventQueue = {}
    
    -- Envia os dados para o servidor de tracking
    PerformHttpRequest(
        "https://track.lbscripts.com/",
        function(responseCode, responseText, headers)
            -- Callback vazio - não precisa processar resposta
        end,
        "POST",
        jsonData,
        {
            ["Content-Type"] = "application/json"
        }
    )
end
-- Função para trackear eventos simples
function TrackSimpleEvent(eventName)
    -- Se está em versão de desenvolvimento, não tracka
    if isDevVersion then
        return
    end
    
    -- Incrementa contador de eventos
    eventCount = eventCount + 1
    
    -- Adiciona evento à fila
    eventQueue[eventCount] = {
        event = eventName
    }
    
    -- Tenta enviar estatísticas se atingiu o limite
    SendStatistics()
end
-- Função para trackear posts em redes sociais
function TrackSocialMediaPost(appName, attachments)
    -- Se está em versão de desenvolvimento, não tracka
    if isDevVersion then
        return
    end
    
    local photoCount = 0
    local videoCount = 0
    
    -- Analisa os anexos para contar fotos e vídeos
    if attachments then
        for i = 1, #attachments do
            local attachment = attachments[i]
            local extension = attachment:match("%.([^.]+)$") or "webp"
            
            -- Verifica se é vídeo ou foto baseado na extensão
            if table.contains(videoExtensions, extension) then
                videoCount = videoCount + 1
            else
                photoCount = photoCount + 1
            end
        end
    end
    
    -- Incrementa contador de eventos
    eventCount = eventCount + 1
    
    -- Adiciona evento à fila
    eventQueue[eventCount] = {
        event = "social_media_post",
        app = appName,
        amountVideos = videoCount,
        amountPhotos = photoCount
    }
    
    -- Tenta enviar estatísticas se atingiu o limite
    SendStatistics()
end
-- Event Handler: Envia estatísticas 1 minuto antes do restart programado
AddEventHandler("txAdmin:events:scheduledRestart", function(eventData)
    if eventData.secondsRemaining == 60 then
        SendStatistics(true) -- Força envio das estatísticas pendentes
    end
end)

-- Event Handler: Envia estatísticas quando servidor está sendo desligado
AddEventHandler("txAdmin:events:serverShuttingDown", function()
    SendStatistics(true) -- Força envio das estatísticas pendentes
end)

-- Event Handler: Envia estatísticas quando este recurso está sendo parado
AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        SendStatistics(true) -- Força envio das estatísticas pendentes
    end
end)
