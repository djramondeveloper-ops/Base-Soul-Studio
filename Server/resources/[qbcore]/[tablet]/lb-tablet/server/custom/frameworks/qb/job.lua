if Config.Framework ~= "qb" then
    return
end

while not QB do
    Wait(0)
end

function IsOnDuty(source)
    local qPlayer = QB.Functions.GetPlayer(tonumber(source))

    if qPlayer?.PlayerData?.job then
        return qPlayer.PlayerData.job.onduty
    end

    return true
end

function GetJob(source)
    local qPlayer = QB.Functions.GetPlayer(tonumber(source))

    if not qPlayer then
        return {
            name = "unemployed",
            label = "Unemployed",
            grade = 0,
            grade_label = "Unemployed"
        }
    end

    local job = qPlayer.PlayerData.job

    return {
        name = job.name,
        label = job.label,
        grade = job.grade.level,
        grade_label = job.grade.name
    }
end

function GetJobGrades(jobs)
    if type(jobs) == "string" then
        jobs = { jobs }
    end

    local qbJobs = QB.Shared.Jobs
    local grades = {}
    local labels = {}

    for i = 1, #jobs do
        local job = jobs[i]
        local jobData = qbJobs[job]

        if not jobData then
            debugprint("Invalid job: " .. job)
            goto continue
        end

        grades[job] = {}
        labels[job] = jobData.label

        local amountGrades = 0

        for gradeLevel, gradeData in pairs(jobData.grades) do
            amountGrades += 1
            grades[job][amountGrades] = {
                grade = tonumber(gradeLevel),
                label = gradeData.name
            }
        end

        table.sort(grades[job], function(a, b)
            return a.grade < b.grade
        end)

        ::continue::
    end

    return {
        grades = grades,
        labels = labels
    }
end

function GetEmployees(companies, accountsTable)
    local query = ([[
        SELECT
            u.citizenid AS id,
            a.callsign,
            a.avatar,
            CONCAT(JSON_VALUE(u.charinfo, '$.firstname'), ' ', JSON_VALUE(u.charinfo, '$.lastname')) AS `name`,
            JSON_VALUE(u.job, '$.grade.level') AS rank,
            JSON_VALUE(u.job, '$.name') AS job
            %s
        FROM players u
        LEFT JOIN {ACCOUNTS_TABLE} a ON a.id = u.citizenid %s
        %s
        WHERE JSON_VALUE(u.job, '$.name') IN (?)
    ]]):format("%s", UsersCollate, "%s")

    query = query:gsub("{ACCOUNTS_TABLE}", accountsTable)

    if Config.LBPhone then
        local phoneConfig = GetPhoneConfig()

        if phoneConfig?.Item.Unique then
            query = query:format(
                ", p.phone_number AS phoneNumber",
                ("LEFT JOIN phone_last_phone p ON u.citizenid %s = p.id"):format(UsersCollate)
            )
        else
            query = query:format(
                ", p.phone_number AS phoneNumber",
                ("LEFT JOIN phone_phones p ON u.citizenid %s = p.id"):format(UsersCollate)
            )
        end
    else
        query = query:format("", "")
    end

    local employees = MySQL.query.await(query, { companies })

    for i = 1, #employees do
        employees[i].rank = tonumber(employees[i].rank)
    end

    return employees
end

function GetOnDutyEmployees(jobs)
    local employees = {}
    local players = QB.Functions.GetQBPlayers()

    for _, qPlayer in pairs(players) do
        local playerData = qPlayer and qPlayer.PlayerData

        if playerData?.job?.onduty and jobs[qPlayer.PlayerData.job.name] then
            employees[#employees+1] = {
                source = playerData.source,
                name = playerData.charinfo.firstname .. " " .. playerData.charinfo.lastname,
                rank = playerData.job.grade.name,
                identifier = playerData.citizenid
            }
        end
    end

    return employees
end

function GetIdentifiersWithJob(jobs)
    if type(jobs) == "string" then
        jobs = { jobs }
    end

    local identifiers = MySQL.query.await("SELECT citizenid FROM players WHERE JSON_VALUE(job, '$.name') IN (?)", { jobs })
    local result = {}

    for i = 1, #identifiers do
        result[i] = identifiers[i].citizenid
    end

    return result
end

AddEventHandler("QBCore:Server:OnJobUpdate", function(source, job)
    Wait(0)
    TriggerEvent("lb-tablet:jobUpdated", source, job.name, IsOnDuty(source))
end)
