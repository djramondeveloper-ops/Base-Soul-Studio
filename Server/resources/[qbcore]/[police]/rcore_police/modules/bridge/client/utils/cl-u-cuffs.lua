-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if Config.Cuffing.PreCuff and Config.Cuffing.PreCuff.Enable then
        TriggerEvent("rcore_police:registerCuffPre", "officer", function(cb)
            local animDict = "mp_arresting"
            local animName = "arrest_on_floor_front_left_a"
            PlayPartialAnim(animDict, animName, nil, cb)
        end)
        TriggerEvent("rcore_police:registerCuffPre", "citizen", function(cb)
            local animDict = "mp_arresting"
            local animName = "arrest_on_floor_front_left_b"
            PlayPartialAnim(animDict, animName, nil, cb)
        end)
    end
end)
