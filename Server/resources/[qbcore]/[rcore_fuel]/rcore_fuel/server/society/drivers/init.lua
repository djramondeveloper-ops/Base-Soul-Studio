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

-- server/society/drivers/init.lua
-- Tracks NPC tanker driver assignments per mission so the server knows
-- which driver belongs to which player session.

local ActiveDrivers = {}  -- [src] = { missionId, npcNetId, shopId }

--- Register a driver assignment when a player starts a tanker mission.
---@param src      number  player server id
---@param missionId string
---@param shopId   string
function RegisterDriver(src, missionId, shopId)
    local identifier = Framework and Framework.GetPlayerIdentifier and Framework.GetPlayerIdentifier(src) or nil
    if not identifier then return false end

    ActiveDrivers[src] = {
        missionId  = missionId,
        shopId     = shopId,
        identifier = identifier,
        startedAt  = os.time()
    }
    return true
end

--- Remove the driver assignment when the mission ends or the player disconnects.
---@param src number
function UnregisterDriver(src)
    ActiveDrivers[src] = nil
end

--- Returns the active driver entry for a player, or nil.
---@param src number
---@return table|nil
function GetActiveDriver(src)
    local entry = ActiveDrivers[src]
    if not entry then return nil end

    -- FiveM source IDs are transient and can be reused after disconnect. Never let a
    -- delayed mission callback for the old occupant inherit the new player's source.
    if entry.identifier and Framework and Framework.GetPlayerIdentifier then
        local currentIdentifier = Framework.GetPlayerIdentifier(src)
        if currentIdentifier ~= entry.identifier then
            ActiveDrivers[src] = nil
            return nil
        end
    end

    return entry
end

-- Clean up on disconnect
AddEventHandler("playerDropped", function()
    UnregisterDriver(source)
end)
