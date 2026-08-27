if Config.Framework ~= "vrp" then return end

local function companyKey(job) return Config.VRP.CompanyDataPrefix .. job end
local function companyData(job)
    local data = vRP.GetSrvData(companyKey(job), true) or {}
    data.balance = tonumber(data.balance) or 0
    return data
end
local function saveCompany(job, data) vRP.SetSrvData(companyKey(job), data, true) end

function GetEmployeeList(company)
    local permissions = vRP.GetSrvData("Permissions:" .. company, true) or {}
    local online = {}; for id, src in pairs(vRP.Players() or {}) do online[tostring(id)] = src end
    local hierarchy = vRP.Hierarchy(company) or {}; local result = {}
    for id, level in pairs(permissions) do
        local identity = vRP.Identity(tonumber(id))
        if identity then result[#result+1] = { identifier=tostring(id), firstname=identity.Name, lastname=identity.Lastname, grade=tonumber(level) or 1, gradeLabel=hierarchy[tonumber(level) or 1] or tostring(level), phoneNumber=GetPhoneNumberFromIdentifier(id), online=online[tostring(id)] ~= nil } end
    end
    return result
end

function RefreshCompanies() for _,d in ipairs(Config.Services.Companies) do d.open = vRP.AmountService(d.job) > 0 end end

function GetCompanyDataServer(source)
    local job = GetJob(source); local cfg=Config.VRP.Jobs[job.name]
    if not cfg then return nil end
    return { job=job.name, jobLabel=job.label, isBoss=job.grade <= (cfg.bossGrade or 1), duty=IsOnDuty(source), balance=companyData(job.name).balance }
end

RegisterCallback("services:getAccount", function(source) return companyData(GetJob(source).name).balance end)
RegisterCallback("services:addMoney", function(source, amount)
    local job=GetJob(source).name; amount=math.floor(tonumber(amount) or 0); if amount<=0 or not RemoveMoney(source,amount) then return false end
    local data=companyData(job); data.balance=data.balance+amount; saveCompany(job,data); return data.balance
end)
RegisterCallback("services:removeMoney", function(source, amount)
    local job=GetJob(source).name; amount=math.floor(tonumber(amount) or 0); local data=companyData(job)
    if amount<=0 or data.balance<amount then return false end; data.balance=data.balance-amount; saveCompany(job,data); AddMoney(source,amount); return data.balance
end)
RegisterCallback("services:getOnlineIdentifiers", function(source)
    local job=GetJob(source).name; local ids={}; for id,src in pairs(vRP.Players() or {}) do if GetJob(src).name==job then ids[tostring(id)]=true end end; return ids
end)
RegisterCallback("vrp:hireEmployee", function(source, targetSource)
    local boss=GetJob(source); local cfg=Config.VRP.Jobs[boss.name]; if not cfg or boss.grade>(cfg.bossGrade or 1) then return false end
    local target=vRP.Passport(tonumber(targetSource)); if not target then return false end
    local hierarchy=vRP.Hierarchy(boss.name) or {}; vRP.SetPermission(target,boss.name,#hierarchy); return {name=GetCharacterNameFromIdentifier(target),id=tostring(target)}
end)
RegisterCallback("vrp:fireEmployee", function(source, identifier)
    local boss=GetJob(source); local cfg=Config.VRP.Jobs[boss.name]; if not cfg or boss.grade>(cfg.bossGrade or 1) then return false end
    vRP.RemovePermission(tonumber(identifier),boss.name); return true
end)
RegisterCallback("vrp:setEmployeeGrade", function(source, identifier, grade)
    local boss=GetJob(source); local cfg=Config.VRP.Jobs[boss.name]; grade=tonumber(grade)
    if not cfg or boss.grade>(cfg.bossGrade or 1) or not grade or not (vRP.Hierarchy(boss.name) or {})[grade] then return false end
    vRP.SetPermission(tonumber(identifier),boss.name,grade); return true
end)
RegisterCallback("vrp:toggleDuty", function(source)
    local id=vRP.Passport(source); local job=GetJob(source).name; if not id or not Config.VRP.Jobs[job] then return false end
    vRP.ServiceToggle(source,id,job,true); TriggerEvent("lb-tablet:jobUpdated",source,job,IsOnDuty(source)); return IsOnDuty(source)
end)
