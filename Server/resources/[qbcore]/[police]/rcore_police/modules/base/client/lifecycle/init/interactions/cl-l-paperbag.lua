-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/interactions/cl-l-paperbag.lua
--  Engineered by Eazy Fxap
--  Original: 51 lines → Cleaned: 18 lines
-- =====================================================

CreateThread(function()
    while true do
        Wait(0)
        if Interactions.PaperBag.state then
            if HasStreamedTextureDictLoaded("prop_ld_paper_bag") then
                DrawSprite("prop_ld_paper_bag", "prop_paper_bag_2", 0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
            end
        else
            Wait(1000)
        end
    end
end)
