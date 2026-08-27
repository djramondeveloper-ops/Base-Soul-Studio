-- Cache para gerenciar compartilhamentos de álbuns pendentes
local pendingAlbumShares = {}

-- Callback principal para compartilhar conteúdo via AirShare
BaseCallback("airShare:share", function(senderSource, phoneNumber, targetSource, targetDevice, shareData)
    -- Obtém o nome do remetente do state do jogador
    local senderName = Player(senderSource).state.phoneName
    if type(senderName) ~= "string" or senderName == "" then
        -- Seoul fallback: sharing must not fail only because an older client
        -- path opened the phone without synchronizing its display name.
        senderName = GetEquippedPhoneNumber(senderSource)
    end

    if type(senderName) ~= "string" or senderName == "" then
        debugprint("AirShare: sender has no equipped phone/name")
        return false
    end
    
    -- Configura informações do remetente
    local senderInfo = {
        name = senderName,
        source = senderSource,
        device = "phone"
    }
    shareData.sender = senderInfo
    
    -- Processa compartilhamento baseado no dispositivo de destino
    if targetDevice == "tablet" then
        -- Verifica se o recurso lb-tablet está rodando
        if GetResourceState("lb-tablet") == "started" then
            -- Verifica se o target tem o tablet aberto
            if Player(targetSource).state.lbTabletOpen then
                TriggerClientEvent("tablet:airShare:received", targetSource, shareData)
            else
                return false
            end
        else
            return false
        end
        
    elseif targetDevice == "phone" then
        -- Verifica se o telefone do target está aberto
        if not Player(targetSource).state.phoneOpen then
            debugprint("sendToSource's phone is not open")
            return false
        end
        
        TriggerClientEvent("phone:airShare:received", targetSource, shareData)
    end
    
    -- Gerencia compartilhamentos de álbum (requer confirmação)
    if shareData.type == "album" then
        -- Inicializa cache do target se não existir
        if not pendingAlbumShares[targetSource] then
            pendingAlbumShares[targetSource] = {}
        end
        
        -- Armazena o ID do álbum para o remetente
        pendingAlbumShares[targetSource][senderSource] = shareData.album.id
    end
    
    return true
end, false)
-- Event para processar interações do usuário com compartilhamentos AirShare
RegisterNetEvent("phone:airShare:interacted", function(senderSource, senderDevice, accepted)
    local receiverSource = source
    
    -- Validação dos parâmetros
    if type(senderSource) ~= "number" or type(senderDevice) ~= "string" then
        debugprint("AirShare:interacted: Invalid senderSource or senderDevice", senderSource, senderDevice)
        return
    end
    
    -- Notifica o remetente sobre a interação (aceitou/rejeitou)
    if senderDevice == "tablet" then
        TriggerClientEvent("tablet:airShare:interacted", senderSource, receiverSource, accepted)
    elseif senderDevice == "phone" then
        TriggerClientEvent("phone:airShare:interacted", senderSource, receiverSource, accepted)
    end
    
    -- Gerencia compartilhamentos de álbum pendentes
    if pendingAlbumShares[receiverSource] then
        local albumId = pendingAlbumShares[receiverSource][senderSource]
        if albumId then
            -- Remove da lista de pendentes
            pendingAlbumShares[receiverSource][senderSource] = nil
            
            -- Se não há mais compartilhamentos pendentes, remove o receiver
            if not next(pendingAlbumShares[receiverSource]) then
                pendingAlbumShares[receiverSource] = nil
            end
            
            -- Processa baseado na resposta do usuário
            if not accepted then
                debugprint("AirShare: denied album share", albumId)
                return
            end
            
            debugprint("AirShare: accepted album share", albumId)
            HandleAcceptAirShareAlbum(receiverSource, senderSource, albumId)
        end
    end
end)
-- Tipos de compartilhamento suportados pelo AirShare
local supportedShareTypes = {
    image = true,
    contact = true,
    location = true,
    note = true,
    voicememo = true
}

-- Export da função principal AirShare
exports("AirShare", function(senderSource, targetSource, shareType, shareData)
    -- Validação dos parâmetros obrigatórios
    assert(type(senderSource) == "number", "Invalid sender")
    assert(type(targetSource) == "number", "Invalid target")
    assert(supportedShareTypes[shareType], "Invalid shareType")
    assert(type(shareData) == "table", "Invalid data")
    
    -- Verifica se o remetente tem um telefone equipado
    local senderPhoneNumber = GetEquippedPhoneNumber(senderSource)
    if not senderPhoneNumber then
        return false
    end
    
    -- Estrutura base do compartilhamento
    local sharePackage = {}
    sharePackage.type = shareType
    
    -- Informações do remetente
    local player = Player(senderSource)
    local senderName = player and player.state.phoneName or senderPhoneNumber
    
    sharePackage.sender = {
        name = senderName,
        source = senderSource,
        device = "phone"
    }
    -- Processamento específico por tipo de compartilhamento
    if shareType == "image" then
        sharePackage.attachment = shareData
        assert(shareData.src, "Invalid image data (missing src)")
        
        -- Adiciona timestamp se não existir
        if not sharePackage.attachment.timestamp then
            sharePackage.attachment.timestamp = os.time() * 1000
        end
    elseif shareType == "contact" then
        sharePackage.contact = shareData
        assert(type(sharePackage.contact.number) == "string", "Invalid/missing contact data (contact.number)")
        assert(type(sharePackage.contact.firstname) == "string", "Invalid/missing contact data (contact.firstname)")
    elseif shareType == "location" then
        assert(shareData.location, "Invalid location data (missing location)")
        assert(type(shareData.name) == "string", "Invalid/missing location data (location.name)")
        
        sharePackage.location = shareData.location
        sharePackage.name = shareData.name
    elseif shareType == "note" then
        sharePackage.note = shareData
        assert(type(sharePackage.note.title) == "string", "Invalid/missing note data (note.title)")
        assert(type(sharePackage.note.content) == "string", "Invalid/missing note data (note.content)")
    elseif shareType == "voicememo" then
        sharePackage.voicememo = shareData
        assert(type(sharePackage.voicememo.title) == "string", "Invalid/missing voicememo data (voicememo.title)")
        assert(type(sharePackage.voicememo.src) == "string", "Invalid/missing voicememo data (voicememo.src)")
        assert(type(sharePackage.voicememo.duration) == "number", "Invalid/missing voicememo data (voicememo.duration)")
    end
    
    -- Envia o compartilhamento para o target
    TriggerClientEvent("phone:airShare:received", targetSource, sharePackage)
end)
-- Event para limpar dados quando um jogador desconecta
AddEventHandler("playerDropped", function()
    local playerSource = source
    
    -- Remove compartilhamentos de álbum pendentes para este jogador
    pendingAlbumShares[playerSource] = nil
end)
