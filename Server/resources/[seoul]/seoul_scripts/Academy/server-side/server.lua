if SeoulScriptsServer and not SeoulScriptsServer.Enabled('Academy') then return end

local function nearAnyGym(source)
    local ped = GetPlayerPed(source)
    if not ped or not DoesEntityExist(ped) then return false end
    local coords = GetEntityCoords(ped)
    local groups = {
        AcademyConfig.barraFixa,
        AcademyConfig.pegarBarra,
        AcademyConfig.fazerAbdominal,
        AcademyConfig.fazerFlexao,
        AcademyConfig.fazerCorridinha
    }
    for _,list in ipairs(groups) do
        for _,mark in pairs(list or {}) do
            local pos = vec3(mark[1],mark[2],mark[3])
            if #(coords - pos) <= 4.0 then return true end
        end
    end
    return false
end

RegisterNetEvent('Academy:upgradeWeight')
AddEventHandler('Academy:upgradeWeight', function()
    local source = source
    if not SeoulScriptsServer.CheckCooldown(source,'academy',15000) then return end
    local passport = SeoulScriptsServer.Passport(source)
    if not passport then return end
    if not nearAnyGym(source) then
        SeoulScriptsServer.Notify(source,'negado','Você está longe do aparelho de academia.',5000)
        return
    end

    local current = SeoulScriptsServer.GetWeight(passport)
    if current >= (AcademyConfig.maxWeight or 120) then
        SeoulScriptsServer.Notify(source,'negado','Você já possui o peso máximo.',5000)
        return
    end

    local add = tonumber(AcademyConfig.increaseWeight) or 1
    if not SeoulScriptsServer.AddWeight(passport, add) then
        SeoulScriptsServer.Notify(source,'negado','Não foi possível aumentar sua mochila.',5000)
        return
    end

    local newWeight = math.min((current > 0 and current or 0) + add, AcademyConfig.maxWeight or 120)
    if GetResourceState('ox_inventory') == 'started' then
        pcall(function() exports.ox_inventory:SetMaxWeight(source, newWeight * 1000) end)
    end

    SeoulScriptsServer.Notify(source,'sucesso','Parabéns! Seu peso aumentou para '..newWeight..'kg.',5000)
end)
