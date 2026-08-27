if Config.Framework ~= "standalone" then
    return
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP BRIDGE: Vehicles / Garage Integration
-----------------------------------------------------------------------------------------------------------------------------------------
local vRP = {}
local vRPReady = false

CreateThread(function()
    local utils = LoadResourceFile("vrp", "lib/Utils.lua")
    if not utils then return end

    load(utils)()

    local Proxy = module("vrp", "lib/Proxy")
    if not Proxy then return end

    vRP = Proxy.getInterface("vRP")
    vRPReady = true
end)

local function WaitForVRP()
    while not vRPReady do
        Wait(100)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- HELPER: Query Segura (Evita erro de attempt to get length of a number value)
-----------------------------------------------------------------------------------------------------------------------------------------
local function SafeQuery(name, params)
    local result = vRP.Query(name, params or {})
    if type(result) ~= "table" then
        return {}
    end
    return result
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET PLAYER VEHICLES (lista de veículos reais da tabela vehicles)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@return VehicleData[] vehicles
function GetPlayerVehicles(source)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then
        return {}
    end

    local result = SafeQuery("lbphone/UserVehicles", { Passport = Passport })
    local vehicles = {}

    for _, v in pairs(result) do
        local vehicleName = tostring(v.Vehicle or "")
        local plate = tostring(v.Plate or "")

        if vehicleName ~= "" and plate ~= "" then
            local engine = tonumber(v.Engine) or 1000.0
            local body = tonumber(v.Body) or 1000.0
            local fuel = tonumber(v.Fuel) or 100.0
            local arrest = tonumber(v.Arrest) or 0

            vehicles[#vehicles + 1] = {
                plate = plate,
                type = "car", -- Padrão seguro, natives de verificação de modelo não existem no server
                model = joaat(vehicleName),
                vehicle = vehicleName,
                location = arrest == 1 and "Impound" or "Garage",
                impounded = arrest == 1,
                statistics = {
                    engine = engine,
                    body = body,
                    fuel = fuel
                }
            }
        end
    end

    return vehicles
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET VEHICLE (dados de um veículo específico por placa)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param source number
---@param plate string
---@return table? vehicleData
function GetVehicle(source, plate)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport or not plate then
        return nil
    end

    local result = SafeQuery("lbphone/GetVehicle", {
        Passport = Passport,
        Plate = plate
    })

    local v = result[1]
    if not v then
        return nil
    end

    local arrest = tonumber(v.Arrest) or 0
    -- Bloquear spawn de veículo apreendido
    if arrest == 1 then
        return nil
    end

    local vehicleName = tostring(v.Vehicle or "")
    if vehicleName == "" then
        return nil
    end

    return {
        plate = tostring(v.Plate or plate),
        type = "car", -- Padrão seguro
        model = joaat(vehicleName),
        vehicle = vehicleName,
        location = "Garage",
        impounded = false,
        statistics = {
            engine = tonumber(v.Engine) or 1000.0,
            body = tonumber(v.Body) or 1000.0,
            fuel = tonumber(v.Fuel) or 100.0
        }
    }
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- IS VEHICLE OWNED
-----------------------------------------------------------------------------------------------------------------------------------------
function IsVehicleOwned(source, plate)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport or not plate then
        return false
    end

    local result = SafeQuery("lbphone/GetVehicle", {
        Passport = Passport,
        Plate = plate
    })

    return result[1] ~= nil
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GRANT VEHICLE KEY (Seoul native vehiclekey item)
-----------------------------------------------------------------------------------------------------------------------------------------
function GrantVehicleKey(source, plate)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    plate = tostring(plate or ""):gsub("^%s+", ""):gsub("%s+$", "")

    if not Passport or plate == "" then return false end

    if vRP.PassportHasVehicleKey(Passport, plate) then
        return true
    end

    vRP.GenerateItem(Passport, "vehiclekey-" .. plate, 1, true)
    return vRP.PassportHasVehicleKey(Passport, plate)
end
