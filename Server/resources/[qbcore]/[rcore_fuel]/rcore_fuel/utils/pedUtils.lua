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

-- Will create a local ped
--- @param hash string/integer
--- @param pos vector3
function CreateLocalPed(hash, pos)
    local model = tonumber(hash) or GetHashKey(hash)
    if not IsModelInCdimage(model) or not IsModelValid(model) then
        print(string.format("[rcore_fuel] [ERROR] Invalid ped model: %s", tostring(hash)))
        return 0
    end
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 300 do
        Wait(16)
        timeout = timeout + 1
    end
    if not HasModelLoaded(model) then
        print(string.format("[rcore_fuel] [ERROR] Timed out loading ped model: %s", tostring(hash)))
        return 0
    end
    local obj = CreatePed(4, model, pos.x, pos.y, pos.z, 0, false, true)
    SetModelAsNoLongerNeeded(model)
    return obj
end

-- Will create a networked ped
--- @param hash string/integer
--- @param pos vector3
function CreateNetworkedPed(hash, pos)
    local model = tonumber(hash) or GetHashKey(hash)
    if not IsModelInCdimage(model) or not IsModelValid(model) then
        print(string.format("[rcore_fuel] [ERROR] Invalid ped model: %s", tostring(hash)))
        return 0
    end
    RequestModel(model)
    local timeout = 0
    while not HasModelLoaded(model) and timeout < 300 do
        Wait(16)
        timeout = timeout + 1
    end
    if not HasModelLoaded(model) then
        print(string.format("[rcore_fuel] [ERROR] Timed out loading ped model: %s", tostring(hash)))
        return 0
    end
    local obj = CreatePed(4, model, pos.x, pos.y, pos.z, 0, true, false)
    SetModelAsNoLongerNeeded(model)
    return obj
end

