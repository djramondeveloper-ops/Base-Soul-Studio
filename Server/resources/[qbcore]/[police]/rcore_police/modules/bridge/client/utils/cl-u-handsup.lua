-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



Utils.Handsup = Utils.Handsup or {}
Utils.Handsup.Exit = function(plyPed)
    if not plyPed then
        return
    end
    if IsPedBeingStunned(plyPed, 0) then
        return
    end
    if deathFlag then
        return
    end
    ClearPedTasksImmediately(plyPed)
end
