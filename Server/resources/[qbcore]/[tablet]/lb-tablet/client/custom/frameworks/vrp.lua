if Config.Framework ~= "vrp" then return end

debugprint("Loading vRP integration")
local context = { job = { name="unemployed", label="Desempregado", grade=0, grade_label="Desempregado" }, duty=true, hasItem=false }
local function refresh()
    local data = AwaitCallback("vrp:getPlayerContext")
    if data then context = data end
    return context
end
while not LocalPlayer.state.Passport do Wait(500) end
refresh(); FrameworkLoaded=true; TriggerServerEvent("lb-tablet:frameworkLoaded")
RegisterNetEvent("lb-tablet:vrpLoaded", function() refresh(); FrameworkLoaded=true; TriggerServerEvent("lb-tablet:frameworkLoaded"); FetchTabletData() end)
AddStateBagChangeHandler("Passport", ("player:%s"):format(GetPlayerServerId(PlayerId())), function(_,_,value)
    if value then refresh(); FrameworkLoaded=true else FrameworkLoaded=false; LogOut() end
end)

-- Seoul vRP emits this event whenever a player enters or leaves a service.
-- Keep the tablet context/NUI in sync so duty-gated work apps appear/disappear immediately.
RegisterNetEvent("service:Client", function(permission, status)
    if not permission or not (Config.VRP.Jobs or {})[permission] then return end

    CreateThread(function()
        -- SetPermission calls ServiceEnter before persisting the new group level in Seoul.
        -- A short yield lets the authoritative permission data settle before refreshing.
        Wait(100)

        local oldJob = context.job and context.job.name or Config.VRP.DefaultJob
        local oldGrade = context.job and context.job.grade or 0

        refresh()
        FrameworkLoaded = true

        local newJob = context.job and context.job.name or Config.VRP.DefaultJob
        local newGrade = context.job and context.job.grade or 0

        TriggerEvent("lb-tablet:jobUpdated")
        TriggerServerEvent("lb-tablet:vrpServiceChanged")

        if oldJob ~= newJob or oldGrade ~= newGrade then
            SendReactMessage("services:setCompany", GetCompanyData())
        else
            SendReactMessage("services:setDuty", context.duty ~= false)
        end
    end)
end)
function IsAdmin() return AwaitCallback("isAdmin") end
function HasTabletItem() if not Config.Item.Require then return true end return refresh().hasItem == true end
function GetJob() return (context.job and context.job.name) or "unemployed" end
function IsOnDuty() return context.duty ~= false end
function GetJobGrade() return (context.job and context.job.permission_grade) or 0 end
function FormatVehicle(vehicle)
    if vehicle.name then vehicle.owner={name=vehicle.name,identifier=vehicle.owner}; vehicle.name=nil end
    vehicle.color = vehicle.color and {label="",hex=vehicle.color} or nil
    return vehicle
end
function GetCompanyData()
    refresh(); local job=context.job or {}; local cfg=(Config.VRP.Jobs or {})[job.name]; local data={job=job.name or "unemployed",jobLabel=job.label or "Desempregado",isBoss=cfg and job.grade <= (cfg.bossGrade or 1) or false,duty=context.duty~=false,receiveCalls=GetCompanyCallsStatus and GetCompanyCallsStatus()}
    if data.isBoss then data.balance=AwaitCallback("services:getAccount") or 0; data.employees=AwaitCallback("services:getEmployees",data.job) or {}; data.grades=(AwaitCallback("vrp:getJobGrades",data.job) or {}) end
    return data
end
function DepositMoney(amount) return AwaitCallback("services:addMoney",amount) end
function WithdrawMoney(amount) return AwaitCallback("services:removeMoney",amount) end
function HireEmployee(source) return AwaitCallback("vrp:hireEmployee",source) end
function FireEmployee(identifier) return AwaitCallback("vrp:fireEmployee",identifier) end
function SetGrade(identifier,newGrade) return AwaitCallback("vrp:setEmployeeGrade",identifier,newGrade) end
function ToggleDuty() context.duty=AwaitCallback("vrp:toggleDuty"); TriggerEvent("lb-tablet:jobUpdated"); return context.duty end
function GetWeaponsList() return Weapons end
RegisterNetEvent("lb-tablet:openFromItem", function() ToggleOpen(true) end)
