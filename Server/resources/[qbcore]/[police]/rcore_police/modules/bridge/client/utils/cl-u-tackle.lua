-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



Utils.Tackle = Utils.Tackle or {}
Utils.Tackle.HookList = {}
function Utils.Tackle.RegisterHook(name, callback, priority)
    if type(name) ~= "string" then
        error("Invalid hook registration: name must be string and callback must be function")
    end
    table.insert(Utils.Tackle.HookList, {
        name = name,
        fn = callback,
        priority = priority or 0
    })
    table.sort(Utils.Tackle.HookList, function(a, b)
        return a.priority > b.priority
    end)
end
AddEventHandler("rcore_police:tackle:registerHook", function(name, callback, priority)
    Utils.Tackle.RegisterHook(name, callback, priority)
end)
function Utils.Tackle.IsPlayerStateValid(ctx)
    if IsPropSessionActive then return false, 'Tackle: Prop session active!' end
    if IsPedCuffed(ctx.playerPed) then return false, 'Tackle: Initiator cuffed!' end
    if Interactions.MegaPhone and Interactions.MegaPhone.state then return false, 'Tackle: You have megaphone' end
    if InteractionService and InteractionService.isEscorted and InteractionService.isEscorted(MyServerId) then
        return false, 'Tackle: Being escorted A'
    end
    local initiatorInVehicle = GetVehiclePedIsIn(ctx.playerPed, false)
    if DoesEntityExist(initiatorInVehicle) then
        return false, 'Tackle: You cant tackle from vehicle'
    end
    local initiatorDead = Player(MyServerId).state.rcorePoliceDead
    if initiatorDead then
        return false, "Tackle: You can tackle while being dead"
    end
    return true
end
function Utils.Tackle.IsTargetStateValid(ctx)
    if IsPedCuffed(ctx.targetPed) then 
        return false, 'Tackle: Target cuffed!' 
    end
    if InteractionService and InteractionService.isEscorted and InteractionService.isEscorted(ctx.closestPlayer) then
        return false, 'Tackle: Target being escorted B'
    end
    if Config.Handsup and Config.Handsup.Enable and GetHandsUPState and GetHandsUPState(ctx.closestPlayer) then
        return false, 'Tackle: Player has hands in air'
    end
    if IsTargetUsingMegaphone and IsTargetUsingMegaphone(ctx.targetPed) then
        return false, 'Tackle: Target has megaphone'
    end
    local entity = GetVehiclePedIsIn(ctx.targetPed, false)
    if DoesEntityExist(entity) then
        return false, 'Tackle: Target is in vehicle!'
    end
    local targetDead = ctx.closestPlayer and Player(ctx.closestPlayer).state.rcorePoliceDead
    if targetDead then
        return false, "Tackle: Target is dead!"
    end
    return true
end
function Utils.Tackle.IsAnimationValid(ctx)
    if IsEntityPlayingAnim(ctx.targetPed, TACKLE_ANIM_DICT_GROUND_DICT, TACKLE_ANIM_DICT_GROUND_NAME, 3) then
        return false, 'Tackle: Target in tackle anim A'
    end
    if IsEntityPlayingAnim(ctx.targetPed, TACKLE_ANIM_DICT, TACKLE_ANIM_NAME, 3) then
        return false, 'Tackle: Target in tackle anim B'
    end
    return true
end
function Utils.Tackle.IsDistanceValid(ctx)
    local playerCoords = GetEntityCoords(ctx.playerPed)
    local targetCoords = GetEntityCoords(ctx.targetPed)
    ctx.distance = #(targetCoords - playerCoords)
    if ctx.distance >= Config.Tackle.Distance then
        return false, 'Tackle: Far away from target'
    end
    if not UtilsService.IsTargetInFrontOfPed(ctx.playerPed, targetCoords) then
        return false, 'Tackle: Target not in front'
    end
    return true
end
function Utils.TackleRestrictions(ctx, done)
    local function fail(reason)
        dbg.debug(reason)
        done(false, reason)
    end
    local checks = {
        Utils.Tackle.IsPlayerStateValid,
        Utils.Tackle.IsTargetStateValid,
        Utils.Tackle.IsAnimationValid,
        Utils.Tackle.IsDistanceValid
    }
    for _, check in ipairs(checks) do
        local ok, reason = check(ctx)
        if not ok then return fail(reason) end
    end
    local hooks = Utils.Tackle.HookList
    if not hooks or #hooks == 0 then
        return done(true)
    end
    local i = 1
    local function runNextHook()
        local hook = hooks[i]
        if not hook then
            return done(true)
        end
        i = i + 1
        hook.fn(ctx, function(ok, reason)
            if not ok then
                return fail(reason or ("Tackle blocked by hook: " .. (hook.name or "Unknown")))
            end
            runNextHook()
        end)
    end
    runNextHook()
end
