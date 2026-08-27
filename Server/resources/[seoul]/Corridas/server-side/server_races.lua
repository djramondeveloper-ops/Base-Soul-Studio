-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CORRIDAS - CORRIDAS BASICAS
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = SeoulCorridas.Tunnel
local Core = SeoulCorridas

local Races = {}
Tunnel.bindInterface("Races",Races)

local runners = Config.races.runners

local function racePayment(route)
    local config = runners[route]
    if config and config.payment then
        return math.random(config.payment.min,config.payment.max)
    end
    return math.random(Config.races.payment.min,Config.races.payment.max)
end

local function finishRace(playerSource,session)
    if session.paid then return false end
    session.paid = true

    local payment = racePayment(session.route)
    local reward = (Config.seoul and Config.seoul.dirtyMoneyItem) or "dirtydollar"
    local paid = Core.giveItem(session.passport,reward,payment,true)

    if paid then
        Core.log("```prolog\n[ID]: "..session.passport.."\n[Ganhou da corrida normal]: $"..payment..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    else
        Core.notify(playerSource,"negado","Não foi possível entregar a premiação da corrida.",5000)
    end

    Core.clearSession(playerSource)
    return paid
end

function Races.startRace(selected)
    local playerSource = source
    selected = tonumber(selected)
    local config = selected and runners[selected]
    if not config or not config.init or not config.coords or not config.laps then return false end

    if Core.distanceFrom(playerSource,config.init) > 8.0 then return false end
    local session = Core.beginSession(playerSource,"basic",selected,config.init,nil)
    if not session then return false end

    Core.notify(playerSource,"importante","A policia foi acionada, corra!",5000)

    for _,police in ipairs(Core.policeSources()) do
        TriggerClientEvent("NotifyPush",police,{
            time = os.date("%H:%M:%S - %d/%m/%Y"),
            text = "Estou vendo um bando de incompetente planejando uma corrida por aqui!",
            code = 10,
            title = "Corrida em andamento",
            x = config.init[1],
            y = config.init[2],
            z = config.init[3],
            rgba = {95,158,160}
        })
    end

    Core.log("```prolog\n[ID]: "..session.passport.."\n[Iniciou corrida] "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    return true
end

function Races.checkpoint()
    local playerSource = source
    local session = Core.session(playerSource,"basic")
    if not session then return { ok = false } end

    local config = runners[session.route]
    local point = config and config.coords and config.coords[session.checkpoint]
    if not point or not Core.validateCheckpoint(playerSource,point,18.0) then
        return { ok = false }
    end

    if session.checkpoint >= #config.coords then
        if session.lap >= config.laps then
            local paid = finishRace(playerSource,session)
            return { ok = true, finished = true, paid = paid, checkpoint = session.checkpoint, lap = session.lap }
        end

        session.lap = session.lap + 1
        session.checkpoint = 1
    else
        session.checkpoint = session.checkpoint + 1
    end

    return { ok = true, finished = false, checkpoint = session.checkpoint, lap = session.lap }
end

function Races.cancelRace()
    local playerSource = source
    if Core.session(playerSource,"basic") then
        Core.clearSession(playerSource)
        return true
    end
    return false
end

-- Compatibilidade segura com chamadas antigas: não paga sem validar o checkpoint final real.
function Races.finishRaces()
    return Races.checkpoint()
end

function Races.startRaces()
    return false
end

function Races.callPolice()
    return false
end
