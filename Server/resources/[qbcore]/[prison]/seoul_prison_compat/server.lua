local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
local vRP = Proxy.getInterface('vRP')
local vKEYBOARD = Tunnel.getInterface('keyboard')

-- Compatibilidade preservada do antigo [creative]/prison.
-- Estes eventos são utilidades policiais; não controlam sentença/prisão.

RegisterNetEvent('prison:Itens')
AddEventHandler('prison:Itens', function(OtherSource)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport or not OtherSource or not vRP.HasService(Passport,'Police') or vRP.GetHealth(source) <= 100 then return end
    local OtherPassport = vRP.Passport(OtherSource)
    if not OtherPassport then return end
    TriggerClientEvent('Notify',source,'Sucesso','Objetos apreendidos.','verde',5000)
    if GetResourceState('inventory') == 'started' then
        exports.inventory:CleanWeapons(OtherPassport)
    end
    vRP.ArrestItens(OtherPassport)
end)

RegisterNetEvent('prison:Plate')
AddEventHandler('prison:Plate', function(Entitys)
    local source = source
    local Passport = vRP.Passport(source)
    if not Passport or not vRP.HasService(Passport,'Police') then return end
    TriggerClientEvent('dynamic:Close',source)
    local Plate = Entitys and Entitys[1]
    if not Plate then
        local Keyboard = vKEYBOARD.Primary(source,'Placa')
        Plate = Keyboard and Keyboard[1]
    end
    if not Plate or Plate == '' then
        TriggerClientEvent('Notify',source,'Emplacamento','Você precisa informar uma placa.','vermelho',5000)
        return
    end
    Plate = string.gsub(string.upper(Plate),'%W','')
    local OtherPassport = vRP.PassportPlate(Plate)
    if not OtherPassport then
        TriggerClientEvent('Notify',source,'Emplacamento','Placa não encontrada no sistema.','policia',5000)
        return
    end
    local Identity = vRP.Identity(OtherPassport)
    if not Identity then
        TriggerClientEvent('Notify',source,'Emplacamento','Identidade vinculada não encontrada.','policia',5000)
        return
    end
    local Message = string.format('<b>Passaporte:</b> %s<br><b>Telefone:</b> %s<br><b>Nome:</b> %s %s',Identity.id,vRP.Phone(OtherPassport),Identity.Name,Identity.Lastname)
    TriggerClientEvent('Notify',source,'Emplacamento',Message,'policia',10000)
end)

RegisterNetEvent('prison:Vehicle')
AddEventHandler('prison:Vehicle', function(Entity)
    local source = source
    local Plate = Entity and Entity[1]
    local Passport = vRP.Passport(source)
    if not Passport or not vRP.HasService(Passport,'Police') or not Plate then return end
    if not vRP.Request(source,'Garagem','Apreender o veículo?') or not vRP.PassportPlate(Plate) then return end
    local Vehicle = vRP.Query('vehicles/plateVehicles',{ Plate = Plate })
    if Vehicle[1] then
        if not Vehicle[1].Arrest then
            vRP.Query('vehicles/Arrest',{ Plate = Plate })
            local OwnerPassport = vRP.PassportPlate(Plate)
            local OwnerSource = OwnerPassport and vRP.Source(OwnerPassport)
            if OwnerSource then
                TriggerClientEvent('Notify',OwnerSource,'Departamento Policial',('Seu veículo de placa <b>%s</b> foi apreendido e enviado para a <b>Garagem Reboque</b>.'):format(Plate),'policia',10000)
            end
            TriggerClientEvent('Notify',source,'Departamento Policial','Veículo apreendido e enviado para a <b>Garagem Reboque</b>.','policia',5000)
        else
            TriggerClientEvent('Notify',source,'Departamento Policial','Veículo já se encontra apreendido.','policia',5000)
        end
    end
end)
