-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL CORRIDAS - CORRIDAS AQUATICAS
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = SeoulCorridas.Tunnel
local Core = SeoulCorridas

local Water = {}
Tunnel.bindInterface("Water",Water)

local payments = Config.waterRace.payments

local function finishRace(playerSource,session)
    if session.paid then return false end
    session.paid = true

    local paymentConfig = payments[session.route]
    if not paymentConfig then
        Core.clearSession(playerSource)
        return false
    end

    local value = math.random(paymentConfig[1],paymentConfig[2])
    local reward = (Config.seoul and Config.seoul.moneyItem) or "dollar"
    local paid = Core.giveItem(session.passport,reward,value,true)

    if paid then
        Core.coinSound(playerSource)
        Core.log("```prolog\n[ID]: "..session.passport.."\n[Ganhou da corrida aquatica]: $"..value..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    else
        Core.notify(playerSource,"negado","Não foi possível entregar a premiação da corrida.",5000)
    end

    Core.clearSession(playerSource)
    return paid
end

function Water.startRace()
    local playerSource = source
    local selected = math.random(#Config.waterRace.races)
    local route = Config.waterRace.races[selected]
    if not route or not route.time then return false end

    local session = Core.beginSession(playerSource,"water",selected,Config.waterRace.startRace,os.time() + tonumber(route.time))
    if not session then return false end

    Core.log("```prolog\n[ID]: "..session.passport.."\n[Iniciou corrida aquatica]: "..selected..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
    return selected
end

function Water.checkpoint()
    local playerSource = source
    local session = Core.session(playerSource,"water")
    if not session then return { ok = false } end

    if session.expiresAt and os.time() > session.expiresAt then
        Core.clearSession(playerSource)
        return { ok = false, expired = true }
    end

    local route = Config.waterRace.races[session.route]
    local point = route and route[session.checkpoint]
    if not point or not Core.validateCheckpoint(playerSource,point,35.0) then
        return { ok = false }
    end

    if session.checkpoint >= #route then
        local paid = finishRace(playerSource,session)
        return { ok = true, finished = true, paid = paid, checkpoint = session.checkpoint }
    end

    session.checkpoint = session.checkpoint + 1
    return { ok = true, finished = false, checkpoint = session.checkpoint }
end

function Water.cancelRace()
    local playerSource = source
    if Core.session(playerSource,"water") then
        Core.clearSession(playerSource)
        return true
    end
    return false
end

-- Compatibilidade antiga: selecionar rota sem criar sessão não libera pagamento.
function Water.raceSelect()
    local session = Core.session(source,"water")
    return session and session.route or false
end

function Water.paymentMethod()
    return Water.checkpoint()
end
