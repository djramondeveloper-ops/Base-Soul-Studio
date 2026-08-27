-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL FARMS - DESMANCHE SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
Desmanche = {}
Tunnel.bindInterface("seoul_farms_desmanche", Desmanche)

local iniciado = {}

function Desmanche.CheckPerm(index)
    local source = source
    local Config = Farms.desmanche[index]
    if not Config then return false end

    if Config.RestritoParaDesmanche then
        if SeoulFarms.HasPermission(source,Config.PermissaoDesmanche or "mechanic") and not iniciado[index] then
            iniciado[index] = true
            return true
        end
        return false
    end

    if iniciado[index] then return false end
    iniciado[index] = true
    return true
end

function Desmanche.backIniciado(index)
    iniciado[index] = false
end

function Desmanche.CheckItem(index)
    local source = source
    local Passport = SeoulFarms.Passport(source)
    local Config = Farms.desmanche[index]
    if not Passport or not Config then return false end

    if Config.PrecisaDeItem then
        local Item = Config.ItemNecessario
        local Amount = parseInt(Config.QtdNecessaria or 1)
        if SeoulFarms.ItemAmount(source,Passport,Item) >= Amount then
            return SeoulFarms.TakeItem(source,Passport,Item,Amount,true)
        end
        return false
    end

    return true
end

function Desmanche.GerarPagamento(placa,nomeFeio,nomeBonito,index)
    local source = source
    local Passport = SeoulFarms.Passport(source)
    local Config = Farms.desmanche[index]
    if not Passport or not Config then return false end

    local Identity = SeoulFarms.Identity(Passport)
    local Owner = SeoulFarms.VehicleOwnerByPlate(placa)
    local VehicleName = nomeBonito or SeoulFarms.VehicleName(nomeFeio)

    if Owner and Owner ~= Passport then
        local Pagamento = parseInt((SeoulFarms.VehiclePrice(nomeFeio) or 100000) * (Farms.DesmancheMoneyMultiplier or 0.50))
        SeoulFarms.GiveItem(source,Passport,Farms.DirtyMoneyItem or "dirtydollar",Pagamento,true)

        for Item,Amount in pairs(Config.Payment or {}) do
            SeoulFarms.GiveItem(source,Passport,Item,Amount,true)
        end

        iniciado[index] = false

        if Farms.DesmancheFineEnabled then
            local Multa = parseInt(Pagamento / 2)
            SeoulFarms.AddFine(Owner,Multa,"Seguro do veículo "..tostring(VehicleName),source)
            local Target = SeoulFarms.Source(Owner)
            if Target then
                SeoulFarms.Notify(Target,"aviso","Você recebeu uma cobrança de seguro do veículo <b>"..tostring(VehicleName).."</b> no valor de <b>R$"..SeoulFarms.Format(Multa).."</b>.",7000)
            end
        end

        TriggerClientEvent("vrp_sound:source",source,"coin",0.3)
        SeoulFarms.Notify(source,"payment","Você recebeu <b>R$"..SeoulFarms.Format(Pagamento).."</b> pelo desmanche de <b>"..tostring(VehicleName).."</b>.",7000)
        return true
    elseif not Owner then
        for Item,Amount in pairs(Config.Payment or {}) do
            SeoulFarms.GiveItem(source,Passport,Item,Amount,true)
        end

        iniciado[index] = false
        SeoulFarms.Notify(source,"payment","Você recebeu materiais pelo desmanche de <b>"..tostring(VehicleName).."</b>.",7000)
        return true
    end

    iniciado[index] = false
    SeoulFarms.Notify(source,"negado","Você não pode desmanchar seu próprio veículo.",6000)
    return false
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL FARMS - DELETE VEHICLE AFTER CHOPSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("seoul_farms:deleteVehicle",function(netId,index)
    local source = source
    netId = tonumber(netId) or 0
    index = tonumber(index) or index

    if netId <= 0 then return end

    local allowed = false

    if index and iniciado[index] then
        allowed = true
    end

    if not allowed and SeoulFarms.HasPermission(source,"mechanic") then
        allowed = true
    end

    if not allowed then return end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end
    if GetEntityType(entity) ~= 2 then return end

    local ped = GetPlayerPed(source)
    if ped and ped ~= 0 and DoesEntityExist(ped) then
        local pCoords = GetEntityCoords(ped)
        local vCoords = GetEntityCoords(entity)
        if #(pCoords - vCoords) > 80.0 then return end
    end

    DeleteEntity(entity)
end)
