GlobalState["SkinShops"] = {}

AddEventHandler("onServerResourceStart", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        GlobalState:set("SkinShops", GetControlFile("skinshops") or {}, true)
    end
end)

RegisterCommand(Config.Commands["skinshop"]["command"], function(source)
    if AdminControlCanUse(source, Config.Commands["skinshop"].perm) then
        TriggerClientEvent("AdminControl:openSkinShop", source)
    end
end)

function Server.registerSkinShop(SkinShop)
    local source = source
    if not AdminControlCanUse(source, Config.Commands["skinshop"].perm) then return end
    if SkinShop and SkinShop.label and SkinShop.coords then
        local SkinShops = GetControlFile("skinshops") or {}
        local id = #SkinShops + 1
        SkinShops[id] = SkinShop
        GlobalState:set("SkinShops", SkinShops, true)
        SaveControlFile("skinshops", id, SkinShop)
        AdminControlNotify(source,"Sucesso","Loja de roupa registrada com sucesso.",5000)
    end
end

function Server.deleteSkinShop(index)
    local source = source
    if not AdminControlCanUse(source, Config.Commands["skinshop"].perm) then return end
    local SkinShops = GetControlFile("skinshops") or {}
    if SkinShops[index] then
        RemoveControlFile("skinshops", index)
        table.remove(SkinShops, index)
        GlobalState:set("SkinShops", SkinShops, true)
        AdminControlNotify(source,"Sucesso","Loja de roupa removida com sucesso.",5000)
    end
end
