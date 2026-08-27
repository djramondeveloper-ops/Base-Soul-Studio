-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-dead.lua
--  Engineered by Eazy Fxap
--  Original: 160 lines → Cleaned: 56 lines
-- =====================================================

deathFlag = false

function UtilsService.WasPedDeadRecently(ped)
    return GetPedTimeOfDeath(ped) ~= 0
end

function UtilsService.IsPedDeath(ped)
    local isDead = false
    
    if UtilsService.WasPedDeadRecently(ped) then
        if Config.Framework ~= Framework.QBOX then
            isDead = true
        end
    end
    
    if deathFlag then
        isDead = true
    end
    
    if Config.Flags.SkipDeathCheck then
        dbg.debug("Death: Player skipping check of death since SkipDeathCheck flag in config.lua!")
        isDead = false
    end
    
    return isDead
end

function ProcessDeath(ped)
    dbg.debug("Death")
    TriggerServerEvent("rcore_police:server:sentPlayerDeath")
end

function PlayerAlive(ped)
    dbg.debug("Alive")
    TriggerServerEvent("rcore_police:server:sentPlayerRespawned")
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local isEntityDead = IsEntityDead(ped)
        local isFrameworkDead = Framework.getDeathState()
        local wasDead = UtilsService.WasPedDeadRecently(ped)
        
        if isEntityDead then
            if not deathFlag then
                -- Wait while dead utils are still processing
                while DeadUtils.ShouldProcessDead(ped) do Wait(250) end
                deathFlag = true
                ProcessDeath(ped)
            end
        end
        
        if not isEntityDead and not isFrameworkDead and deathFlag then
            -- Wait for ped to stop moving before clearing death state
            while IsPedStill(ped) and not DeadUtils.ShouldRespawn(ped) do
                Wait(250)
            end
            PlayerAlive(ped)
            deathFlag = false
        end
        
        Wait(500)
    end
end)
