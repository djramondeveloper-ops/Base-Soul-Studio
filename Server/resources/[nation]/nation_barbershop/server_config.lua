local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_barbershop")
func = {}
Tunnel.bindInterface("nation_barbershop", func)


function func.checkPermission(permission, src)
    local source = src or source
    local Passport = vRP.Passport(source)
    if type(permission) == "table" then
        for i, perm in pairs(permission) do
            if vRP.HasPermission(Passport, perm) then
                return true
            end
        end
        return false
    end
    return vRP.HasPermission(Passport, permission)
end

-- {"skinFirst":21,"bodyBlemishes-color":0,"ageing-color":0,"chinHole":0.0,"skinThird":0,"shapeFirst":21,"chestHair":-1,"cheeksWidth":0.0,"neckThickness":0.0,"blemishes-opacity":1.0,"chinBoneLength":0.0,"bodyBlemishes":-1,"addBodyBlemishes-color":0,"lipstick-opacity":1.0,"eyes":0,"facialHair":-1,"eyebrows-opacity":1.0,"nosePeakHeight":0.0,"hair":3,"addBodyBlemishes-opacity":1.0,"sunDamage":-1,"blemishes":-1,"chestHair-color":0,"bodyBlemishes-opacity":1.0,"chestHair-opacity":1.0,"blush":-1,"complexion":-1,"chinBoneWidth":0.0,"freckles-color":0,"lipstick-color":0,"complexion-color":0,"facialHair-color":0,"makeup-opacity":1.0,"cheeksBoneWidth":0.0,"chinBoneLowering":0.0,"sunDamage-opacity":1.0,"addBodyBlemishes":-1,"eyeBrownForward":0.0,"blush-opacity":1.0,"blemishes-color":0,"nosePeakLength":0.0,"ageing":-1,"sunDamage-color":0,"lipsThickness":0.0,"skinSecond":0,"cheeksBoneHigh":0.0,"noseBoneHigh":0.0,"eyesOpenning":0.0,"nosePeakLowering":0.0,"jawBoneWidth":0.0,"gender":"male","thirdMix":0.0,"blush-color":0,"shapeSecond":0,"eyeBrownHigh":0.0,"noseBoneTwist":0.0,"facialHair-opacity":1.0,"makeup-color":-1,"skinMix":0.80000001192092,"eyebrows":-1,"hair-color":0,"noseWidth":-0.7,"freckles-opacity":1.0,"shapeThird":0,"makeup":-1,"eyebrows-color":0,"overlay":0,"hair-highlightcolor":0,"lipstick":-1,"freckles":-1,"complexion-opacity":1.0,"ageing-opacity":1.0,"shapeMix":0.80000001192092,"jawBoneBackLength":0.0}
function func.saveChar(char)
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        if char.gender == "" then 
            char.gender = GetEntityModel(GetPlayerPed(source))
        end
        -- vRP._setUData(Passport, "nation_char", json.encode(char,{indent=false}))
        vRP.Query("playerdata/SetData",{ Passport = parseInt(Passport), Name = "nation_char", Information = json.encode(char,{indent=false}) })
        return true
    end
end

-- function func.saveChar(t)
--     local source = source
--     local Passport = vRP.Passport(source)
--     if Passport then
--         local char = getUserChar(Passport)
--         char.tattoos, char.overlay = t.tattoos, t.overlay
--         vRP.Query("playerdata/SetData",{ Passport = parseInt(Passport), Name = "nation_char", Information = json.encode(char,{indent=false}) })
--        -- vRP._setUData(Passport, "nation_char", json.encode(char,{indent=false}))
--     end
-- end


function func.tryPay(value)
    local source = source
    local Passport = vRP.Passport(source)
    if value >= 0 then
        if vRP.PaymentFull(Passport, value) or vRP.PaymentBank(Passport, value) or value == 0 then
            return true
        end
    end
    return false
end



local chairsUsers = {}
function func.checkChair(barberId, chairIndex, perm)
    local source = source
    local model = GetEntityModel(GetPlayerPed(source))
    local canEnter = model == GetHashKey("mp_m_freemode_01") or model == GetHashKey("mp_f_freemode_01")
    if (perm and not func.checkPermission(perm, source)) or not canEnter then return end
    for src, v in pairs(chairsUsers) do
        if v.barberId == barberId and v.chairIndex == chairIndex then
            return false
        end
    end
    chairsUsers[source] = { barberId = barberId, chairIndex = chairIndex  }
    return true
end

function func.leaveChar(_source)
    local source = _source or source
    if chairsUsers[source] then
        chairsUsers[source] = nil
    end
end


AddEventHandler('playerDropped', function()
    func.leaveChar(source)
end)


function func.getOverlay()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        local char = vRP.UserData(Passport, "nation_char")
        if char and char.overlay then
            return char.overlay
        end
    end
    return 0
end

function getUserClothes(Passport)
    local data = vRP.UserData(Passport, "Clothings")
    if data and data ~= "" then
        local clothes = data
        if clothes then
            return clothes
        end
    end
    local datatable = vRP.Datatable(Passport) or {}
    return datatable.customization or {}
end


function setPlayerTattoos(source, Passport)
    local char = vRP.UserData(Passport, "nation_char") or {}
    TriggerClientEvent("reloadtattos", source, {
        tattoos = char.tattoos or {},
        overlay = char.overlay or 0
    })
    TriggerClientEvent("reloadtattos", source)
    TriggerEvent('dpn_tattoo:setPedServer',source)
    TriggerClientEvent("nyoModule:tattooUpdate",source, false)
end

function func.setPlayerTattoos()
    local source = source
    local Passport = vRP.Passport(source)
    if Passport then
        setPlayerTattoos(source, Passport)
    end
end

function getGender(Passport)
    local datatable = vRP.Datatable(Passport) or vRP.UserData(Passport, "Datatable") or {}
    if type(datatable) == "table" then
        local model = datatable.Skin or datatable.customization
        if model then
            if type(model) == "table" then
                model = model.modelhash or model.model
            end
            if model == GetHashKey("mp_m_freemode_01") or model == "mp_m_freemode_01" then
                return "male"
            elseif model == GetHashKey("mp_f_freemode_01") or model == "mp_f_freemode_01" then
                return "female"
            else
                return model
            end
        end
    end
end



RegisterServerEvent("barbershop:Debug")
AddEventHandler("barbershop:Debug", function()
    local source = source
    desbugar(source)
end)

function playerSpawn(Passport, source, first_spawn)
    Wait(1000)
    local char = vRP.UserData(Passport, "nation_char")
    if char and next(char) then
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, Passport)
    end
end

function func.getSavedChar()
    local Passport = vRP.Passport(source)
    if not Passport then return {}, {} end
    return vRP.UserData(Passport, "nation_char") or {}, vRP.UserData(Passport, "Barbershop") or {}
end



function desbugar(source)
    local Passport = vRP.Passport(source)
    local data = vRP.UserData(Passport, "nation_char")

    if data and type(data) == "table" then
        local char = data
        char.gender = getGender(Passport) or char.gender
        fclient._setPlayerChar(source, char, false, true)
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, Passport)
        fclient._setClothing(source, getUserClothes(Passport))
    end
end


RegisterCommand("bvida2", function(source)
    local Passport = vRP.Passport(source)
    local data = vRP.UserData(Passport, "nation_char")

    if data and type(data) == "table" then
        local char = data
        char.gender = getGender(Passport) or char.gender
        fclient._setPlayerChar(source, char, false, true)
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, Passport)
        fclient._setClothing(source, getUserClothes(Passport))
    end
end)
