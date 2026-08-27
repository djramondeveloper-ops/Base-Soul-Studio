if Config.Framework ~= "standalone" then
    return
end

debugprint("Using standalone/registration framework")

while not NetworkIsSessionStarted() do
    Wait(500)
end

TriggerServerEvent("lb-tablet:frameworkLoaded")

function FormatVehicle(vehicle)
    if vehicle.name then
        vehicle.owner = {
            name = vehicle.name,
            identifier = vehicle.owner
        }

        vehicle.name = nil
    end

    vehicle.color = vehicle.color and {
        label = "",
        hex = vehicle.color
    }

    return vehicle
end

function IsAdmin()
    return AwaitCallback("isAdmin")
end

function HasTabletItem()
    if not Config.Item.Require then
        return true
    end

    if GetResourceState("ox_inventory") == "started" then
        return (exports.ox_inventory:Search("count", Config.Item.Name) or 0) > 0
    end

    return false
end

function GetJob()
    return "unemployed"
end

function IsOnDuty()
    return true
end

function GetJobGrade()
    return 0
end



function GetCompanyData()
    local companyData = {
        job = "unemployed",
        jobLabel = "Unemployed",
        isBoss = false,
        duty = true,
        receiveCalls = GetCompanyCallsStatus and GetCompanyCallsStatus()
    }


    return companyData
end

function DepositMoney(amount)
    return 0
end

function WithdrawMoney(amount)
    return 0
end

function HireEmployee(source)
    return false
end

function FireEmployee(identifier)
    return false
end

function SetGrade(identifier, newGrade)
    return false
end

function ToggleDuty()
    TriggerServerEvent("tablet:services:toggleDuty")
end

function GetWeaponsList()
    return Weapons
end


FrameworkLoaded = true
