-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-zipties.lua
--  Engineered by Eazy Fxap
--  Original: 57 lines → Cleaned: 23 lines
-- =====================================================

function HasPlayerZiptieCutters(source)
    local useableRemoveItems = Config.Zipties.UseableRemoveItems
    
    if type(useableRemoveItems) == "table" then
        for _, itemName in ipairs(useableRemoveItems) do
            if InventoryService.hasItem(source, itemName, 1) then
                return true, itemName
            end
        end
    else
        if InventoryService.hasItem(source, Items.ZipTiesCutter, 1) then
            return true, Items.ZipTiesCutter
        end
    end
    
    return false, nil
end
