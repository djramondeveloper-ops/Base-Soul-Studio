-----------------------------------------------------------------------------------------------------------------------------------------
-- SEOUL SCRIPTS ITEMS - PROXY PARA ADMINCONTROL
-----------------------------------------------------------------------------------------------------------------------------------------
local function proxyImport(source,force)
    if GetResourceState("AdminControl") ~= "started" then
        if source and source > 0 then TriggerClientEvent("Notify",source,"Erro","AdminControl não iniciado.",7000) end
        return
    end
    TriggerEvent("AdminControl:SeoulSeedImporter:Import","scripts",force == true,source or 0)
end

local function proxyStatus(source)
    if GetResourceState("AdminControl") ~= "started" then
        if source and source > 0 then TriggerClientEvent("Notify",source,"Erro","AdminControl não iniciado.",7000) end
        return
    end
    TriggerEvent("AdminControl:SeoulSeedImporter:Status","scripts",source or 0)
end

RegisterCommand("seoulscriptsitems",function(source,args)
    proxyImport(source,args and tostring(args[1] or ""):lower() == "force")
end,false)

RegisterCommand("seoulscriptsitemsstatus",function(source)
    proxyStatus(source)
end,false)
