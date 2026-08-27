GlobalState["AllPeds"] = {}

local function normalizePedId(id)
    return tonumber(id) or id
end

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'core' or resourceName == GetCurrentResourceName() then
        if resourceName == GetCurrentResourceName() then
            GlobalState["AllPeds"] = GetControlFile("peds") or {}
        end
    end
end)

RegisterCommand(Config.Commands["peds"]['command'],function(source)
    if AdminControlCanUse(source, Config.Commands["peds"].perm) then
        ClientControl.getPedData(source)
    end
end)

RegisterServerEvent("AdminControl:addPed",function (coords,heading,pedModel)
    local source = source
    if not AdminControlCanUse(source, Config.Commands["peds"].perm) then return end
    if coords and pedModel then
        local AllPeds = GetControlFile("peds") or {}
        local Data = {
            Distance = 50,
            Coords = { coords.x, coords.y, coords.z, heading + 0.001 },
            Model = pedModel,
            anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
        }
        local id = #AllPeds + 1
        SaveControlFile("peds",id,Data)
        AllPeds = GetControlFile("peds") or {}
        GlobalState:set("AllPeds",AllPeds,true)
        TriggerClientEvent("Notify",source,"sucesso","Npc adicionado com sucesso",5000)
    end
end)

RegisterServerEvent("AdminControl:editPed",function (id,coords,heading,pedModel)
    local source = source
    if not AdminControlCanUse(source, Config.Commands["peds"].perm) then return end
    id = normalizePedId(id)
    if id and coords and pedModel then
        local AllPeds = GetControlFile("peds") or {}
        if not AllPeds[id] then
            TriggerClientEvent("Notify",source,"negado","Ped nao encontrado",5000)
            return
        end

        local Data = {
            Distance = 50,
            Coords = { coords.x, coords.y, coords.z, heading + 0.001 },
            Model = pedModel,
            anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
        }
        AllPeds[id] = Data
        EditControlFile("peds",id,Data)
        AllPeds = GetControlFile("peds") or {}
        GlobalState:set("AllPeds",AllPeds,true)
        TriggerClientEvent("Notify",source,"sucesso","Npc editado com sucesso",5000)
    end
end)

RegisterServerEvent("AdminControl:deletePed",function (id)
    local source = source
    if not AdminControlCanUse(source, Config.Commands["peds"].perm) then return end
    id = normalizePedId(id)
    if id then
        local AllPeds = GetControlFile("peds") or {}
        if not AllPeds[id] then
            TriggerClientEvent("Notify",source,"negado","Ped nao encontrado",5000)
            return
        end

        RemoveControlFile("peds",id)
        AllPeds = GetControlFile("peds") or {}
        GlobalState:set("AllPeds",AllPeds,true)
        TriggerClientEvent("Notify",source,"sucesso","Npc removido com sucesso",5000)
    end
end)
