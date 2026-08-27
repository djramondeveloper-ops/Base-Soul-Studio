if Config.Modules and Config.Modules.Admin == false then return end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local GlobalItems = {}

local function ReloadControllerItems()
    if GetResourceState("ox_inventory") == "started" then
        local ok,items = pcall(function() return exports.ox_inventory:Items() end)
        if ok and type(items) == "table" then GlobalItems = items return end
    end
    GlobalItems = {}
end

CreateThread(function() Wait(500); ReloadControllerItems() end)
AddEventHandler("onResourceStart",function(resource)
    if resource == "ox_inventory" then SetTimeout(500,ReloadControllerItems) end
end)
RegisterNetEvent("Seoul:reloadItems",ReloadControllerItems)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
AdmServer = {}
Tunnel.bindInterface("Admin",AdmServer)
AdmClient = Tunnel.getInterface("Admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSIONS
----------------------------------------------------------------------------------------------------------------------------------------
-- Permissões são resolvidas pela bridge Compat/server.lua.
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("kickall",function(source)
 	if HasPermission(source,"kickall") then
 		local users = vRP.getUsers()
		for k,v in pairs(users) do
			local user_id = vRP.getUserId(v)
			vRP.kick(user_id, "Estamos tendo um Terremoto! Voltamos logo")
		end
 	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAY
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("say",function(source,args,rawCommand)
	if HasPermission(source,"say") then
		TriggerClientEvent("Notify",-1,"aviso","Anuncio Prefeitura",rawCommand:sub(4),15000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKIN
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand('skin',function(source,args,rawCommand)
    if HasPermission(source,"skin") then
        local nplayer = vRP.getUserSource(tonumber(args[1]))
        if nplayer then
            local hash = GetHashKey(args[2])
            vRPclient.Skin(nplayer,hash)
            vRP.updateSelectSkin(tonumber(args[1]),hash)
            TriggerClientEvent("Notify",source,"Modelo setado","Voce setou a skin <b>"..args[2].."</b> no passaporte <b>"..parseInt(args[1]).."</b>.",5000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
local function levenshtein(s, t)
    local len_s, len_t = #s, #t
    if len_s == 0 then return len_t end
    if len_t == 0 then return len_s end

    local matrix = {}
    for i = 0, len_s do
        matrix[i] = {}
        matrix[i][0] = i
    end
    for j = 0, len_t do
        matrix[0][j] = j
    end

    for i = 1, len_s do
        local s_i = s:sub(i, i)
        for j = 1, len_t do
            local t_j = t:sub(j, j)
            local cost = (s_i == t_j) and 0 or 1
            matrix[i][j] = math.min(
                matrix[i - 1][j] + 1,
                matrix[i][j - 1] + 1,
                matrix[i - 1][j - 1] + cost
            )
        end
    end
    return matrix[len_s][len_t]
end

local function similarityPercent(s1, s2)
    local lev = levenshtein(s1, s2)
    local maxLen = math.max(#s1, #s2)
    return ((maxLen - lev) / maxLen) * 100
end

local function findClosestItem(input)
    local closestItem = nil
    local lowestDistance = math.huge
    input = input:lower():gsub("%s+", "")
    for key, item in pairs(GlobalItems) do
        local itemName = key:lower():gsub("%s+", "")
        local distance = levenshtein(input, itemName)

        if distance < lowestDistance then
            lowestDistance = distance
            closestItem = key
        end
    end
    return closestItem
end

SeoulRegisterCommand("item",function(source,args,rawCommand)
	if HasPermission(source,"item") then
		if args[1] and args[2] then
			if GlobalItems[args[1]] then
				local user_id = vRP.getUserId(source)
				vRP.giveInventoryItem(user_id,args[1],tonumber(args[2]) or 1, nil, true)
				vRP.createWeebHook(Webhooks.webhookgive,"```prolog\n[ID]: "..user_id.."\n[PEGOU]: "..args[1].." \n[QUANTIDADE]: "..parseInt(args[2]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			else
				local closestItem = findClosestItem(args[1])
				local similarPercent = similarityPercent(args[1], closestItem)
				if closestItem and similarPercent >= 75 then
					if vRP.request(source,"Você quer pegar o item "..closestItem.."?",30) then
						local user_id = vRP.getUserId(source)
						vRP.giveInventoryItem(user_id,closestItem,tonumber(args[2]) or 1, nil, true)
						vRP.createWeebHook(Webhooks.webhookgive,"```prolog\n[ID]: "..user_id.."\n[PEGOU]: "..closestItem.." \n[QUANTIDADE]: "..parseInt(args[2]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					end
				else
					TriggerClientEvent("Notify",source,"negado","Item inexistente",5000)
				end
			end
		else
			local itemData = AdmClient.showItemlist(source)
			if itemData and GlobalItems[itemData[1]] then
				local user_id = vRP.getUserId(source)
				vRP.giveInventoryItem(user_id,itemData[1],tonumber(itemData[2]) or 1, nil, true)
				vRP.createWeebHook(Webhooks.webhookgive,"```prolog\n[ID]: "..user_id.."\n[PEGOU]: "..itemData[1].." \n[QUANTIDADE]: "..parseInt(itemData[2]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMALL
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("itemall",function(source,args,rawCommand)
	if HasPermission(source,"itemall") and args[1] and args[2] then
		if GlobalItems[args[1]] then
			local users = vRP.getUsers()
			for k,v in pairs(users) do
				vRP.giveInventoryItem(parseInt(k),tostring(args[1]),tonumber(args[2]) or 1,nil,true)
			end
		else
			TriggerClientEvent("Notify",source,"negado","Item inexistente",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEBUG
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("debug",function(source,args,rawCommand)
	if HasPermission(source,"debug") then
		TriggerClientEvent("Controller:ToggleDebug",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDCAR
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("addcar",function(source,args,rawCommand)
	if HasPermission(source,"addcar") then
		local user_id = vRP.getUserId(source)
		if parseInt(args[1]) > 0 and args[2] then
			vRP.addUserVehicle(parseInt(args[1]), args[2])
			local nplayer = vRP.getUserSource(tonumber(args[1]))
			if nplayer then
				TriggerClientEvent("Notify",nplayer,"importante","Voce recebeu <b>"..args[2].."</b> em sua garagem.",5000)
			end
			TriggerClientEvent("Notify",source,"importante","Adicionou o veiculo: <b>"..args[2].."</b> no ID:<b>"..args[1].."</b.",5000)
			vRP.createWeebHook(Webhooks.webhookaddcar,"```prolog\n[ID]: "..user_id.."\n[ADICIONOU NO ID:]: "..args[1].." \n[CARRO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		else
			TriggerClientEvent("Notify",source,"aviso","Utilize /addcar (id) (veiculo)",5000)
		end
	end
end)

-- `/addtempcar (id) (veiculo) (dias)`
-- Exemplo: /addtempcar 1 audir8 30
SeoulRegisterCommand("addtempcar",function(source,args,rawCommand)
	print('ok')
	if HasPermission(source,"addtempcar") then
		local user_id = vRP.getUserId(source)
		if tonumber(args[1]) and args[2] and args[3] and tonumber(args[3]) > 0 then
			local nplayer = vRP.getUserSource(tonumber(args[1]))
			if nplayer then
				TriggerClientEvent("Notify",nplayer,"importante","Voce recebeu <b>"..args[2].."</b> em sua garagem por "..args[3].." dias",5000)
			end
			if not SeoulAddTempVehicle(parseInt(args[1]),args[2],parseInt(args[3])) then
				TriggerClientEvent("Notify",source,"negado","Veículo inválido ou não cadastrado na Seoul.",5000)
				return
			end
			TriggerClientEvent("Notify",source,"importante","Adicionou o veiculo: <b>"..args[2].."</b> no ID:<b>"..args[1].."</b. por "..args[3].." dias",5000)
			vRP.createWeebHook(Webhooks.webhookaddcar,"```prolog\n[ID]: "..user_id.."\n[ADICIONOU NO ID:]: "..args[1].." \n[CARRO]: "..args[2].." \n[DIAS]: "..args[3]..""..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		else
			TriggerClientEvent("Notify",source,"importante","Utilize /addtempcar (id) (veiculo) (dias)",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMCAR
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("remcar",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,"admin.permissao") and args[1] and args[2] then
			if tonumber(args[1]) and tonumber(args[1]) > 0 then
				if SeoulRemoveVehicle(parseInt(args[1]),args[2]) then
					local nplayer = vRP.getUserSource(args[1])
					if nplayer then
						TriggerClientEvent("Notify",nplayer,"importante","Veiculo <b>"..args[2].."</b> retirado da sua garagem.",5000)
					end
					TriggerClientEvent("Notify",source,"importante","Removido o veiculo: <b>"..args[2].."</b> no ID:<b>"..args[1].."</b.",5000)
					vRP.createWeebHook(Webhooks.webhookaddcar,"```prolog\n[ID]: "..user_id.."\n[REMOVEU DO ID]: "..args[1].." \n[VEICULO]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				else
					TriggerClientEvent("Notify",source,"negado","Cidadão não possui este veiculo",5000)
				end
			else
				TriggerClientEvent("Notify",source,"negado","Utilize /remcar (id) (veiculo)",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAPUZ
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("capuz",function(source,args,rawCommand)
	if HasPermission(source,"capuz") then
		TriggerClientEvent("vrp_hud:toggleHood",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NC
-----------------------------------------------------------------------------------------------------------------------------------------
function AdmServer.enablaNoclip()
	local source = source
	if HasPermission(source,"noclip") then
		Player(source).state:set("noClip",not Player(source).state.noClip,true)
		vRPclient.noClip(source)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUCKETS
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("mundo",function(source,args)
	if args[1] and HasPermission(source,"gobucket") then
		SetPlayerRoutingBucket(source,parseInt(args[1]))
	end
end)

SeoulRegisterCommand("meumundo",function(source,args)
	local bucket = GetPlayerRoutingBucket(source)
	TriggerClientEvent("Notify",source,"aviso","Você esta no mundo "..bucket,5000)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("kick",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"kick") and parseInt(args[1]) > 0 then
			if vRP.getUserSource(parseInt(args[1])) then
				vRP.kick(parseInt(args[1]),"Você foi expulso da cidade.")
				vRP.createWeebHook(Webhooks.webhookkick,"```prolog\n[ID]: "..user_id.."\n[KICKOU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			else
				TriggerClientEvent("Notify",source,"negado","Cidadão não esta na cidade",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BAN
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("ban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"ban") and parseInt(args[1]) > 0 then
			local identity = vRP.getUserIdentity(parseInt(args[1]))
			if identity then
				vRP.kick(parseInt(args[1]), "Você foi banido do nosso servidor")
				-- Ban oficial da Seoul é mantido no resource admin; comando legado fica desativado por padrão.
				TriggerClientEvent("Notify",source,"importante","Você baniu "..args[1]..".",5000)
				vRP.createWeebHook(Webhooks.webhookban,"```prolog\n[ID]: "..user_id.." \n[BANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WL
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("wl",function(source,args,rawCommand)
	if source == 0 then
		vRP.setWhitelist(args[1], 1)
		print('Id '..args[1]..' com whitelist liberado.')
		return
	end
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"wl") then
			vRP.setWhitelist(args[1], 1)
			TriggerClientEvent("Notify",source,"importante","Você Aprovou "..args[1]..".",5000)
			vRP.createWeebHook(Webhooks.webhookadminwl,"```prolog\n[ID]: "..user_id.."\n[APROVOU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNWL
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("unwl",function(source,args,rawCommand)
	if source == 0 then
		vRP.setWhitelist(args[1], 0)
		print('Id '..args[1]..' com whitelist bloqueada.')
		return
	end
	if HasPermission(source,"unwl") and parseInt(args[1]) > 0 then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(parseInt(args[1]))
		if identity then
			vRP.setWhitelist(args[1], 0)
			TriggerClientEvent("Notify",source,"importante","Você retirou a "..args[1]..".",5000)
			vRP.createWeebHook(Webhooks.webhookunwl,"```prolog\n[ID]: "..user_id.."\n[RETIROU WL]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GEMS
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("coins",function(source,args,rawCommand)
	if HasPermission(source,"coins") and parseInt(args[1]) > 0 and parseInt(args[2]) > 0 then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(parseInt(args[1]))
		if identity then
			vRP.addGmsId(parseInt(args[1]),parseInt(args[2]))
			TriggerClientEvent("Notify",source,"importante","Coins entregues para "..identity.name.." #"..args[1]..".",5000)
			vRP.createWeebHook(Webhooks.webhookgems,"```prolog\n[ID]: "..user_id.."\n[PLAYER]: "..args[1].."\n[Coins]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MONEY
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("money",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"money") and parseInt(args[1]) > 0 then
			vRP.giveInventoryItem(user_id,"dollars",parseInt(args[1]),nil,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNBAN
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("unban",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"unban") and parseInt(args[1]) > 0 then
			local identity = vRP.getInformation(parseInt(args[1]))
			if identity and identity[1] then
				-- Unban oficial da Seoul é mantido no resource admin; comando legado fica desativado por padrão.
				TriggerClientEvent("Notify",source,"importante","Você desbaniu "..args[1]..".",5000)
				vRP.createWeebHook(Webhooks.webhookunban,"```prolog\n[ID]: "..user_id.." \n[DESBANIU]: "..args[1].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPCDS
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("tpcds",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"tpcds") then
			local fcoords = vRP.prompt(source,"Coordenadas:","")
			if fcoords == "" then
				return
			end

			local coords = {}
			for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
				table.insert(coords,parseInt(coord))
			end
			vRPclient.teleport(source,coords[1] or 0,coords[2] or 0,coords[3] or 0)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("cds",function(source,args,rawCommand)
	if HasPermission(source,"cds") then
		local x,y,z = vRPclient.getPositions(source)
		vRP.prompt(source,"Coordenadas:",x..","..y..","..z)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CDS
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("cds2",function(source,args,rawCommand)
	if HasPermission(source,"cds2") then
		local x,y,z,h = vRPclient.getPositions(source)
		vRP.prompt(source,"Coordenadas com rotação:",x..","..y..","..z..","..h)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("group",function(source,args,rawCommand)
	if source == 0 and args[1] and args[2] then
		vRP.addUserGroup(parseInt(args[1]),tostring(args[2]),tonumber(args[3]))
		print("O cidadão foi setado como " ..vRP.getGroupTitle(args[2],tonumber(args[3])))
		return
	end
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"group") then
			if args[1] and parseInt(args[1]) > 0 then
				if args[2] then
					if args[2] == "Owner" and not vRP.hasPermission(user_id,"Owner") then
						return
					end
					local kgroup = vRP.getGroup(tostring(args[2]))
					if kgroup == nil then
						TriggerClientEvent("Notify",source,"negado","Este grupo não existe. Use /rg2 "..parseInt(args[1]).." para consultar os grupos do cidadão.",5000)
						return
					end
					vRP.addUserGroup(parseInt(args[1]),tostring(args[2]),tonumber(args[3]))
					TriggerClientEvent("Notify",source,"sucesso","O cidadão foi setado como " ..vRP.getGroupTitle(args[2],tonumber(args[3])).." ",5000)
					vRP.createWeebHook(Webhooks.webhookset,"```prolog\n[ID]: "..user_id.." \n[SETOU]: "..args[1].." \n [GROUP]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				else
					TriggerClientEvent("Notify",source,"aviso","Informe o grupo desejado ou use /rg2 "..parseInt(args[1]).." para consultar os grupos do cidadão.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("rg2",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id and args[1] and parseInt(args[1]) > 0 then
		if HasPermission(source,"rg2") then
			local sets = ""
			local userGroups = vRP.getUserGroups(parseInt(args[1]))
			for group,level in pairs(userGroups) do
				local groupData = vRP.getGroup(group)
				local groupType = groupData and groupData["Type"] or "None"
				sets = sets..'- '..group.." "..level.." ("..(groupType)..")".."<br>"
			end
			TriggerClientEvent("Notify",source,"SETS ID ("..args[1]..")",sets,7000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UNGROUP
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("ungroup",function(source,args,rawCommand)
	if source == 0 and args[1] and args[2] then
		vRP.removeUserGroup(parseInt(args[1]),tostring(args[2]))
		print("O cidadão foi retirado de " ..args[2])
		return
	end
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"ungroup") then
			if vRP.hasPermission(parseInt(args[1]),tostring(args[2])) then
				vRP.removeUserGroup(parseInt(args[1]),tostring(args[2]))
				TriggerClientEvent("Notify",source,"sucesso","O cidadão foi retirado de " ..(args[2])..".",5000)
				vRP.createWeebHook(Webhooks.webhookunset,"```prolog\n[ID]: "..user_id.." \n[TIROU SET DE]: "..args[1].." \n [GROUP]: "..args[2].." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTOME
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("tptome",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"tptome") and parseInt(args[1]) > 0 then
			local nplayer = vRP.getUserSource(parseInt(args[1]))
			if nplayer then
				local AdminBucket = GetPlayerRoutingBucket(source)
				local UserBucket = GetPlayerRoutingBucket(nplayer)
				if UserBucket ~= AdminBucket then
					if vRP.request(source,"Cidadão esta no bucket "..UserBucket..". Deseja puxa-lo para seu bucket?",20) then
						SetPlayerRoutingBucket(nplayer, AdminBucket)
					else
						return
					end
				end
				vRPclient.teleport(nplayer,vRPclient.getPositions(source))
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- Limpar INV
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("limparinv",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if HasPermission(source,"limparinv") then
		local nplayer = tonumber(args[1])
		if nplayer ~= nil then
			vRP.clearInventory(nplayer)
			TriggerClientEvent("Notify",source,"sucesso","Você limpou inventario de " ..nplayer..".",5000)
			vRP.createWeebHook(Webhooks.webhooklimparinv,"```prolog\n[ID]: "..user_id.." \n[LIMPOU INV DE]: "..nplayer..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		else
			vRP.clearInventory(user_id)
			TriggerClientEvent("Notify",source,"sucesso","Você limpou seu inventario",5000)
			vRP.createWeebHook(Webhooks.webhooklimparinv,"```prolog\n[ID]: "..user_id.." /n[LIMPOU PROPRIO INV]" ..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPTO
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("tpto",function(source,args,rawCommand)
	if HasPermission(source,"tpto") and parseInt(args[1]) > 0 then
		local nplayer = vRP.getUserSource(parseInt(args[1]))
		if nplayer then
			local AdminBucket = GetPlayerRoutingBucket(source)
			local UserBucket = GetPlayerRoutingBucket(nplayer)
			if UserBucket ~= AdminBucket then
				if vRP.request(source,"Cidadão esta no bucket "..UserBucket..". Deseja ir?",20) then
					SetPlayerRoutingBucket(source, UserBucket)
				else
					return
				end
			end
			vRPclient.teleport(source,vRPclient.getPositions(nplayer))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TPWAY
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("tpway",function(source,args,rawCommand)
	if HasPermission(source,"tpway") then
		AdmClient.teleportWay(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMBO
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("limbo",function(source,args,rawCommand)
	if vRPclient.getHealth(source) <= 101 then
		AdmClient.teleportLimbo(source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HASH / GETCAR
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("hash",function(source,args,rawCommand)
	if HasPermission(source,"hash") then
		local vehicle = vRPclient.getNearVehicle(source,7)
		if vehicle then
			vRP.prompt(source,"Hash do veiculo:",GetHashKey(vehicle))
		end
	end
end)

SeoulRegisterCommand("getcar",function(source,args,rawCommand)
	if HasPermission(source,"getcar") then
		local vehicle = vRPclient.getNearVehicle(source,7)
		if vehicle then
			local carname = vRP.prompt(source,"Nome de spawn do carro:","")
			local nicename = vRP.prompt(source,"Nome bonito do carro:","")
			local carprice = vRP.prompt(source,"Preço do carro:","")
			local carchest = vRP.prompt(source,"Bau do carro (Padrao 40):","40")
			local cartype = vRP.prompt(source,"Tipo do carro:","carros")
			local hash = GetHashKey(carname)
			vRP.prompt(source,"Resultado:","{ hash = "..hash..", name = '"..carname.."', price = "..carprice..", banido = false, modelo = '"..nicename.."', capacidade = "..carchest..", tipo = '"..cartype.."' },")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELNPCS
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("delnpcs",function(source,args,rawCommand)
	if HasPermission(source,"delnpcs") then
		AdmClient.deleteNpcs(source,tonumber(args[1]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TUNING
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("tuning",function(source,args,rawCommand)
	if HasPermission(source,"tuning") then
		TriggerClientEvent("vehtuning",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIMPAREA
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("limpararea",function(source,args,rawCommand)
	if HasPermission(source,"limpararea") then
		local x,y,z = vRPclient.getPositions(source)
		TriggerClientEvent("syncarea",-1,x,y,z,100)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("players",function(source,args,rawCommand)
	if HasPermission(source,"players") then
		local quantidade = 0
		local users = vRP.getUsers()
		for k,v in pairs(users) do
			quantidade = parseInt(quantidade) + 1
		end
		TriggerClientEvent("Notify",source,"importante","<b>Players Conectados:</b> "..quantidade,5000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("cplayers",function(source,args,rawCommand)
	if source == 0 then
		local quantidade = 0
		local users = vRP.getUsers()
		for k,v in pairs(users) do
			quantidade = parseInt(quantidade) + 1
		end
		print("Players Conectados: "..quantidade)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PON
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand('pon',function(source,args,rawCommand)
	if HasPermission(source,"pon") then
		local users = vRP.getUsers()
		local players = ""
		local quantidade = 0
		for k,v in pairs(users) do
			if k ~= #users then
				players = players..", "
			end
			players = players..k
			quantidade = quantidade + 1
		end
		TriggerClientEvent('chatMessage',source,"TOTAL ONLINE",{1, 136, 0},quantidade)
		TriggerClientEvent('chatMessage',source,"ID's ONLINE",{1, 136, 0},players)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANNOUNCE
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("anuncio",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"anuncio") then
			local message = vRP.prompt(source,"Message:","")
			if message == "" then
				return
			end
			TriggerClientEvent("Notify",-1,"Prefeitura",message,15000)
			vRP.createWeebHook(Webhooks.webhookadmin,"```prolog\n[ID]: "..user_id.." \n[ENVIOU MENSAGEM]: "..message.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEGA IP
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand('pegarip',function(source,args,rawCommand)
    if HasPermission(source,"pegarip") then
		local tplayer = vRP.getUserSource(parseInt(args[1]))
        if tplayer then
        	TriggerClientEvent('chatMessage',source,"^1IP do Usuário: "..GetPlayerEndpoint(tplayer))
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPEC 
----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("spec",function(source,args)
    if HasPermission(source,"spec") then
		local spectar = tonumber(args[1])
        local nplayer = vRP.getUserSource(spectar)
        if nplayer then
            TriggerClientEvent("SpecMode", source,nplayer)
        else
            TriggerClientEvent("Notify", source, "Negado", "Esse player não está online...",4000)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MATAR COM CODIGO
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand('kill',function(source,args,rawCommand)
    if HasPermission(source,"kill") then
        if args[1] then
            local nplayer = vRP.getUserSource(parseInt(args[1]))
            if nplayer then
                vRPclient.killGod(nplayer)
                vRPclient.setHealth(nplayer,0)
            end
        else
            vRPclient.killGod(source)
            vRPclient.setHealth(source,0)
            vRPclient.setArmour(source,0)
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDP
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand('id',function(source,args,rawCommand)
    local nplayer = vRPclient.nearestPlayer(source,5)
    if nplayer then
        local nuser_id = vRP.getUserId(nplayer)
        TriggerClientEvent("Notify",source,"importante","Jogador próximo: "..nuser_id..".",4000)
    else
        TriggerClientEvent("Notify",source,"aviso","Nenhum Jogador Próximo",4000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FREEZE
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand('freeze', function(source, args,rawCommand)
    if HasPermission(source,"freeze") and args[1] then
		local nplayer = vRP.getUserSource(parseInt(args[1]))
		if nplayer then
			TriggerClientEvent('Congelar', nplayer)
			TriggerClientEvent("Notify",source,"sucesso","Jogador Congelado!",4000)
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAINEL ADM
-----------------------------------------------------------------------------------------------------------------------------------------
local AdmPrison = {}

SeoulRegisterCommand('prisaoadm', function(source, args,rawCommand)
    if HasPermission(source,"prisaoadm") then
		local data = AdmClient.requestPrison(source)
		if data[1] and data[2] then
			local nplayer = vRP.getUserSource(parseInt(data[1]))
			if nplayer then
				TriggerClientEvent("PrisonMode", nplayer, true)
				if data[3] then
					TriggerClientEvent("Notify", nplayer, "Prisão", "Você foi preso por "..data[2].." minutos. Motivo: "..data[3], 5000)
				else
					TriggerClientEvent("Notify", nplayer, "Prisão", "Você foi preso por "..data[2].." minutos", 5000)
				end
				AdmPrison[nplayer] = parseInt(data[2])
			end
			vRP.setUData(parseInt(data[1]),"prison:Adm",json.encode(data))
		end
    end
end)

CreateThread(function ()
	while true do
		for k,v in pairs(AdmPrison) do
			if v > 0 then
				AdmPrison[k] = v - 1
			else
				TriggerClientEvent("PrisonMode", k, false)
				TriggerClientEvent("Notify", k, "Prisão", "Você está livre da prisão!", 5000)
				local user_id = vRP.getUserId(k)
				if user_id then
					SeoulDeletePlayerData(user_id,"prison:Adm")
				end
				AdmPrison[k] = nil
			end
		end
		Wait(60000)
	end
end)

AddEventHandler("Connect",function (user_id, source)
	local prisonAdm = vRP.getUData(user_id,"prison:Adm")
	if prisonAdm then
		local data = json.decode(prisonAdm)
		if data and parseInt(data[2]) > 0 then
			AdmPrison[source] = parseInt(data[2])
			TriggerClientEvent("PrisonMode", source, true)
		end
	end
end)

AddEventHandler("playerDropped",function (reason)
	local source = source
	local user_id = vRP.getUserId(source)
    if AdmPrison[source] and AdmPrison[source] > 0 then
		local prisonAdm = json.decode(vRP.getUData(user_id,"prison:Adm"))
		prisonAdm[2] = AdmPrison[source]
		vRP.setUData(user_id,"prison:Adm",json.encode(prisonAdm))
        AdmPrison[source] = nil
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DM (MENSAGEM NO PRIVADO)
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand('dm',function(source,args,rawCommand)
    if HasPermission(source,"dm") then
		local nplayer = vRP.getUserSource(parseInt(args[1]))
        if args[1] == nil then
            TriggerClientEvent("Notify",source,"negado","Necessário passar o ID após o comando, exemplo: <b>/dm 1</b>",5000)
            return
        elseif nplayer == nil then
            TriggerClientEvent("Notify",source,"negado","O jogador não está online!",5000)
            return
        end
        local mensagem = vRP.prompt(source,"Digite a mensagem:","")
        if mensagem == "" then
            return
        end
        TriggerClientEvent("Notify",source,"sucesso","Mensagem enviada com sucesso!")
        TriggerClientEvent('chatMessage',nplayer,"PREFEITURA:",{255,20,0},mensagem)
        TriggerClientEvent("Notify",nplayer,"aviso","<b>Mensagem da Administração no chat</b> ",10000)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECAR PESSOAS NO GRUPO
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("checkgroup",function(source,args,rawCommand)
    if HasPermission(source,"checkgroup") and args[1] then
		local kgroup = vRP.getGroup(tostring(args[1]))
		if kgroup == nil then
			TriggerClientEvent("Notify",source,"negado","O grupo não existe",5000)
			return
		end
        local consult = vRP.NumGroups(tostring(args[1])) or {}
		local found = false
		for passport in pairs(consult) do
			local identity = vRP.getUserIdentity(parseInt(passport))
			if identity and identity.name then
				found = true
				TriggerClientEvent("Notify",source,"aviso","ID: "..passport.." "..identity.name.." "..identity.name2,5000)
			end
		end
		if not found then
			TriggerClientEvent("Notify",source,"negado","Ninguém setado nesse grupo",5000)
		end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RG
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("rg",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"rg") then
			local nuser_id = nil
			if parseInt(args[1]) > 0 then
				nuser_id = parseInt(args[1])
			else
				local nplayer = vRPclient.nearestPlayer(source,2)
				if nplayer then
					nuser_id = vRP.getUserId(nplayer)
				end
			end
			if nuser_id then
				local identity = vRP.getUserIdentity(nuser_id)
				if identity then
					local fines = vRP.getFines(nuser_id)
					TriggerClientEvent("Notify",source,"importante","<b>Passaporte:</b> "..identity.id.."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone.."<br><b>Multas Pendentes:</b> $"..vRP.format(parseInt(fines)),20000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RG
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("postit",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	if user_id then
		if HasPermission(source,"postit") then
			TriggerClientEvent("postit:initPostit",source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- APREENDER MESA DE DROGA
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("apreendermesa",function (source)
    local user_id = vRP.getUserId(source)
    if user_id and vRP.hasPermission(user_id,"policia.permissao") then
        local DrugTables = GlobalState.DrugTables or {}
        local coords = GetEntityCoords(GetPlayerPed(source))
        for k,v in pairs(DrugTables) do
			local distance = #(coords - vector3(v["x"],v["y"],v["z"]))
            if distance < 2 then
                vRPclient._playAnim(source,false,{{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"}},true)
                Wait(4000)
                TriggerClientEvent("Notify",source,"sucesso","Você apreendeu uma mesa de drogas.",5000)
                vRPclient._stopAnim(source)
                if DrugTables[k] then
                    DrugTables[k] = nil
                end
                GlobalState:set("DrugTables",DrugTables,true)
                return
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMMANDS - GARAGEM SEOUL
-----------------------------------------------------------------------------------------------------------------------------------------
SeoulRegisterCommand("car",function(source,args)
		local user_id = vRP.getUserId(source)
		if user_id then
			if args[1] and vRP.hasPermission(user_id,"admin.permissao") then
				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				local mHash = GetHashKey(args[1])
				local nveh = CreateVehicle(mHash,Coords["x"],Coords["y"],Coords["z"],GetEntityHeading(Ped),true,true)
				local cooldown = 0
				while not DoesEntityExist(nveh) and cooldown < 5000 do
					Wait(1)
					cooldown = cooldown + 1
				end
				if DoesEntityExist(nveh) then
					SetPedIntoVehicle(Ped,nveh,-1)
				end
			end
		end
	end)

SeoulRegisterCommand("dv",function(source,args,rawCommand)
		local user_id = vRP.getUserId(source)
		if vRP.hasPermission(user_id,"admin.permissao") then
			local _, Network = vRPclient.getNearVehicle(source,12)
			local Veh = NetworkGetEntityFromNetworkId(Network)
			if Veh and DoesEntityExist(Veh) then
				DeleteEntity(Veh)
			end
		end
	end)
