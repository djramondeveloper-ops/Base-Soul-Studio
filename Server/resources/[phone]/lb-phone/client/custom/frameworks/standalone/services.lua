if Config.Framework ~= "standalone" then
    return
end

local serviceContext = {
    job = "unemployed",
    jobLabel = "Desempregado",
    grade = 0,
    gradeLabel = "Desempregado",
    isBoss = false,
    duty = false
}

local function IsMappedPermission(permission)
    for _, permissions in pairs(Config.VRPJobs or {}) do
        for i = 1, #permissions do
            if permissions[i] == permission then
                return true
            end
        end
    end

    return false
end

local function RefreshServiceContext()
    local data = AwaitCallback("vrp:getServiceContext")
    if data then
        serviceContext = data
    end

    return serviceContext
end

CreateThread(function()
    while not FrameworkLoaded do Wait(250) end
    RefreshServiceContext()
end)

RegisterNetEvent("service:Client", function(permission)
    if not IsMappedPermission(permission) then return end

    CreateThread(function()
        Wait(100)

        local oldJob = serviceContext.job
        local oldGrade = serviceContext.grade
        RefreshServiceContext()

        if oldJob ~= serviceContext.job or oldGrade ~= serviceContext.grade then
            SendNUIAction("services:setCompany", GetCompanyData())
        else
            SendNUIAction("services:setDuty", serviceContext.duty == true)
        end

        TriggerEvent("lb-phone:jobUpdated", {
            job = serviceContext.job,
            grade = serviceContext.grade
        })
    end)
end)

---@return string
function GetJob()
    return RefreshServiceContext().job or "unemployed"
end

---@return number
function GetJobGrade()
    return tonumber(RefreshServiceContext().grade) or 0
end

---@param cb fun(companyData: CompanyData)
---@return CompanyData? companyData
function GetCompanyData(cb)
    local context = RefreshServiceContext()

    if context.job == "unemployed" then
        return nil
    end

    local companyData = {
        job = context.job,
        jobLabel = context.jobLabel or context.job,
        isBoss = context.isBoss == true,
        duty = context.duty == true
    }

    if cb then cb(companyData) end
    return companyData
end

-- Company management remains disabled in Config.Companies.Management.Enabled.
-- These return false instead of pretending to persist unsupported management data.
function DepositMoney(amount, cb)
    if cb then cb(false) end
    return false
end

function WithdrawMoney(amount, cb)
    if cb then cb(false) end
    return false
end

function HireEmployee(source, cb)
    if cb then cb(false) end
    return false
end

function FireEmployee(id, cb)
    if cb then cb(false) end
    return false
end

function SetGrade(id, newGrade, cb)
    if cb then cb(false) end
    return false
end

---@param duty boolean
function ToggleDuty(duty)
    local data = AwaitCallback("vrp:toggleServiceDuty")
    if data then
        serviceContext = data
        SendNUIAction("services:setDuty", serviceContext.duty == true)
        TriggerEvent("lb-phone:jobUpdated", { job = serviceContext.job, grade = serviceContext.grade })
    end
end
