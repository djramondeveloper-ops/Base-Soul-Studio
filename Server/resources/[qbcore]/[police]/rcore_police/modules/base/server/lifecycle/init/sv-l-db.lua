-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-db.lua
--  Engineered by Eazy Fxap
--  Original: 34 lines → Cleaned: 13 lines
-- =====================================================

CreateThread(function()
    if not MySQL then return end
    
    TABLES = MySQL.Sync.fetchAll(" SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() ", {})
    
    db.InitDatabase()
    
    TriggerEvent("rcore_police:server:databaseReady")
end)
