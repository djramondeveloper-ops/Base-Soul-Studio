-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL FARMS - DROGAS SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
Drugs = {}
Tunnel.bindInterface("seoul_farms_drogas",Drugs)

function Drugs.checkPermission(Permission)
    local source = source
    if SeoulFarms.HasPermission(source,Permission) then
        return true
    end

    SeoulFarms.Notify(source,"negado","Você não possui permissão para fazer isso.",5000)
    return false
end

function Drugs.checkPayment(loc,id,farm)
    local source = source
    local Passport = SeoulFarms.Passport(source)
    if not Passport then return false end

    local Farm = Farms[farm] and Farms[farm][loc]
    local Step = Farm and Farm.itens and Farm.itens[id]
    if not Step then
        SeoulFarms.Notify(source,"negado","Farm inválida.",5000)
        return false
    end

    local RewardItem = Step.item
    local RewardAmount = parseInt(Step.itemqtd or 1)

    if not SeoulFarms.CanCarry(source,Passport,RewardItem,RewardAmount) then
        SeoulFarms.Notify(source,"negado","Você não possui espaço suficiente.",5000)
        return false
    end

    if Step.re then
        local NeedItem = Step.re
        local NeedAmount = parseInt(Step.reqtd or 1)
        if SeoulFarms.ItemAmount(source,Passport,NeedItem) < NeedAmount then
            SeoulFarms.Notify(source,"negado","Você não possui "..NeedAmount.."x "..SeoulFarms.ItemName(NeedItem)..".",5000)
            return false
        end

        if not SeoulFarms.TakeItem(source,Passport,NeedItem,NeedAmount,true) then
            SeoulFarms.Notify(source,"negado","Não foi possível remover os itens necessários.",5000)
            return false
        end
    end

    SeoulFarms.GiveItem(source,Passport,RewardItem,RewardAmount,true)
    return true
end
