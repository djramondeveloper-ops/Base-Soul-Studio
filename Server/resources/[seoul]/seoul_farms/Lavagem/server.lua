-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL FARMS - LAVAGEM SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
Lavagem = {}
Tunnel.bindInterface("seoul_farms_lavagem",Lavagem)

local lavagemCache = {}

function Lavagem.checkItens(index)
    local source = source
    local Passport = SeoulFarms.Passport(source)
    if not Passport then return false end

    local Config = Farms.lavagem[index]
    if not Config then return false end

    if not SeoulFarms.HasPermission(source,Config.perm) then
        SeoulFarms.Notify(source,"negado","Sem permissão.",4000)
        return false
    end

    for item,quantity in pairs(Config.requirements or {}) do
        if SeoulFarms.ItemAmount(source,Passport,item) < quantity then
            SeoulFarms.Notify(source,"negado","Você não possui "..quantity.."x "..SeoulFarms.ItemName(item)..".",5000)
            return false
        end
    end

    local DirtyItem = Farms.DirtyMoneyItem or "dirtydollar"
    local DirtyAmount = SeoulFarms.ItemAmount(source,Passport,DirtyItem)
    local Min = parseInt(Config.dinheiro_sujo.min_money or 1)
    local Max = parseInt(Config.dinheiro_sujo.max_money or DirtyAmount)

    if DirtyAmount < Min then
        SeoulFarms.Notify(source,"negado","Você precisa de no mínimo "..Min.." de dinheiro sujo.",4000)
        return false
    end

    local AmountToWash = math.min(DirtyAmount,Max)
    lavagemCache[Passport] = { index = index, amount = AmountToWash }

    for item,quantity in pairs(Config.requirements or {}) do
        SeoulFarms.TakeItem(source,Passport,item,quantity,true)
    end

    return true
end

function Lavagem.checkPayment(index)
    local source = source
    local Passport = SeoulFarms.Passport(source)
    if not Passport then return false end

    local Config = Farms.lavagem[index]
    local Cache = lavagemCache[Passport]
    if not Config or not Cache or Cache.index ~= index then return false end

    local DirtyItem = Farms.DirtyMoneyItem or "dirtydollar"
    local CleanItem = Farms.CleanMoneyItem or "dollar"
    local DirtyAmount = math.min(Cache.amount,SeoulFarms.ItemAmount(source,Passport,DirtyItem))
    if DirtyAmount <= 0 then return false end

    if SeoulFarms.TakeItem(source,Passport,DirtyItem,DirtyAmount,true) then
        local Payment = parseInt(DirtyAmount * (Config.dinheiro_sujo.porcentagem or 90) / 100)
        SeoulFarms.GiveItem(source,Passport,CleanItem,Payment,true)
        lavagemCache[Passport] = nil
        return true
    end

    return false
end
