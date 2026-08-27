local testPeds = {}

RegisterCommand("testp", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    local forwardX = coords.x + (math.sin(math.rad(-heading)) * 2.0)
    local forwardY = coords.y + (math.cos(math.rad(-heading)) * 2.0)
    local spawnCoords = vector3(forwardX, forwardY, coords.z)

    -- Cria um clone exato do jogador atual
    local newTestPed = ClonePed(playerPed, heading - 180.0, true, true)
    
    if newTestPed ~= 0 then
        -- Posiciona corretamente na frente do jogador (de frente para ele)
        SetEntityCoordsNoOffset(newTestPed, spawnCoords.x, spawnCoords.y, spawnCoords.z, false, false, false)
        SetEntityHeading(newTestPed, heading - 180.0)
        
        -- Configura como entidade de missão para evitar deleção automática
        SetEntityAsMissionEntity(newTestPed, true, true)
        
        -- Aplica os atributos de jogador (para ragdoll, danos e alvo)
        SetPedCanRagdoll(newTestPed, true)
        SetEntityInvincible(newTestPed, false)
        SetPedCanBeTargetted(newTestPed, true)
        SetPedCanBeTargettedByPlayer(newTestPed, PlayerId(), true)
        
        -- Impede o Ped de fugir ao ouvir tiros ou magias (comportamento de boneco de teste)
        SetBlockingOfNonTemporaryEvents(newTestPed, true)
        SetPedFleeAttributes(newTestPed, 0, false)
        SetPedCombatAttributes(newTestPed, 46, true) 
        
        -- Salva o ped na lista de peds gerados
        table.insert(testPeds, newTestPed)

        -- Aviso de sucesso
        TriggerEvent("Notify", "sucesso", "Clone de teste gerado com sucesso!", "verde", 5000)
    else
        -- Aviso de erro
        TriggerEvent("Notify", "negado", "Falha ao gerar o ped de teste.", "vermelho", 5000)
    end
end, false)

RegisterCommand("remp", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local closestDistance = -1
    local closestPedIndex = -1
    local closestPedId = nil

    -- Percorre a lista de peds para achar o mais próximo
    for i, pedId in ipairs(testPeds) do
        if DoesEntityExist(pedId) then
            local pedCoords = GetEntityCoords(pedId)
            local distance = #(coords - pedCoords)
            
            if closestDistance == -1 or distance < closestDistance then
                closestDistance = distance
                closestPedIndex = i
                closestPedId = pedId
            end
        end
    end

    -- Se achou alguém e está perto (num raio de 5 metros)
    if closestPedIndex ~= -1 and closestDistance <= 5.0 then
        DeleteEntity(closestPedId)
        table.remove(testPeds, closestPedIndex)
        TriggerEvent("Notify", "sucesso", "Clone de teste mais próximo foi removido!", "verde", 5000)
    else
        TriggerEvent("Notify", "aviso", "Nenhum clone de teste próximo para remover.", "amarelo", 5000)
    end
end, false)
