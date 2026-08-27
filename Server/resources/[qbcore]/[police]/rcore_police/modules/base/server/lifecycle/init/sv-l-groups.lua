-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-groups.lua
--  Engineered by Eazy Fxap
--  Original: 26 lines → Cleaned: 11 lines
-- =====================================================

CreateThread(function()
    local storage = Object.getStorage(STORAGE_GROUPS)
    if not storage then return end
    
    storage.registerGroups()
end)
