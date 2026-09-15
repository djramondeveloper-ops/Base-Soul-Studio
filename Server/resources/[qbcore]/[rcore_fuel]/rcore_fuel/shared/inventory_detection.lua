--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

-- Inventory auto-detection must be deterministic. Lua's pairs() traversal order is
-- undefined, so servers that have more than one inventory resource running (common
-- during migrations/bridges) could select a different backend between restarts.
local detectionOrder = {
    Inventory.OX,
    Inventory.CORE,
    Inventory.QS,
    Inventory.JAKSAM,
    Inventory.CODEM,
    Inventory.TGIANN,
    Inventory.ORIGEN,
    Inventory.PS,
    Inventory.LJ,
    Inventory.MF,
}

function ResolveInventorySystem()
    if Config.InventorySystem ~= Inventory.AUTOMATIC and Config.InventorySystem ~= nil then
        return Config.InventorySystem
    end

    for _, keyConst in ipairs(detectionOrder) do
        local resourceName = InventoryResourceNames[keyConst]
        if resourceName and (GetResourceState(resourceName) == "started" or (keyConst == Inventory.OX and GetResourceState("ox_inventory") == "started")) then
            Config.InventorySystem = keyConst
            return Config.InventorySystem
        end
    end

    if GetResourceState("qb-inventory") == "started" then
        Config.InventorySystem = Inventory.QB
        return Config.InventorySystem
    end

    if GetResourceState("es_extended") == "started" then
        Config.InventorySystem = Inventory.ESX
        return Config.InventorySystem
    end

    -- Default fallback if nothing detected yet but ox_inventory exists
    if GetResourceState("ox_inventory") ~= "missing" then
        Config.InventorySystem = Inventory.OX
        return Config.InventorySystem
    end

    return Config.InventorySystem
end

ResolveInventorySystem()
