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

companyDebugEnabled = false
savedDebugPositions = {}
closestGasStationsForDebug = {}

local function DebugIdentifierPreview(value)
    if value == nil or value == false or value == "" or value == "none" then
        return "none"
    end
    local text = tostring(value)
    return string.sub(text, 1, 7)
end

if Config.AllowDebugCommand then
    RegisterCommand("fuelcompanydebug", function(source, args, rawCommand)
        if IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
            companyDebugEnabled = not companyDebugEnabled

            if companyDebugEnabled then
                ShowNotification("You enabled the debug")
            else
                ShowNotification("You disabled the debug")
            end
        else
            TriggerEvent("chat:addMessage", {
                args = {
                    "^1SYSTEM",
                    "Warning you do not have permission to open this command. You did not added the 'add_ace' or you dont have on your character 'add_principal'",
                },
            })
            TriggerEvent("chat:addMessage", {
                args = {
                    "^1SYSTEM",
                    "Second option is: Go to your 'Live Console' and type command /fuelgrantpermission [ID]",
                },
            })
        end
    end)

    RegisterCommand("fuelskindebug", function(source, args, rawCommand)
        if IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
            LoadPlayerJobSkin()
            print("Skin loaded! After 10 seconds your skin will be back to default you had before!")
            Wait(10000)
            LoadPlayerDefaultSkin()
        end
    end)
end

if Config.Debug then
    RegisterCommand("portme", function(source, args, rawCommand)
        -- FIX 3: matches the IsPlayerInGroup check already used by
        -- fuelcompanydebug/fuelskindebug above -- this teleport command had none
        if not IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
            return
        end
        local pumpPosition = Config.ShopList[args[1]].pumpPosition[tonumber(args[2])]
        SetEntityCoords(PlayerPedId(), pumpPosition.pos)
    end)

    RegisterCommand("fastport", function(source, args, rawCommand)
        -- FIX 3: see portme above
        if not IsPlayerInGroup(Config.CommandGroups.editor, "rcore_fuel.editor") then
            return
        end
        for shopId, shopData in pairs(Config.ShopList) do
            Wait(1500)
            SetEntityCoords(PlayerPedId(), shopData.blipPosition)
        end
    end)

    RegisterCommand("savepos", function(source, args, rawCommand)
        local coords = GetEntityCoords(PlayerPedId())
        table.insert(savedDebugPositions, coords)
        print("saved pos", coords)
    end)

    RegisterCommand("dumppos", function(source, args, rawCommand)
        dump(savedDebugPositions)
    end)

    CreateThread(function()
        local drawBossMenuDebug = false

        while true do
            local playerCoords = GetEntityCoords(PlayerPedId())
            Wait(0)

            if not drawBossMenuDebug then
                Wait(1000)
            end

            drawBossMenuDebug = false

            for shopId, shopData in pairs(Config.ShopList) do
                if #(playerCoords - shopData.companyMenuMarkerPos) < 30 then
                    drawBossMenuDebug = true

                    draw3DText(
                        shopData.companyMenuMarkerPos - vector3(0, 0, 0.2),
                        string.format("company ID: %s", shopId)
                    )

                    local playerIdentifier = GetPlayerIdentifier()
                    local ownerIdentifier = shopData.owner_identifier
                    draw3DText(
                        shopData.companyMenuMarkerPos - vector3(0, 0, 0.4),
                        string.format(
                            [[
Owner ID: %s...
Player identifier: %s...
Is match: %s]],
                            DebugIdentifierPreview(ownerIdentifier),
                            DebugIdentifierPreview(playerIdentifier),
                            ownerIdentifier ~= false and ownerIdentifier ~= nil and ownerIdentifier == playerIdentifier
                        )
                    )

                    if shopData.EnableSociety then
                        draw3DText(
                            shopData.companyMenuMarkerPos - vector3(0, 0, 1.2),
                            string.format(
                                [[
Needed job: '%s'
Player job: '%s']],
                                shopData.Job,
                                GetPlayerJobName()
                            )
                        )
                        draw3DText(
                            shopData.companyMenuMarkerPos - vector3(0, 0, 1.8),
                            string.format("Grade name: '%s' must be 'boss'", GetPlayerBossName())
                        )
                        draw3DText(
                            shopData.companyMenuMarkerPos - vector3(0, 0, 2.0),
                            string.format(
                                [[
EnableBuyingCompany: %s
Society enabled: %s]],
                                shopData.EnableBuyingCompany,
                                shopData.EnableSociety
                            )
                        )
                    else
                        draw3DText(
                            shopData.companyMenuMarkerPos - vector3(0, 0, 1.2),
                            string.format(
                                [[
EnableBuyingCompany: %s
Society enabled: %s]],
                                shopData.EnableBuyingCompany,
                                shopData.EnableSociety
                            )
                        )
                    end
                end
            end
        end
    end, "Debug for boss menu")
end

CreateThread(function()
    while true do
        Wait(1000)

        if companyDebugEnabled then
            local playerCoords = GetEntityCoords(PlayerPedId())
            closestGasStationsForDebug = {}

            for shopId, shopData in pairs(Config.ShopList) do
                if #(playerCoords - shopData.blipPosition) < 30 then
                    closestGasStationsForDebug[shopId] = {
                        blipPosition = shopData.blipPosition + vector3(0, 0, 2),
                    }
                end
            end
        else
            Wait(2000)
        end
    end
end, "closest pumps")

CreateThread(function()
    local waitTime = 1000

    while true do
        Wait(waitTime)

        if companyDebugEnabled or Config.Debug then
            waitTime = 1000
            local playerCoords = GetEntityCoords(PlayerPedId())

            for shopId, stationEntry in pairs(closestGasStationsForDebug) do
                if #(playerCoords - stationEntry.blipPosition) < 30 then
                    waitTime = 0
                    draw3DText(
                        stationEntry.blipPosition,
                        string.format("This gas station key is: %s", shopId)
                    )
                end
            end
        else
            waitTime = 2000
        end
    end
end, "closest companies for 3D text debug")
