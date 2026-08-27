-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CORRIDAS - CORRIDA EXPLOSIVA
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = SeoulCorridas.Tunnel
local Core = SeoulCorridas
local vRPclient = SeoulCorridas.vRPclient

local Explode = {}
Tunnel.bindInterface("Street",Explode)
local ClientExplode = Tunnel.getInterface("Street")

local totalRaces = #Config.streetRace.races
local currentRace = math.random(totalRaces)

local function streetPayment(route)
    local config = Config.streetRace.races[route]
    if config and config.payment then
        return math.random(config.payment.min,config.payment.max)
    end
    return math.random(Config.streetRace.payment.min,Config.streetRace.payment.max)
end

local function finishRace(playerSource,session)
    if session.paid then return false end
    session.paid = true

    Core.setWanted(session.passport,300)

    local payment = streetPayment(session.route)
    local reward = (Config.seoul and Config.seoul.dirtyMoneyItem) or "dirtydollar"
    local paid = Core.giveItem(session.passport,reward,payment,true)

    if paid then
        Core.coinSound(playerSource)
        Core.log("```prolog\n[ID]: "..session.passport.."\n[Ganhou da corrida explosiva]: $"..payment..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    else
        Core.notify(playerSource,"negado","Não foi possível entregar a premiação da corrida.",5000)
    end

    Core.clearSession(playerSource)
    return paid
end

function Explode.startRace()
    local playerSource = source
    local start = Config.streetRace.startRace
    if Core.distanceFrom(playerSource,start) > 18.0 then return false end

    local timer = tonumber(Config.streetRace.timers[currentRace]) or 0
    if timer <= 0 then return false end

    local session = Core.beginSession(playerSource,"street",currentRace,start,os.time() + timer)
    if not session then return false end

    for _,police in ipairs(Core.policeSources()) do
        TriggerClientEvent("Notify",police,"importante","Recebemos um relato de um corredor ilegal.",5000)
    end

    Core.log("```prolog\n[ID]: "..session.passport.."\n[Iniciou a corrida explosiva]: "..currentRace..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    return currentRace
end

function Explode.checkpoint()
    local playerSource = source
    local session = Core.session(playerSource,"street")
    if not session then return { ok = false } end

    if session.expiresAt and os.time() > session.expiresAt then
        Core.clearSession(playerSource)
        return { ok = false, expired = true }
    end

    local route = Config.streetRace.races[session.route]
    local point = route and route[session.checkpoint]
    if not point or not Core.validateCheckpoint(playerSource,point,18.0) then
        return { ok = false }
    end

    if session.checkpoint >= #route then
        local paid = finishRace(playerSource,session)
        return { ok = true, finished = true, paid = paid, checkpoint = session.checkpoint }
    end

    session.checkpoint = session.checkpoint + 1
    return { ok = true, finished = false, checkpoint = session.checkpoint }
end

function Explode.cancelRace()
    local playerSource = source
    if Core.session(playerSource,"street") then
        Core.clearSession(playerSource)
        return true
    end
    return false
end

-- Compatibilidade antiga sem pagamento client-authoritative.
function Explode.paymentMethod()
    return Explode.checkpoint()
end

function Explode.checkTicket()
    local playerSource = source
    local passport = Core.passport(playerSource)
    if not passport or Core.isWanted(passport) then return false end
    return Core.distanceFrom(playerSource,Config.streetRace.startRace) <= 18.0
end

CreateThread(function()
    while true do
        Wait(5 * 60000)
        currentRace = math.random(totalRaces)
    end
end)

RegisterCommand("defusar",function(playerSource)
    local passport = Core.passport(playerSource)
    local permission = (Config.seoul and Config.seoul.policePermission) or "policia.permissao"
    if not passport or not Core.hasPermission(passport,permission) then return end

    local nplayer = vRPclient.nearestPlayer(playerSource,10)
    if nplayer and Core.session(nplayer,"street") then
        Core.clearSession(nplayer)
        ClientExplode.defuseRace(nplayer)
        Core.notify(playerSource,"sucesso","Dispositivo da corrida desativado.",5000)
    end
end)

-- Alias do evento antigo: agora apenas cancela a sessão ativa, sem liberar prêmio.
RegisterServerEvent("vrp_streetrace:explosivePlayers")
AddEventHandler("vrp_streetrace:explosivePlayers",function()
    local playerSource = source
    if Core.session(playerSource,"street") then
        Core.clearSession(playerSource)
    end
end)
