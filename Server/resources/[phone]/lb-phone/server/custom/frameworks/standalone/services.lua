if Config.Framework ~= "standalone" then
    return
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP BRIDGE: Services / Jobs Integration
-----------------------------------------------------------------------------------------------------------------------------------------
local vRP = {}
local vRPReady = false

CreateThread(function()
    local utils = LoadResourceFile("vrp", "lib/Utils.lua")
    if not utils then return end

    load(utils)()

    local Proxy = module("vrp", "lib/Proxy")
    if not Proxy then return end

    vRP = Proxy.getInterface("vRP")
    vRPReady = true
end)

local function WaitForVRP()
    while not vRPReady do
        Wait(100)
    end
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- Mapeamento de jobs do lb-phone para grupos vRP
-----------------------------------------------------------------------------------------------------------------------------------------
local jobMapping = Config.VRPJobs or {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOB / DUTY CONTEXT (Seoul vRP -> LB Phone)
-----------------------------------------------------------------------------------------------------------------------------------------
local function GetCompanyLabel(job)
    for i = 1, #(Config.Companies.Services or {}) do
        local company = Config.Companies.Services[i]
        if company.job == job then
            return company.name or job
        end
    end

    return job == "unemployed" and "Desempregado" or job
end

local function GetServiceContext(source)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then
        return {
            job = "unemployed",
            jobLabel = "Desempregado",
            permission = nil,
            grade = 0,
            gradeLabel = "Desempregado",
            isBoss = false,
            duty = false
        }
    end

    local groups = vRP.UserGroups(Passport) or {}

    for job, permissions in pairs(jobMapping) do
        for _, permission in ipairs(permissions) do
            local level = tonumber(groups[permission])

            if level then
                local hierarchy = vRP.Hierarchy(permission) or {}
                local permissionGrade = math.max(0, #hierarchy - level)

                return {
                    job = job,
                    jobLabel = GetCompanyLabel(job),
                    permission = permission,
                    grade = permissionGrade,
                    vrpGrade = level,
                    gradeLabel = hierarchy[level] or tostring(level),
                    isBoss = level <= 1,
                    duty = vRP.HasService(Passport, permission) ~= false
                }
            end
        end
    end

    return {
        job = "unemployed",
        jobLabel = "Desempregado",
        permission = nil,
        grade = 0,
        gradeLabel = "Desempregado",
        isBoss = false,
        duty = false
    }
end

---@param source number
---@return string
function GetJob(source)
    return GetServiceContext(source).job
end

RegisterCallback("vrp:getServiceContext", function(source)
    return GetServiceContext(source)
end)

RegisterCallback("vrp:toggleServiceDuty", function(source)
    WaitForVRP()

    local Passport = vRP.Passport(source)
    if not Passport then return GetServiceContext(source) end

    local context = GetServiceContext(source)
    if not context.permission then return context end

    vRP.ServiceToggle(source, Passport, context.permission, true)
    Wait(50)

    return GetServiceContext(source)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET ALL EMPLOYEES (todos os jogadores de um cargo, incluindo offline)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param job string
---@return { firstname: string, lastname: string, grade: string, number: string }[] employees
function GetAllEmployees(job)
    WaitForVRP()

    local permissions = jobMapping[job]
    if not permissions then
        return {}
    end

    local employees = {}
    local seen = {}

    for _, permission in ipairs(permissions) do
        local data = vRP.DataGroups(permission)
        if data then
            local hierarchy = vRP.Hierarchy(permission)

            for passport_str, level in pairs(data) do
                if not seen[passport_str] then
                    seen[passport_str] = true

                    local Passport = tonumber(passport_str)
                    local firstName, lastName = "", ""
                    local phoneNumber = ""

                    if Passport then
                        local Identity = vRP.Identity(Passport)
                        if Identity then
                            firstName = Identity.Name or ""
                            lastName = Identity.Lastname or ""
                        end
                    end

                    -- Compatibilidade: formato atual vrp:<Passport> e legado pandora:<Passport>.
                    local identifier = "vrp:" .. passport_str
                    local legacyIdentifier = "pandora:" .. passport_str
                    local bareIdentifier = passport_str
                    local number = MySQL.scalar.await([[
                        SELECT phone_number
                        FROM phone_phones
                        WHERE owner_id IN (?, ?, ?) OR id IN (?, ?, ?)
                        ORDER BY CASE WHEN owner_id = ? OR id = ? THEN 0 ELSE 1 END, last_seen DESC
                        LIMIT 1
                    ]], {
                        identifier, legacyIdentifier, bareIdentifier,
                        identifier, legacyIdentifier, bareIdentifier,
                        identifier, identifier
                    })

                    employees[#employees + 1] = {
                        firstname = firstName,
                        lastname = lastName,
                        grade = hierarchy[level] or tostring(level),
                        number = number or ""
                    }
                end
            end
        end
    end

    return employees
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- GET EMPLOYEES (jogadores online com job específico)
-----------------------------------------------------------------------------------------------------------------------------------------
---@param job string
---@return number[] employees
function GetEmployees(job)
    WaitForVRP()

    local permissions = jobMapping[job]
    if not permissions then
        return {}
    end

    local employees = {}
    local seen = {}

    for _, permission in ipairs(permissions) do
        local players = vRP.Players()
        if players then
            for passport, src in pairs(players) do
                if src and not seen[src] then
                    local passport_str = tostring(passport)
                    if vRP.HasService(passport, permission) then
                        seen[src] = true
                        employees[#employees + 1] = src
                    end
                end
            end
        end
    end

    return employees
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- REFRESH COMPANIES (atualizar status open das empresas)
-----------------------------------------------------------------------------------------------------------------------------------------
function RefreshCompanies()
    WaitForVRP()

    for i = 1, #Config.Companies.Services do
        local jobData = Config.Companies.Services[i]
        local onlineEmployees = GetEmployees(jobData.job)

        jobData.open = #onlineEmployees > 0
    end
end
