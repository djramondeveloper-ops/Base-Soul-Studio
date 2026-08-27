-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL FARMS - VENDA DE DROGAS SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
Server = {}
Tunnel.bindInterface("seoul_farms_products",Server)

local amount = {}
local callName = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio","Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local callName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }

function Server.checkAmount()
    local source = source
    local Passport = SeoulFarms.Passport(source)
    if not Passport then return false end

    if not SeoulFarms.HasPermission(source,"gangs") then
        SeoulFarms.Notify(source,"negado","Somente gangs podem vender esses produtos.",5000)
        return false
    end

    for _,v in pairs(Farms.itemList or {}) do
        local rand = math.random(v.randMin,v.randMax)
        local price = math.random(v.priceMin,v.priceMax)
        if SeoulFarms.ItemAmount(source,Passport,v.item) >= parseInt(rand) then
            amount[Passport] = { v.item,rand,price }
            SendPoliceAlert(source)
            return true
        end
    end

    return false
end

function Server.paymentMethod()
    local source = source
    local Passport = SeoulFarms.Passport(source)
    if not Passport or not amount[Passport] then return false end

    local Data = amount[Passport]
    if SeoulFarms.TakeItem(source,Passport,Data[1],Data[2],true) then
        SeoulFarms.AddStress(Passport,2)
        local value = parseInt(Data[3] * Data[2] * 1.5)
        SeoulFarms.GiveItem(source,Passport,Farms.DirtyMoneyItem or "dirtydollar",value,true)
        TriggerClientEvent("vrp_sound:source",source,"coin",0.5)
        amount[Passport] = nil
        return true
    end

    return false
end

function Server.sendNotify(x,y,z)
    local source = source
    TriggerClientEvent("NotifyPush",source,{ time = os.date("%H:%M:%S - %d/%m/%Y"), text = "Olá, gostaria de comprar um produto.", code = 20, title = "Contato", x = x, y = y, z = z, name = callName[math.random(#callName)].." "..callName2[math.random(#callName2)], rgba = {69,115,41} })
end

function SendPoliceAlert(source)
    if math.random(100) <= (Farms.SalePoliceChance or 30) then
        local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(source)))
        for _,player in pairs(SeoulFarms.PlayersByPermission("police")) do
            TriggerClientEvent("NotifyPush",player,{ time = os.date("%H:%M:%S - %d/%m/%Y"), text = "Denúncia de venda de drogas.", code = 20, title = "Denúncia", x = x, y = y, z = z, rgba = {41,76,119} })
        end
    end
end
