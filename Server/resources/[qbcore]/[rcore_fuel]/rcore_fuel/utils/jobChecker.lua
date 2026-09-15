--[[
========================================================================================
 ██████╗ ██╗     ███████╗ █████╗ ███╗   ██╗███████╗██████╗ 
██╔════╝ ██║     ██╔════╝██╔══██╗████╗  ██║██╔════╝██╔══██╗
██║      ██║     █████╗  ███████║██╔██╗ ██║█████╗  ██║  ██║
██║      ██║     ██╔══╝  ██╔══██║██║╚██╗██║██╔══╝  ██║  ██║
╚██████╗ ███████╗███████╗██║  ██║██║ ╚████║███████╗██████╔╝
 ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 

                 ██████╗ ██╗   ██╗
                 ██╔══██╗╚██╗ ██╔╝
                 ██████╔╝ ╚████╔╝ 
                 ██╔══██╗  ╚██╔╝  
                 ██████╔╝   ██║   
                 ╚═════╝    ╚═╝   

██╗  ██╗ █████╗ ███████╗██╗███╗   ███╗
██║  ██║██╔══██╗╚══███╔╝██║████╗ ████║
███████║███████║  ███╔╝ ██║██╔████╔██║
██╔══██║██╔══██║ ███╔╝  ██║██║╚██╔╝██║
██║  ██║██║  ██║███████╗██║██║ ╚═╝ ██║
╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚═╝     ╚═╝

██╗  ██╗███████╗██████╗ ██████╗ ███████╗██████╗  █████╗ 
██║  ██║██╔════╝██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔══██╗
███████║█████╗  ██████╔╝██████╔╝█████╗  ██████╔╝███████║
██╔══██║██╔══╝  ██╔══██╗██╔══██╗██╔══╝  ██╔══██╗██╔══██║
██║  ██║███████╗██║  ██║██║  ██║███████╗██║  ██║██║  ██║
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝
========================================================================================
--]]

local PlayerData = {}

function UpdatePlayerDataForQBCore()
    if not (SharedObject and SharedObject.Functions and SharedObject.Functions.GetPlayerData) then
        return
    end

    local pData = SharedObject.Functions.GetPlayerData()
    if not pData then return end

    local jobName = "none"
    local gradeName = "none"

    if pData.job then
        jobName = pData.job.name or "none"

        if pData.job.grade then
            gradeName = pData.job.grade.name or tostring(pData.job.grade.level or "none")
        end
    end

    PlayerData = {
        job = {
            name = jobName,
            grade_name = gradeName,
        }
    }

    TriggerEvent("rcore_fuel:PlayerJobUpdated")
end

OnObjectLoaded(function()
    if SharedObject and SharedObject.IsPlayerLoaded then
        if SharedObject.IsPlayerLoaded() then
            PlayerData = SharedObject.GetPlayerData and SharedObject.GetPlayerData() or {}
            TriggerEvent("rcore_fuel:PlayerJobUpdated")
        end
    end

    if SharedObject and SharedObject.Functions and SharedObject.Functions.GetPlayerData then
        UpdatePlayerDataForQBCore()
    end
end)

RegisterNetEvent(Config.Events.QBCore.playerLoaded, function()
    UpdatePlayerDataForQBCore()
end)

RegisterNetEvent(Config.Events.QBCore.jobUpdate, function()
    UpdatePlayerDataForQBCore()
end)

RegisterNetEvent(Config.Events.ESX.playerLoaded, function(xPlayer)
    PlayerData = xPlayer
    TriggerEvent("rcore_fuel:PlayerJobUpdated")
end)

RegisterNetEvent(Config.Events.ESX.jobUpdate, function(job)
    PlayerData.job = job
    TriggerEvent("rcore_fuel:PlayerJobUpdated")
end)

function IsPlayerBossGrade(name)
    if Config.Framework.Active == Framework.ESX then
        return IsAtJob(name, "boss")
    end

    if Config.Framework.Active == Framework.QBCORE then
        if not (SharedObject and SharedObject.Functions and SharedObject.Functions.GetPlayerData) then
            return false
        end
        local pData = SharedObject.Functions.GetPlayerData()
        if not (pData and pData.job) then return false end
        if not IsAtJob(name, "*") then return false end
        -- FIX 4a: QBCore stores isboss on job.isboss (newer builds) or in the shared jobs table
        if pData.job.isboss ~= nil then return pData.job.isboss == true end
        -- fallback: check grade against QBCore.Shared.Jobs
        if SharedObject.Shared and SharedObject.Shared.Jobs and pData.job.grade then
            local jobConfig = SharedObject.Shared.Jobs[name]
            if jobConfig and jobConfig.grades then
                for gradeLevel, gradeData in pairs(jobConfig.grades) do
                    if gradeData.isboss and tonumber(gradeLevel) == pData.job.grade.level then
                        return true
                    end
                end
            end
        end
        return false
    end
    return false
end

function GetPlayerBossName()
    if Config.Framework.Active == Framework.ESX then
        return (PlayerData and PlayerData.job and PlayerData.job.grade_name) or "unknown"
    end

    if Config.Framework.Active == Framework.QBCORE then
        if not (SharedObject and SharedObject.Functions and SharedObject.Functions.GetPlayerData) then
            return "unknown"
        end
        local pData = SharedObject.Functions.GetPlayerData()
        -- FIX 4b: return the actual grade name, not a debug string
        if pData and pData.job and pData.job.grade then
            return pData.job.grade.name or tostring(pData.job.grade.level)
        end
        return "unknown"
    end
    return "No framework detected"
end

function GetPlayerJobName()
    if not PlayerData or not PlayerData.job then
        return "none"
    end
    return PlayerData.job.name
end

function IsAtJob(name, grade)
    if not PlayerData or not PlayerData.job then
        print("ERROR", "the job for ESX/QBCore is nil value please check if your events are correct.")
        return true
    end

    if grade and grade == "*" and PlayerData.job.name == name then
        return true
    end
    if grade then
        return PlayerData.job.name == name and PlayerData.job.grade_name == grade
    end
    return PlayerData.job.name == name
end
