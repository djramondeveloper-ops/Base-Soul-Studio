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

-- Will create a local object
--- @param hash string/integer
--- @param pos vector3
function CreateLocalObject(hash, pos)
    local model = tonumber(hash) or GetHashKey(hash)
    if not IsModelInCdimage(model) or not IsModelValid(model) then
        print(string.format("[rcore_fuel] [ERROR] Invalid object model: %s", tostring(hash)))
        return 0
    end
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 300 do
        Wait(16)
        timeout = timeout + 1
    end
    if not HasModelLoaded(model) then
        print(string.format("[rcore_fuel] [ERROR] Timed out loading object model: %s", tostring(hash)))
        return 0
    end

    local entity = CreateObject(model, pos.x, pos.y, pos.z, false, false, false)
    SetEntityCoordsNoOffset(entity, pos.x, pos.y, pos.z)
    SetModelAsNoLongerNeeded(model)
    return entity
end

-- Will create a networked object
--- @param hash string/integer
--- @param pos vector3
function CreateNetworkedObject(hash, pos)
    local model = tonumber(hash) or GetHashKey(hash)
    if not IsModelInCdimage(model) or not IsModelValid(model) then
        print(string.format("[rcore_fuel] [ERROR] Invalid object model: %s", tostring(hash)))
        return 0
    end
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 300 do
        Wait(16)
        timeout = timeout + 1
    end
    if not HasModelLoaded(model) then
        print(string.format("[rcore_fuel] [ERROR] Timed out loading object model: %s", tostring(hash)))
        return 0
    end

    local entity = CreateObject(model, pos.x, pos.y, pos.z, true, false, false)
    SetEntityCoordsNoOffset(entity, pos.x, pos.y, pos.z)
    SetModelAsNoLongerNeeded(model)
    return entity
end

