local Snapshot={brothels={},workers={}}
local TargetedWorkers={}
local ManagementZones={}
local ManagementAccess={}
local ActiveSession=nil
local RoomTextShown=false

local function isInteractReady()
    return GetResourceState('interact') == 'started'
end

local function isOxTargetReady()
    return GetResourceState('ox_target') == 'started'
end

local function addInteractCoords(name, coords, option)
    if not isInteractReady() then return false end

    return exports.interact:addCoords(coords,{
        name = name,
        icon = option.icon,
        label = option.label,
        distance = option.distance or 2.0,
        onSelect = option.onSelect
    })
end

local function removeInteractCoords(id)
    if id and isInteractReady() then
        pcall(function() exports.interact:removeCoords(id) end)
    end
end

local function addInteractLocalEntity(entity, option)
    if not isInteractReady() then return false end

    exports.interact:addLocalEntity(entity,{
        name = option.name,
        icon = option.icon,
        label = option.label,
        distance = option.distance or Config.TargetDistance or 2.0,
        onSelect = option.onSelect
    })

    return true
end

local function removeInteractLocalEntity(entity, name)
    if entity and DoesEntityExist(entity) and isInteractReady() then
        pcall(function() exports.interact:removeLocalEntity(entity,name) end)
    end
end

local function notify(kind,msg)
    lib.notify({type=kind or 'inform',description=msg or ''})
end

local function removeTargets()
    for workerId,data in pairs(TargetedWorkers) do
        if data.entity and DoesEntityExist(data.entity) then
            removeInteractLocalEntity(data.entity, 'seoul_brothels_worker_'..workerId)
            if isOxTargetReady() then pcall(function() exports.ox_target:removeLocalEntity(data.entity, 'seoul_brothels_worker_'..workerId) end) end
        end
    end
    TargetedWorkers={}
    for id,zone in pairs(ManagementZones) do
        if type(zone) == 'table' and zone.type == 'interact' then
            removeInteractCoords(zone.id)
        elseif isOxTargetReady() then
            pcall(function() exports.ox_target:removeZone(zone) end)
        end
    end
    ManagementZones={}
end

local function openBusinessPanel(bid)
    local data=lib.callback.await('seoul_brothels:getBusinessPanel',false,bid)
    if not data then return notify('error','Você não administra este estabelecimento.') end
    local opts={
        {title=data.name,description=('Caixa: $%s | %s'):format(data.balance or 0,data.is_open and 'ABERTO' or 'FECHADO'),icon='building'},
        {title=data.is_open and 'Fechar estabelecimento' or 'Abrir estabelecimento',icon='door-open',onSelect=function() TriggerServerEvent('seoul_brothels:businessToggle',bid) Wait(250) openBusinessPanel(bid) end},
        {title='Alterar preços',icon='tags',onSelect=function()
            local fields={} local keys={}
            for key,cfg in pairs(Config.Services) do
                keys[#keys+1]=key
                fields[#fields+1]={type='number',label=cfg.label,default=tonumber((data.prices or {})[key]) or cfg.defaultPrice,min=cfg.minPrice,max=cfg.maxPrice,required=true}
            end
            local i=lib.inputDialog('Preços do estabelecimento',fields)
            if i then local prices={} for n,key in ipairs(keys) do prices[key]=i[n] end TriggerServerEvent('seoul_brothels:businessSetPrices',bid,prices) end
        end},
        {title='Depositar no caixa',icon='money-bill-transfer',onSelect=function()
            local i=lib.inputDialog('Depositar',{ {type='number',label='Valor',required=true,min=1} })
            if i then TriggerServerEvent('seoul_brothels:deposit',bid,i[1]) end
        end},
        {title='Sacar do caixa (dono)',icon='building-columns',onSelect=function()
            local i=lib.inputDialog('Sacar',{ {type='number',label='Valor',required=true,min=1} })
            if i then TriggerServerEvent('seoul_brothels:withdraw',bid,i[1]) end
        end},
        {title='Adicionar gerente (dono)',icon='user-plus',onSelect=function()
            local i=lib.inputDialog('Novo gerente',{ {type='number',label='Passport',required=true,min=1} })
            if i then TriggerServerEvent('seoul_brothels:addManager',bid,i[1]) end
        end}
    }
    for _,m in ipairs(data.managers or {}) do
        local managerPassport=m.passport
        opts[#opts+1]={title=('Gerente Passport %s'):format(managerPassport),description='Clique para remover (somente dono)',icon='user-minus',onSelect=function() TriggerServerEvent('seoul_brothels:removeManager',bid,managerPassport) end}
    end
    if #(data.transactions or {}) > 0 then
        opts[#opts+1]={title='Últimas movimentações',description='Histórico recente do caixa',icon='clock-rotate-left'}
        for _,t in ipairs(data.transactions) do
            opts[#opts+1]={title=('%s $%s'):format(t.type or 'movimento',t.amount or 0),description=('%s | Passport: %s'):format(t.description or '',t.passport or '-'),icon='receipt'}
        end
    end
    lib.registerContext({id='seoul_brothels_business_'..bid,title='Administração do bordel',options=opts})
    lib.showContext('seoul_brothels_business_'..bid)
end

local function startService(workerId)
    local w=Snapshot.workers[workerId]; if not w then return end
    local b=Snapshot.brothels[w.brothel_id]; if not b or not b.is_open then return notify('error','Estabelecimento fechado.') end
    local opts={}
    for key,cfg in pairs(Config.Services) do
        local serviceKey=key
        local price=tonumber((b.prices or {})[key]) or cfg.defaultPrice
        opts[#opts+1]={title=cfg.label,description=('$%s'):format(price),icon='heart',onSelect=function()
            local result=lib.callback.await('seoul_brothels:purchaseService',false,workerId,serviceKey)
            if not result or not result.ok then return notify('error',(result and result.message) or 'Falha no atendimento.') end
            ActiveSession={room=result.room,roomName=result.roomName,duration=result.duration or Config.ServiceDurationMs}
            notify('success',('%s Vá até %s.'):format(result.message or '',result.roomName or 'o quarto'))
            if result.room then SetNewWaypoint(result.room.x+0.0,result.room.y+0.0) end
        end}
    end
    lib.registerContext({id='seoul_brothels_worker_menu',title=w.name or 'Atendimento',options=opts})
    lib.showContext('seoul_brothels_worker_menu')
end

local function rebuildManagementZones()
    for _,zone in pairs(ManagementZones) do
        if type(zone) == 'table' and zone.type == 'interact' then
            removeInteractCoords(zone.id)
        elseif isOxTargetReady() then
            pcall(function() exports.ox_target:removeZone(zone) end)
        end
    end
    ManagementZones={}
    for _,b in ipairs(ManagementAccess or {}) do
        local zoneBid = b.id
        local c=b.management
        if c and c.x and c.y and c.z then
            local option={name='seoul_brothels_manage_'..zoneBid,icon='fa-solid fa-briefcase',label='Administrar '..(b.name or 'bordel'),distance=2.0,onSelect=function() openBusinessPanel(zoneBid) end}
            local id=addInteractCoords(option.name,vec3(c.x,c.y,c.z),option)
            if id then
                ManagementZones['management_'..zoneBid]={type='interact',id=id}
            elseif isOxTargetReady() then
                ManagementZones['management_'..zoneBid]=exports.ox_target:addSphereZone({
                    coords=vec3(c.x,c.y,c.z),radius=1.2,debug=false,
                    options={option}
                })
            end
        end
        local cashier=b.cashier
        if cashier and cashier.x and cashier.y and cashier.z then
            local option={name='seoul_brothels_cashier_'..zoneBid,icon='fa-solid fa-cash-register',label='Caixa de '..(b.name or 'bordel'),distance=2.0,onSelect=function() openBusinessPanel(zoneBid) end}
            local id=addInteractCoords(option.name,vec3(cashier.x,cashier.y,cashier.z),option)
            if id then
                ManagementZones['cashier_'..zoneBid]={type='interact',id=id}
            elseif isOxTargetReady() then
                ManagementZones['cashier_'..zoneBid]=exports.ox_target:addSphereZone({
                    coords=vec3(cashier.x,cashier.y,cashier.z),radius=1.0,debug=false,
                    options={option}
                })
            end
        end
    end
end

RegisterNetEvent('seoul_brothels:sync',function(data)
    Snapshot=data or {brothels={},workers={}}
    CreateThread(function()
        ManagementAccess=lib.callback.await('seoul_brothels:getMyManagementPoints',false) or {}
        rebuildManagementZones()
    end)
end)

local function adminEditBrothel(b)
    local bid=b.id
    local opts={
        {title=('Bordel #%s - %s'):format(b.id,b.name),description=('Dono: %s | %s'):format(b.owner_passport or 'sem dono',b.is_open and 'ABERTO' or 'FECHADO'),icon='building'},
        {title='Teleportar para entrada',icon='location-dot',onSelect=function() if b.entrance then SetEntityCoords(PlayerPedId(),b.entrance.x,b.entrance.y,b.entrance.z,false,false,false,false) end end},
        {title='Marcar ENTRADA aqui',icon='location-crosshairs',onSelect=function() TriggerServerEvent('seoul_brothels:adminSetPoint',bid,'entrance') end},
        {title='Marcar ADMINISTRAÇÃO aqui',icon='briefcase',onSelect=function() TriggerServerEvent('seoul_brothels:adminSetPoint',bid,'management') end},
        {title='Marcar CAIXA aqui',icon='cash-register',onSelect=function() TriggerServerEvent('seoul_brothels:adminSetPoint',bid,'cashier') end},
        {title='Definir dono por Passport',icon='user-tie',onSelect=function() local i=lib.inputDialog('Dono',{ {type='number',label='Passport',required=true,min=1} }); if i then TriggerServerEvent('seoul_brothels:adminSetOwner',bid,i[1]) end end},
        {title='Adicionar quarto nesta posição',icon='bed',onSelect=function() local i=lib.inputDialog('Novo quarto',{ {type='input',label='Nome',required=true} }); if i then TriggerServerEvent('seoul_brothels:adminAddRoom',bid,i[1]) end end},
        {title='Adicionar funcionária nesta posição',icon='person-dress',onSelect=function()
            local models={} for _,m in ipairs(Config.WorkerModels) do models[#models+1]={label=m,value=m} end
            local i=lib.inputDialog('Nova funcionária',{ {type='input',label='Nome',required=true},{type='select',label='Modelo',options=models,required=true} })
            if i then TriggerServerEvent('seoul_brothels:adminAddWorker',bid,i[1],i[2]) end
        end},
        {title='Alterar preços',icon='tags',onSelect=function()
            local fields={} local keys={}
            for key,cfg in pairs(Config.Services) do keys[#keys+1]=key; fields[#fields+1]={type='number',label=cfg.label,default=tonumber((b.prices or {})[key]) or cfg.defaultPrice,min=cfg.minPrice,max=cfg.maxPrice,required=true} end
            local i=lib.inputDialog('Preços',fields); if i then local p={} for n,key in ipairs(keys) do p[key]=i[n] end TriggerServerEvent('seoul_brothels:adminSetPrices',bid,p) end
        end},
        {title=b.is_open and 'Fechar bordel' or 'Abrir bordel',icon='door-open',onSelect=function() TriggerServerEvent('seoul_brothels:adminToggle',bid) end}
    }
    for _,r in ipairs(b.rooms or {}) do
        local roomId, roomName=r.id,r.name
        opts[#opts+1]={title='Remover quarto: '..roomName,icon='trash',onSelect=function() TriggerServerEvent('seoul_brothels:adminDeleteRoom',bid,roomId) end}
    end
    for _,w in ipairs(b.workers or {}) do
        local workerId,workerName,workerModel=w.id,w.name,w.model
        opts[#opts+1]={title='Remover funcionária: '..workerName,description=workerModel,icon='trash',onSelect=function() TriggerServerEvent('seoul_brothels:adminDeleteWorker',bid,workerId) end}
    end
    opts[#opts+1]={title='EXCLUIR BORDEL',description='Ação permanente',icon='trash',iconColor='red',onSelect=function()
        local a=lib.alertDialog({header='Excluir '..b.name,content='Essa ação remove bordel, quartos, funcionárias e histórico.',centered=true,cancel=true})
        if a=='confirm' then TriggerServerEvent('seoul_brothels:adminDelete',bid) end
    end}
    lib.registerContext({id='seoul_brothels_admin_edit_'..bid,title='Configurar bordel',options=opts})
    lib.showContext('seoul_brothels_admin_edit_'..bid)
end

local function openAdmin()
    local list=lib.callback.await('seoul_brothels:getAdminData',false)
    if not list then return notify('error','Sem permissão.') end
    local opts={{title='Criar novo bordel aqui',description='A posição atual vira a entrada inicial',icon='plus',onSelect=function()
        local i=lib.inputDialog('Criar bordel',{ {type='input',label='Nome',required=true,min=2,max=80},{type='number',label='Passport do dono (opcional)',min=1} })
        if i then TriggerServerEvent('seoul_brothels:adminCreate',{name=i[1],owner_passport=i[2]}) end
    end}}
    for _,b in ipairs(list) do
        local brothelData=b
        opts[#opts+1]={title=('#%s - %s'):format(brothelData.id,brothelData.name),description=('Dono: %s | %s | %s quartos | %s funcionárias'):format(brothelData.owner_passport or '-',brothelData.is_open and 'ABERTO' or 'FECHADO',#(brothelData.rooms or {}),#(brothelData.workers or {})),icon='building',onSelect=function() adminEditBrothel(brothelData) end}
    end
    lib.registerContext({id='seoul_brothels_admin',title='Bordéis - Seoul',options=opts})
    lib.showContext('seoul_brothels_admin')
end

RegisterNetEvent('seoul_brothels:adminOpen',openAdmin)

CreateThread(function()
    Wait(1500)
    TriggerServerEvent('seoul_brothels:requestSync')
    while true do
        Wait(1500)
        for workerId,w in pairs(Snapshot.workers or {}) do
            if w.active and w.netId then
                local entity=NetworkGetEntityFromNetworkId(w.netId)
                local current=TargetedWorkers[workerId]
                if entity and entity~=0 and DoesEntityExist(entity) and (not current or current.entity~=entity) then
                    if current and current.entity and DoesEntityExist(current.entity) then
                        removeInteractLocalEntity(current.entity,'seoul_brothels_worker_'..workerId)
                        if isOxTargetReady() then pcall(function() exports.ox_target:removeLocalEntity(current.entity,'seoul_brothels_worker_'..workerId) end) end
                    end
                    local targetWorkerId=workerId
                    pcall(SetBlockingOfNonTemporaryEvents,entity,true)
                    pcall(SetEntityInvincible,entity,true)
                    pcall(FreezeEntityPosition,entity,true)
                    local option={name='seoul_brothels_worker_'..targetWorkerId,icon='fa-solid fa-heart',label='Falar com '..(w.name or 'funcionária'),distance=Config.TargetDistance,onSelect=function() startService(targetWorkerId) end}
                    if not addInteractLocalEntity(entity,option) and isOxTargetReady() then
                        exports.ox_target:addLocalEntity(entity,{option})
                    end
                    TargetedWorkers[targetWorkerId]={entity=entity}
                end
            end
        end
        for workerId,current in pairs(TargetedWorkers) do
            if not Snapshot.workers[workerId] or not current.entity or not DoesEntityExist(current.entity) then
                if current.entity and DoesEntityExist(current.entity) then
                    removeInteractLocalEntity(current.entity,'seoul_brothels_worker_'..workerId)
                    if isOxTargetReady() then pcall(function() exports.ox_target:removeLocalEntity(current.entity,'seoul_brothels_worker_'..workerId) end) end
                end
                TargetedWorkers[workerId]=nil
            end
        end
    end
end)

CreateThread(function()
    while true do
        if ActiveSession and ActiveSession.room then
            local c=GetEntityCoords(PlayerPedId()); local r=ActiveSession.room; local dist=#(c-vec3(r.x,r.y,r.z))
            if dist<2.0 then
                if not RoomTextShown then
                    lib.showTextUI('[E] Iniciar atendimento')
                    RoomTextShown=true
                end
                if IsControlJustReleased(0,38) then
                    if RoomTextShown then lib.hideTextUI(); RoomTextShown=false end
                    local ok=lib.progressCircle({duration=ActiveSession.duration or Config.ServiceDurationMs,label='Atendimento em andamento...',position='bottom',canCancel=false,disable={move=true,car=true,combat=true}})
                    if ok then
                        local result=lib.callback.await('seoul_brothels:finishSession',false)
                        if result and result.ok then notify('success','Atendimento concluído.') else notify('error',(result and result.message) or 'Atendimento não pôde ser concluído.') end
                    end
                    ActiveSession=nil
                end
                Wait(0)
            else
                if RoomTextShown then lib.hideTextUI(); RoomTextShown=false end
                Wait(500)
            end
        else
            if RoomTextShown then lib.hideTextUI(); RoomTextShown=false end
            Wait(1000)
        end
    end
end)

AddEventHandler('onResourceStop',function(resource)
    if resource~=GetCurrentResourceName() then return end
    if RoomTextShown then lib.hideTextUI(); RoomTextShown=false end; removeTargets()
end)
