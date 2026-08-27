if Config.Framework ~= "vrp" then return end

local function mappedJob(passport)
    local groups = vRP.UserGroups(passport) or {}
    for name, cfg in pairs(Config.VRP.Jobs) do
        local level = groups[name]
        if level then
            local hierarchy = vRP.Hierarchy(name) or {}
            level = tonumber(level) or 1
            local permissionGrade = math.max(0, #hierarchy - level)
            return name, level, cfg.label or name, hierarchy[level] or tostring(level), permissionGrade
        end
    end
    return Config.VRP.DefaultJob, 0, "Desempregado", "Desempregado", 0
end

function IsOnDuty(source)
    local id = vRP.Passport(source)
    if not id then return false end
    local name = mappedJob(id)
    if name == Config.VRP.DefaultJob then return true end
    return vRP.HasService(id, name) ~= false
end

function GetJob(source)
    local id = vRP.Passport(source)
    if not id then return { name = Config.VRP.DefaultJob, label = "Desempregado", grade = 0, permission_grade = 0, grade_label = "Desempregado" } end
    local name, level, label, gradeLabel, permissionGrade = mappedJob(id)
    return { name = name, label = label, grade = level, permission_grade = permissionGrade, grade_label = gradeLabel }
end

function GetJobGrades(jobs)
    if type(jobs) == "string" then jobs = { jobs } end
    local grades, labels = {}, {}
    for _, job in ipairs(jobs) do
        local hierarchy = vRP.Hierarchy(job) or {}
        grades[job], labels[job] = {}, (Config.VRP.Jobs[job] and Config.VRP.Jobs[job].label) or job
        for level, label in ipairs(hierarchy) do
            grades[job][#grades[job]+1] = { grade = level, label = label }
        end
    end
    return { grades = grades, labels = labels }
end

function GetEmployees(companies, accountsTable)
    local allowed = {}; for _, job in ipairs(companies) do allowed[job] = true end
    local employees = {}
    for job in pairs(allowed) do
        local permissions = vRP.GetSrvData("Permissions:" .. job, true) or {}
        for id, level in pairs(permissions) do
            local identity = vRP.Identity(tonumber(id))
            if identity then
                local account = MySQL.single.await(("SELECT callsign, avatar FROM %s WHERE id = ?"):format(accountsTable), { tostring(id) }) or {}
                employees[#employees+1] = {
                    id = tostring(id), callsign = account.callsign, avatar = account.avatar,
                    name = identity.Name .. " " .. identity.Lastname, job = job, rank = tonumber(level) or 1,
                    phoneNumber = GetPhoneNumberFromIdentifier(id)
                }
            end
        end
    end
    return employees
end

function GetOnDutyEmployees(jobs)
    local result = {}
    for passport, source in pairs(vRP.Players() or {}) do
        local job = GetJob(source)
        if jobs[job.name] and IsOnDuty(source) then
            result[#result+1] = { source = source, name = GetCharacterNameFromIdentifier(passport), rank = job.grade_label, identifier = tostring(passport) }
        end
    end
    return result
end

function GetIdentifiersWithJob(jobs)
    if type(jobs) == "string" then jobs = { jobs } end
    local seen, result = {}, {}
    for _, job in ipairs(jobs) do
        local permissions = vRP.GetSrvData("Permissions:" .. job, true) or {}
        for id in pairs(permissions) do if not seen[id] then seen[id] = true; result[#result+1] = tostring(id) end end
    end
    return result
end
RegisterCallback("vrp:getJobGrades", function(source, job)
    local data=GetJobGrades(job); return data.grades[job] or {}
end)
RegisterCallback("services:getEmployees", function(source, company) return GetEmployeeList(company) end)
