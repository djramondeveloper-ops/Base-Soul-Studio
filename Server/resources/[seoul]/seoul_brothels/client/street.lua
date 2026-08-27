if not Config.Street or not Config.Street.Enabled then return end

local streetBusy=false
local streetSearching=false
local hookerModels={}
for _,modelName in ipairs(Config.Street.HookerModelNames or {}) do
    hookerModels[joaat(modelName)]=true
end

local function help(text)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0,false,true,-1)
end

local function notify(kind,text)
    lib.notify({type=kind or 'inform',description=text or ''})
end

local function eligiblePed(ped)
    if not ped or ped==0 or ped==PlayerPedId() or IsPedAPlayer(ped) or IsEntityDead(ped) or IsPedInAnyVehicle(ped,true) then return false end
    return hookerModels[GetEntityModel(ped)] == true
end

local function validVehicle(vehicle)
    if not vehicle or vehicle==0 then return false end
    return not Config.Street.BlacklistedVehicleClasses[GetVehicleClass(vehicle)]
end

local function findHooker(vehicle)
    local vc=GetEntityCoords(vehicle)
    local nearest,nearestDist
    for _,ped in ipairs(GetGamePool('CPed')) do
        if eligiblePed(ped) then
            local d=#(GetEntityCoords(ped)-vc)
            if d<=Config.Street.MaxDistance and (not nearestDist or d<nearestDist) then nearest,nearestDist=ped,d end
        end
    end
    return nearest,nearestDist
end

local function isSecluded(hooker,vehicle)
    if GetEntitySpeed(vehicle)>Config.Street.MaxVehicleSpeed then return false end
    local vc=GetEntityCoords(vehicle)
    for _,ped in ipairs(GetGamePool('CPed')) do
        if ped~=PlayerPedId() and ped~=hooker and not IsEntityDead(ped) then
            local d=#(GetEntityCoords(ped)-vc)
            if d<Config.Street.SecludedRadius and HasEntityClearLosToEntity(ped,vehicle,17) then return false end
        end
    end
    for _,player in ipairs(GetActivePlayers()) do
        if player~=PlayerId() then
            local ped=GetPlayerPed(player)
            if ped and ped~=0 and #(GetEntityCoords(ped)-vc)<Config.Street.SecludedRadius and HasEntityClearLosToEntity(ped,vehicle,17) then return false end
        end
    end
    return true
end

local function chooseStreetService()
    local selected=nil
    local opts={}
    for key,cfg in pairs(Config.Services) do
        local serviceKey=key
        local price=tonumber(Config.Street.Prices[key]) or cfg.defaultPrice
        opts[#opts+1]={title=cfg.label,description=('$%s'):format(price),icon='heart',onSelect=function() selected=serviceKey end}
    end
    opts[#opts+1]={title='Dispensar',icon='xmark',onSelect=function() selected='decline' end}
    lib.registerContext({id='seoul_brothels_street_service',title='Serviços disponíveis',options=opts,onExit=function() if not selected then selected='decline' end end})
    lib.showContext('seoul_brothels_street_service')
    while not selected do Wait(50) end
    return selected
end

local function resetHooker(hooker)
    if hooker and DoesEntityExist(hooker) then
        SetBlockingOfNonTemporaryEvents(hooker,false)
        SetEntityInvincible(hooker,false)
    end
    streetBusy=false
end

local function streetInteraction(hooker,vehicle)
    if streetBusy then return end
    streetBusy=true
    SetBlockingOfNonTemporaryEvents(hooker,true)
    if NetworkGetEntityIsNetworked(hooker) then
        NetworkRequestControlOfEntity(hooker)
        local controlDeadline=GetGameTimer()+1500
        while not NetworkHasControlOfEntity(hooker) and GetGameTimer()<controlDeadline do
            NetworkRequestControlOfEntity(hooker)
            Wait(50)
        end
    end
    TaskEnterVehicle(hooker,vehicle,10000,0,1.0,1,0)
    local deadline=GetGameTimer()+12000
    while GetGameTimer()<deadline and DoesEntityExist(hooker) and GetPedInVehicleSeat(vehicle,0)~=hooker do
        if GetVehiclePedIsIn(PlayerPedId(),false)~=vehicle then resetHooker(hooker); return end
        Wait(100)
    end
    if not DoesEntityExist(hooker) or GetPedInVehicleSeat(vehicle,0)~=hooker then resetHooker(hooker); return end

    notify('inform','Vá para um local mais isolado e pare o veículo.')
    deadline=GetGameTimer()+Config.Street.SecludedTimeoutMs
    while GetGameTimer()<deadline do
        if not DoesEntityExist(hooker) or GetVehiclePedIsIn(PlayerPedId(),false)~=vehicle then resetHooker(hooker); return end
        if isSecluded(hooker,vehicle) then break end
        if GetEntitySpeed(vehicle)<=Config.Street.MaxVehicleSpeed then help('Procure um local mais isolado.') end
        Wait(250)
    end
    if GetGameTimer()>=deadline then
        TaskLeaveVehicle(hooker,vehicle,0)
        notify('error','Você demorou demais para encontrar um local isolado.')
        Wait(1500); resetHooker(hooker); return
    end

    local completed=0
    while completed<Config.Street.MaxServices and DoesEntityExist(hooker) and GetPedInVehicleSeat(vehicle,0)==hooker do
        local service=chooseStreetService()
        if service=='decline' then break end
        local result=lib.callback.await('seoul_brothels:purchaseStreetService',false,service)
        if not result or not result.ok then notify('error',(result and result.message) or 'Pagamento recusado.'); break end
        FreezeEntityPosition(vehicle,true)
        local ok=lib.progressCircle({duration=Config.ServiceDurationMs,label='Atendimento em andamento...',position='bottom',canCancel=false,disable={move=true,car=true,combat=true}})
        FreezeEntityPosition(vehicle,false)
        if not ok then break end
        completed=completed+1
    end
    if DoesEntityExist(hooker) then TaskLeaveVehicle(hooker,vehicle,0) end
    Wait(1500)
    resetHooker(hooker)
end

local function searchLoop()
    if streetSearching or streetBusy then return end
    streetSearching=true
    CreateThread(function()
        while not streetBusy do
            local playerPed=PlayerPedId()
            local vehicle=GetVehiclePedIsIn(playerPed,false)
            if vehicle==0 or GetPedInVehicleSeat(vehicle,-1)~=playerPed then break end
            if validVehicle(vehicle) and GetEntitySpeed(vehicle)<=Config.Street.MaxVehicleSpeed and IsVehicleSeatFree(vehicle,0) then
                local hooker=findHooker(vehicle)
                if hooker then
                    help('Buzine para chamar a profissional.')
                    if IsPlayerPressingHorn(PlayerId()) then
                        streetSearching=false
                        streetInteraction(hooker,vehicle)
                        return
                    end
                end
            end
            Wait(Config.Street.SearchIntervalMs)
        end
        streetSearching=false
    end)
end

AddEventHandler('gameEventTriggered',function(event,args)
    if event=='CEventNetworkPlayerEnteredVehicle' and args[1]==PlayerId() then
        Wait(250)
        searchLoop()
    end
end)

CreateThread(function()
    while true do
        if not streetBusy then
            local ped=PlayerPedId(); local vehicle=GetVehiclePedIsIn(ped,false)
            if vehicle~=0 and GetPedInVehicleSeat(vehicle,-1)==ped then searchLoop() end
        end
        Wait(2000)
    end
end)
