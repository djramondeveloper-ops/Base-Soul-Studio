local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_creator")
func = {}
Tunnel.bindInterface("nation_creator", func)
vHUD = Tunnel.getInterface("hud")
REQUEST = Tunnel.getInterface("request")
vCLIENT = Tunnel.getInterface("nation_creator")
multiCharacter = true

---------------------------------------------------------------------------
-----------------------VERIFICAÇÃO DE PERMISSÃO--------------------------
---------------------------------------------------------------------------

if multiCharacter then
    vRP.Prepare("nation_creator/update_user_first_spawn","UPDATE characters SET Lastname = @firstname, Name = @name, age = @age, Sex = @sex WHERE id = @user_id")
    vRP.Prepare("nation_creator/create_characters","INSERT INTO characters(License,Name,Lastname,Blood) VALUES(@steam,@name,@Lastname,@blood)")
    vRP.Prepare("nation_creator/remove_characters","UPDATE characters SET Deleted = 1 WHERE id = @id")
    vRP.Prepare("nation_creator/get_characters","SELECT * FROM characters WHERE License = @steam and Deleted = 0")
    vRP.Prepare("nation_creator/get_character","SELECT * FROM characters WHERE License = @steam and Deleted = 0 and id = @user_id")
    vRP.Prepare("nation_creator/get_bank","SELECT * FROM characters WHERE id = @user_id")
    CreateThread(function()
        while GetResourceState("oxmysql") ~= "started" do
            Wait(500)
        end

        exports.oxmysql:query_async("ALTER TABLE characters ADD COLUMN IF NOT EXISTS age INT(11) NOT NULL DEFAULT 20")
        exports.oxmysql:query_async("ALTER TABLE characters ADD COLUMN IF NOT EXISTS Sex VARCHAR(1) NOT NULL DEFAULT 'M'")
    end)
else
    vRP.Prepare("nation_creator/update_user_first_spawn","UPDATE vrp_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")
end


function func.checkPermission(permission, src)
    local source = src or source
    local user_id = vRP.Passport(source)
    if type(permission) == "table" then
        for i, perm in pairs(permission) do
            if vRP.HasPermission(user_id, perm) or vRP.HasGroup(user_id, perm) then
                return true
            end
        end
        return false
    end
    
    return not permission or vRP.HasPermission(user_id, permission) or vRP.HasGroup(user_id, permission)
end


function func.saveChar(name, lastName, age, char, id)
    local source = source

    local user_id = vRP.Passport(source) or id

    if user_id then
        if string.find(tostring(name or ""), "<") or string.find(tostring(lastName or ""), "<") or string.find(tostring(age or ""), "<") then          
            DropPlayer(source, "Foi de ralo")
            return true
        end

        if char then
            vRP.Query("playerdata/SetData", {
                Passport = user_id,
                Name = "nation_char",
                Information = json.encode(char, { indent = false })
            })
        end

        local sex = "M"
        if name and lastName and age then
            local model = GetEntityModel(GetPlayerPed(source))
            if model == GetHashKey("mp_f_freemode_01") then
                sex = "F"
            else
                sex = "M"
            end
            vRP.Query("nation_creator/update_user_first_spawn", {
                user_id = user_id,
                firstname = lastName,
                name = name,
                age = age,
                sex = sex
            })
        end
        if name and lastName then
            vRP.UpgradeNames(user_id, name, lastName)
        end
        TriggerClientEvent("nation_barbershop:init", source, char)
        local skin = sex == "F" and "mp_f_freemode_01" or "mp_m_freemode_01"

        vRP.SkinCharacter(user_id, skin)
        return true
    end
end


function getUserChar(user_id, source, nation)
    local char
    local data = vRP.UserData(user_id, "nation_char")
    if data and data.hair then
        char = data
        char.gender = getGender(user_id) or char.gender
    end
    
    return char
end

function func.SavePlayer()
    local source = source
    if source ~= 0 then
        vRP.Kick(source,"Atualizando Personagem !!!")
    end
end

local userlogin = {}
function playerSpawn(user_id, source, first_spawn)
    if first_spawn then
        Wait(1000)
        processSpawnController(source,getUserChar(user_id, source),user_id)
    end
end

function processSpawnController(source,char,user_id)
    getUserLastPosition(source, user_id)
    local source = source
    if char then
        if not userlogin[user_id] then
            userlogin[user_id] = true
            fclient._spawnPlayer(source,false)
        else
            fclient._spawnPlayer(source,true)
        end
        fclient.setPlayerChar(source, char, true)
        TriggerClientEvent("nation_barbershop:init", source, char)
        setPlayerTattoos(source, user_id)
        fclient._setClothing(source, getUserClothes(user_id))
    else
        userlogin[user_id] = true
        local data = vRP.UserData(user_id, "Barbershop")
        if data then 
            local gender = getGender(user_id)
            fclient._spawnPlayer(source,false)
            fclient._setOldChar(source, data, getUserClothes(user_id), gender, user_id)
        else
            fclient._startCreator(source)
        end
    end
end




function setPlayerTattoos(source, user_id)
    TriggerClientEvent("tattoos:Apply", source, getUserTattoos(user_id))
    TriggerClientEvent("forcereloadtattos", source)
    TriggerEvent('dpn_tattoo:setPedServer', source)
    TriggerClientEvent("nyoModule:tattooUpdate", source, false)
end


function func.setPlayerTattoos(id)
    local source = source
    local user_id = id or vRP.Passport(source)
    if user_id then
        setPlayerTattoos(source, user_id)
    end
end

function getUserLastPosition(source, user_id)
    local coords = {402.76,-996.28,-99.00}
    local datatable = vRP.Datatable(user_id)
    if datatable and datatable.Pos then
        local p = datatable.Pos
        coords = { p.x, p.y, p.z }
    else
        local data = vRP.UserData(user_id, "Datatable")
        if data and data.Pos then
            local p = data.Pos
            coords = { p.x, p.y, p.z }
        end
    end
    fclient._setPlayerLastCoords(source, coords)
    return coords
end


function func.getUserLastPosition()
    local source = source
    local user_id = vRP.Passport(source)
    getUserLastPosition(source, user_id)
end


function format(n)
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end


function func.changeSession(session)
    local source = source
    SetPlayerRoutingBucket(source, session)
end

function func.updateLogin()
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then
        userlogin[user_id] = true
        local char = getUserChar(user_id, source)
        if char then 
            TriggerClientEvent("nation_barbershop:init", source, char)
            setPlayerTattoos(source, user_id)
        end
    end
end



function func.getCharsInfo()
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.Query("nation_creator/get_characters", { steam = steam })
    local info = { chars = {} }

    for k, v in ipairs(data) do
        local char = getUserChar(v.id, source) or {}
        local clothes = getUserClothes(v.id)
        local gender = "masculino"

        if v.Sex and v.Sex == "F" then
            gender = "feminino"
        elseif v.Sex and v.Sex == "M" then
            gender = "masculino"
        else
            gender = "outros"
        end

        local bankData = vRP.Query("nation_creator/get_bank", { user_id = v.id })
        local bank = 0
        if bankData and bankData[1] then
            bank = bankData[1].Bank or 0
        end
        local formattedBank = string.format("%.2f", bank)
        info.chars[k] = {
            name = v.Name .. " " .. v.Lastname,
            age = tostring(v.age or 20) .. " anos",
            bank = "$ " .. formattedBank,
            clothes = clothes,
            registration = Sanguine(v.Blood),
            phone = getLbPhoneNumber(v.id),
            user_id = v.id,
            id = "#" .. v.id,
            gender = gender,
            char = char
        }
    end

    info.maxChars = getUserMaxChars(source)
    return info
end

function getUserMaxChars(source)
    local steam = getPlayerSteam(source)
    local Account = vRP.Account(steam) or {}
    return math.max(parseInt(Account["Characters"] or 1), 1)
end

function getLbPhoneNumber(user_id)
    if GetResourceState("lb-phone") ~= "started" then
        return "Sem telefone"
    end

    local ok, number = pcall(function()
        return exports["lb-phone"]:GetEquippedPhoneNumber("vrp:" .. tostring(user_id))
    end)

    if ok and number and number ~= "" then
        return tostring(number)
    end

    return "Sem telefone"
end

function getUserClothes(user_id)
    local data = vRP.UserData(user_id, "Clothings")
    -- print("data", json.encode(data))
    if data then
        return data
    end
    return {}
end

function getUserTattoos(user_id)
    local data = vRP.UserData(user_id,"Tatuagens")
    if data then
        local custom = data
        return custom or {}
    end
    data = vRP.UserData(user_id,"Tattoos")
    if data then
        local custom = data  
        return custom or {}
    end
    data = vRP.UserData(user_id,"Tattooshop")
    if data then
        return data
    end
    return {}
end

function isEmpty(t)
    if type(t) == "string" and t ~= "" then
        return false
    end
    for k,v in ipairs(t) do
        if v then
            return false
        end
    end
    return true
end

function getGender(user_id)
    local datatable = vRP.Datatable(user_id) or vRP.UserData(user_id, "Datatable") or {}
    -- if type(datatable) == "table" then
    local model = datatable.Skin or datatable.gender
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
    -- end
end

function func.getOverlay()
    local source = source
    local user_id = vRP.Passport(source)
    if user_id then
        local char = getUserChar(user_id, source, true)
        if char and char.overlay then
            return char.overlay
        end
    end
    return 0
end




function func.playChar(info)
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.Query("nation_creator/get_character",{ steam = steam, user_id = info.user_id })
    if #data > 0 then
        -- TriggerEvent("baseModule:idLoaded",source,info.user_id,nil)
        vRP.CharacterChosen(source,info.user_id,nil)
        local user_id = vRP.Passport(source)
        local ip = GetPlayerEP(source) or '0.0.0.0'
        --FAZER LOGO DISCORD (TALVEZ NAO PRECISE POR JA TER UM FEITO)
        playerSpawn(info.user_id, source, true)
    end
end


function func.tryDeleteChar(info)
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.Query("nation_creator/get_character",{ steam = steam, user_id = info.user_id })
    return false, "Não permitido"
end

function func.tryCreateChar()
    local source = source
    local steam = getPlayerSteam(source)
    local data = vRP.Query("nation_creator/get_characters",{ steam = steam })
    if #data < getUserMaxChars(source)  then -- limite de personagens
        vRP.Query("nation_creator/create_characters",{ steam = steam, name = "Individuo", Lastname = "Indigente", blood = math.random(4) })
        local myChars = vRP.Query("nation_creator/get_characters",{ steam = steam })
        local user_id = myChars[#myChars].id
        if user_id  then
            local Model = "mp_m_freemode_01"
            vRP.CharacterChosen(source,user_id,Model)
            return true
        end
    end
end


function getPlayerSteam(source)
    --[[ local identifiers = GetPlayerIdentifiers(source)
    for k,v in ipairs(identifiers) do
        if string.sub(v,1,5) == "steam" then
            return splitString(v,":")[2]
        end
    end ]]
    return vRP.Identities(source)
end


--[[RegisterCommand("char", function(source) -- setar as customizações dnv (tipo bvida)
local user_id = vRP.Passport(source)
local char = getUserChar(user_id, source)
if char then
    fclient._setPlayerChar(source, char, true)
    TriggerClientEvent("nation_barbershop:init", source, char)
    setPlayerTattoos(source, user_id)
    fclient._setClothing(source, getUserClothes(user_id))
end
end)]]


local SecondaryPerm = { "Dono", "Admin" }

local function resetCharacter(Passport)
    vRP.Query("playerdata/SetData", {
        Passport = parseInt(Passport),
        Name = "nation_char",
        Information = json.encode({})
    })
end


local function hasAnyGroup(Passport, groups)
    for _, group in ipairs(groups) do
        if vRP.HasGroup(Passport, group) then
            return true
        end
    end
    return false
end

RegisterCommand('resetchar',function(source, args) -- COMANDO DE ADMIN PARA RESETAR PERSONAGEM
    local Passport = vRP.Passport(source)
    if hasAnyGroup(Passport,SecondaryPerm) then
        if args[1] then 
            local id = tonumber(args[1])
            if id then
                local src = vRP.Source(id)
                if src and vRP.Request(source, "Nation","Deseja resetar o id "..id.." ?", "Esta ação não pode ser desfeita.") then
                    fclient._startCreator(src)
                    resetCharacter(id)
                end
            end
        else
            if vRP.Request(source, "Nation", "Deseja resetar seu personagem ?","Esta ação não pode ser desfeita.") then
                fclient._startCreator(source)
                resetCharacter(Passport)
            end
        end
    end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REesetandoplayer
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("nation:ResetChar")
AddEventHandler("nation:ResetChar",function(source,user_id,check)
    if check == "Lolozinho" then
        if vRP.Request(source, "Nation", "Deseja resetar seu personagem ?", "Esta ação não pode ser desfeita.") then
            fclient._startCreator(source)
            resetCharacter(user_id)
        end
    end
end)

-- RegisterCommand('spawn',function(source)
--     local Passport = vRP.Passport(source)
--     if vRP.HasGroup(Passport,"Admin", 1) then
--         if multiCharacter then
--             -- vRP.playerDropped(source,"Trocando Personagem.")
--             Wait(1000)
--             TriggerClientEvent("spawn:setupChars", source)
--         else
--             playerSpawn(vRP.Passport(source), source, true)
--         end
--     end
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REesetandoplayer
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("nation:resetplayer")
AddEventHandler("nation:resetplayer",function(source,user_id)
    if source ~= nil then
        fclient._startCreator(source)
    end
end)
