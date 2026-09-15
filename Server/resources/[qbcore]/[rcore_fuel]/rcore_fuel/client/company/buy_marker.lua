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

local isBuyingCompany = false
local areCompanyMarkersInitialized = false
local lastOpenedCompanyConfig = nil
local lastOpenedCompanyId = nil
local selectedFuelTypeForSkipMission   = nil
function GetPropertyZoneLabel(position)
    local zoneName = GetNameOfZone(position.x, position.y, position.z)
    return GetLabelText(zoneName)
end

function IsSpawnAreaClearForMissionTruck(shopId)
    local shop = Config.ShopList and Config.ShopList[shopId]
    if not shop or not shop.tipTruckSpawnPosition or not shop.tipTruckSpawnPosition.pos then
        return false
    end
    return IsSpawnPointClear(shop.tipTruckSpawnPosition.pos, 4.0)
end

function GetPlayerOwnedCompanyCount()
    local playerIdentifier = GetPlayerIdentifier()
    local ownedCompanyCount = 0

    for _, shopData in pairs(Config.ShopList) do
        if shopData.owner_identifier == playerIdentifier then
            ownedCompanyCount = ownedCompanyCount + 1
        end
    end

    return ownedCompanyCount
end

function OpenLastCompanyMenu()
    if lastOpenedCompanyConfig and lastOpenedCompanyId then
        SetTimeout(1, function()
            OpenCompanyMenu_(lastOpenedCompanyConfig, lastOpenedCompanyId)
        end)
    end
end

function HandleCompanyMenuSelection(menuAction, menuItem, companyConfig, shopId)
    if menuAction == "money_management" then
        OpenMoneyManagementMenu(shopId)
    end

    if menuAction == "employee_item" then
        TriggerServerEvent("rcore_fuel:setEmployeeStatus", shopId, menuItem.status)

        if menuItem.status then
            ShowHelpNotification(_U("employee_item_open"), false, true, 10000)
        else
            ShowHelpNotification(_U("employee_item_close"), false, true, 10000)
        end
    end

    if menuAction == "boss_menu" then
        -- FIX 9: was firing all framework boss-menu events simultaneously regardless of
        -- which framework is active, causing duplicate/conflicting menus to open
        if Config.Framework.Active == 1 then
            -- ESX
            TriggerEvent("esx_society:openBossMenu", companyConfig.Job, function(_, menuOptions)
                if menuOptions and menuOptions.close then
                    menuOptions.close()
                end
            end, companyConfig.ESX_BossOption)
        elseif Config.Framework.Active == 2 then
            -- QBCore
            TriggerEvent("qb-bossmenu:client:OpenMenu")
            TriggerEvent("qb-bossmenu:client:openMenu")
        end

        -- mk_bossmenu is framework-agnostic, check independently
        if IsResourceOnServer("mk_bossmenu") then
            local canHire, canFire, canDeposit, canWithdraw, bossGrade, jobGrades = exports.mk_bossmenu:checkJob(companyConfig.Job)
            if canHire or canFire or canDeposit or canWithdraw then
                TriggerEvent("MK_BossMenu:Client:OpenBossMenu", {
                    Name       = companyConfig.Job,
                    CanHire    = canHire,
                    CanFire    = canFire,
                    CanDeposit = canDeposit,
                    CanWithdraw = canWithdraw,
                    Grade      = bossGrade,
                    Type       = "job",
                    JobGrades  = jobGrades,
                })
            end
        end
    end

    if menuAction == "sell_company" then
        if menuItem.status then
            OpenSellCompanyInputMenu({ price = companyConfig.price }, function(sellPrice)
                if sellPrice then
                    TriggerServerEvent("rcore_fuel:setSellStatus", shopId, true, sellPrice)
                    ShowHelpNotification(_U("gas_station_selling"), false, true, 10000)
                    Config.ShopList[shopId].for_sale = true
                else
                    Config.ShopList[shopId].for_sale = false
                    TriggerServerEvent("rcore_fuel:setSellStatus", shopId, false, sellPrice)
                end

                OpenLastCompanyMenu()
            end)
        else
            ShowHelpNotification(_U("gas_station_selling_canceled"), false, true, 10000)
            TriggerServerEvent("rcore_fuel:setSellStatus", shopId, false)
        end
    end

    if menuAction == "open/close_shop" then
        TriggerServerEvent("rcore_fuel:setOpenStatus", shopId, menuItem.status)

        if menuItem.status then
            ShowHelpNotification(_U("gas_station_open"), false, true, 10000)
        else
            ShowHelpNotification(_U("gas_station_close"), false, true, 10000)
        end
    end

    if menuAction == "change_price_fuel" then
        OpenGasInputMenu(menuItem, function(newPrice, fuelType)
            local maxLockedPrice = Config.LockedFuelPrice and Config.LockedFuelPrice[fuelType]

            if maxLockedPrice and newPrice > maxLockedPrice then
                ShowHelpNotification(_U("maximum_fuel_price", CommaValue(maxLockedPrice)), false, true, 10000)
                OpenLastCompanyMenu()
                return
            end

            TriggerServerEvent("rcore_fuel:setFuelPrice", shopId, newPrice, fuelType)
            if Config.ShopList[shopId] then
                if not Config.ShopList[shopId].gasPrices then
                    Config.ShopList[shopId].gasPrices = {}
                end
                Config.ShopList[shopId].gasPrices[fuelType] = math.floor(tonumber(newPrice))
            end
            OpenLastCompanyMenu()
        end)
    end

    if menuAction == "cancel_mission" then
        CreateMenuForCancelMission(shopId, function(confirmed)
            if confirmed then
                TriggerServerEvent("rcore_fuel:forceCancelMission", shopId)
                Config.ShopList[shopId].isMissionRunning = nil
            end

            OpenLastCompanyMenu()
        end)
    end

    if menuAction == "refuel_tankers" then
        ShowAllPossibleTypeFuels({
            shopIdentifier = shopId,
            gasPrices = companyConfig.gasPrices,
        }, function(selectedFuelType)
            if not selectedFuelType then
                OpenLastCompanyMenu()
                return
            end

            if IsSpawnAreaClearForMissionTruck(shopId) then
                -- FIX 6: guard nil capacity tables before indexing by fuelType
                local selMaxCap = (companyConfig.maxCapacity and companyConfig.maxCapacity[selectedFuelType]) or 0
                local selCurCap = (companyConfig.capacity and companyConfig.capacity[selectedFuelType]) or 0
                SelectLitersToMission({
                    maxCapacity = selMaxCap,
                    capacity = selCurCap,
                    fuelType = selectedFuelType,
                    enableSociety = companyConfig.EnableSociety == true,
                }, function(literSelection)
                    if literSelection == "full" then
                        ShowHelpNotification(_U("capacity_fuel_full"))
                        OpenLastCompanyMenu()
                    elseif Config.SkipMissionForFuelType[selectedFuelType] then
                        selectedFuelTypeForSkipMission = selectedFuelType

                        -- FIX 5: guard nil CompanyGasPrices entry before indexing .current
                        local pricePerLiter = (Config.CompanyGasPrices
                            and Config.CompanyGasPrices[selectedFuelType]
                            and Config.CompanyGasPrices[selectedFuelType].current) or 0
                        FinalizePaymentForNonMissionFuel({
                            fuelType = selectedFuelType,
                            money = pricePerLiter * literSelection.liters,
                        }, function(paymentConfirmed)
                            if paymentConfirmed then
                                TriggerServerEvent(
                                    "rcore_fuel:BuyFuelStock",
                                    shopId,
                                    selectedFuelTypeForSkipMission,
                                    literSelection.liters,
                                    literSelection.cashType or "cash"  -- cashType set by SelectLitersToMission
                                )
                            end

                            OpenLastCompanyMenu()
                        end)
                    else
                        callCallback("rcore_fuel:fetchPlayerNamesAround", function(nearbyPlayers)
                            if nearbyPlayers == false then
                                return
                            end

                            OpenPlayerList(function(playerSource, playerName)
                                TriggerServerEvent(
                                    "rcore_fuel:OwnerSelectedForRefuel",
                                    playerSource,
                                    playerName,
                                    shopId,
                                    literSelection.liters,
                                    selectedFuelType,
                                    literSelection.cashType
                                )
                                OpenLastCompanyMenu()
                            end, nearbyPlayers)
                        end, shopId)
                    end
                end)
            else
                local shop = Config.ShopList and Config.ShopList[shopId]
                local spawnPosition = shop and shop.tipTruckSpawnPosition and shop.tipTruckSpawnPosition.pos
                if spawnPosition then
                    CreateBlipMission(spawnPosition)
                    CreateMissionZone(spawnPosition, "tiptruck_not_clear", 5)
                end
                ShowNotification(_U("tiptruck_area_not_clear"))
            end
        end)
    end
end

function OpenCompanyMenu_(companyConfig, shopId)
    lastOpenedCompanyId = shopId
    lastOpenedCompanyConfig = companyConfig

    if isBuyingCompany then
        return
    end

    local playerIdentifier = GetPlayerIdentifier()
    local isOwner = companyConfig.owner_identifier == playerIdentifier
    local isSocietyBoss = companyConfig.EnableSociety and IsPlayerBossGrade(companyConfig.Job)

    if not isOwner and not isSocietyBoss then
        return
    end

    OpenCompanyMenu(function(menuAction, menuItem)
        HandleCompanyMenuSelection(menuAction, menuItem, companyConfig, shopId)
    end, shopId)
end

AddEventHandler("rcore_fuel:enterZone", function(zoneName)
    if zoneName == "tiptruck_not_clear" then
        DestroyBlipMission()
    end
end)

function SetupCompanyBuyMarker(shopId, shopData)
    local buyMarker = createMarker()
    buyMarker.setRenderDistance(10)
    buyMarker.setPosition(shopData.buyCompanyMarker or vector3(0, 0, 0))

    if not shopData.buyCompanyMarkerStyle then
        shopData.buyCompanyMarkerStyle = {}
    end

    buyMarker.setRotation(shopData.buyCompanyMarkerStyle.rotate or false)
    buyMarker.setFaceCamera(shopData.buyCompanyMarkerStyle.faceCamera or false)
    buyMarker.setType(shopData.buyCompanyMarkerStyle.type or 29)
    buyMarker.setScale(shopData.buyCompanyMarkerStyle.size or vector3(1.0, 1.0, 1.0))
    buyMarker.setInRadius(2.5)
    buyMarker.setColor(shopData.buyCompanyMarkerStyle.color or { r = 0, g = 255, b = 0, a = 100 })
    buyMarker.setKeys({ 38 })
    buyMarker.set3DTextOffset(vector3(0, 0, -0.5))
    buyMarker.set3DText(_U("company_price", CommaValue(shopData.price or 0)))

    buyMarker.on("enter", function()
        ShowHelpNotification(_U("interact_key"), false, true, 10000)
    end)

    buyMarker.on("leave", function()
        isBuyingCompany = false
        CloseAll()
    end)

    buyMarker.on("key", function()
        if isBuyingCompany then
            return
        end

        if shopData.owner_identifier == GetPlayerIdentifier() then
            ShowHelpNotification(_U("cant_buy_his_own"), false, true, 10000)
            return
        end

        OpenBuyMenu(function(choice, paymentType)
            if choice ~= "yes" then
                return
            end

            local maximumOwned = tonumber(Config.MaximumOwnedCompanyPerPlayer) or -1
            if maximumOwned > 0 and GetPlayerOwnedCompanyCount() >= maximumOwned then
                ShowNotification(_U("maximum_owned_companies", maximumOwned))
                return
            end

            isBuyingCompany = true

            callCallback("rcore_fuel:buyCompany", function(purchaseSucceeded)
                if purchaseSucceeded then
                    CreateThread(function()
                        DoScreenFadeOut(300)
                        Wait(350)
                        DoScreenFadeIn(300)
                        SetActiveRenderMarkers(false)

                        local camPos = (shopData.buyCompanyCameraPosition and shopData.buyCompanyCameraPosition.pos) or shopData.buyCompanyMarker or vector3(0, 0, 0)
                        local camRot = (shopData.buyCompanyCameraPosition and shopData.buyCompanyCameraPosition.rot) or vector3(0, 0, 0)
                        local purchaseCamera = CreateCamera(
                            camPos,
                            camRot
                        )

                        FreezePlayerControls(true)
                        purchaseCamera.startRendering()
                        Wait(500)

                        ShowFullscreenBonusNotify(
                            "",
                            _U("bought_property_title"),
                            _U("bought_property_desc", GetPropertyZoneLabel(shopData.buyCompanyMarker))
                        )

                        Wait(1750)
                        purchaseCamera.exitCameraSmoothly(800)
                        FreezePlayerControls(false)
                        isBuyingCompany = false
                        Wait(1000)
                        SetActiveRenderMarkers(true)
                    end, "rendering camera buy for company")
                else
                    ShowFullscreenBonusNotify(_U("bought_property_title_no_money"), "", "")
                    isBuyingCompany = false
                end
            end, paymentType, shopId)
        end, shopData.price)
    end)

    return buyMarker
end

function SetupCompanyBossMarker(shopId, shopData)
    local bossMarker = createMarker()

    bossMarker.on("enter", function()
        ShowHelpNotification(_U("interact_key"), false, true, 10000)
    end)

    bossMarker.on("leave", function()
        lastOpenedCompanyConfig = nil
        lastOpenedCompanyId = nil
        isBuyingCompany = false
        CloseAll()
    end)

    bossMarker.on("key", function()
        if IsAnyMenuOpen() then
            return
        end

        TriggerServerEvent("rcore_fuel:requestConfigChanges")
        OpenCompanyMenu_(shopData, shopId)
    end)

    bossMarker.setPosition(shopData.companyMenuMarkerPos)
    bossMarker.setTextColor({ r = 255, g = 255, b = 255, a = 255 })

    if not shopData.companyMenuMarkerStyle then
        shopData.companyMenuMarkerStyle = {}
    end

    bossMarker.setType(shopData.companyMenuMarkerStyle.type or 31)
    bossMarker.setRotation(shopData.companyMenuMarkerStyle.rotate ~= false)
    bossMarker.setFaceCamera(shopData.companyMenuMarkerStyle.faceCamera or false)
    bossMarker.setColor(shopData.companyMenuMarkerStyle.color or { r = 255, g = 255, b = 255, a = 100 })
    bossMarker.setScale(shopData.companyMenuMarkerStyle.size or vector3(1.0, 1.0, 1.0))
    bossMarker.setInRadius(2.5)
    bossMarker.setKeys({ 38 })

    return bossMarker
end

CreateThread(function()
    for shopId, shopData in pairs(Config.ShopList) do
        if Config.Debug then
            local buyDebugText = create3DText(string.format(
                [[
buying marker
Is buying enabled: %s
Shop ID: %s]],
                shopData.EnableBuyingCompany,
                shopId
            ))
            buyDebugText.setPosition(shopData.buyCompanyMarker)

            local bossDebugText = create3DText("Boss marker")
            bossDebugText.setPosition(shopData.companyMenuMarkerPos)
        end

        if shopData.EnableBuyingCompany then
            shopData.buyMarkerModal = SetupCompanyBuyMarker(shopId, shopData)
            shopData.bossMarkerModal = SetupCompanyBossMarker(shopId, shopData)
        end
    end

    areCompanyMarkersInitialized = true
end, "Thread for 3D Markers for buying company")

function RefreshCompanyMarkers()
    for _, shopData in pairs(Config.ShopList or {}) do
        if shopData.EnableBuyingCompany then
            if shopData.buyMarkerModal then
                if shopData.for_sale then
                    shopData.buyMarkerModal.set3DText(_U("company_price", CommaValue(shopData.price or 0)))
                    shopData.buyMarkerModal.render()
                else
                    shopData.buyMarkerModal.stopRender()
                end
            end

            local playerIdentifier = GetPlayerIdentifier()
            local canAccessBossMenu = shopData.owner_identifier == playerIdentifier
                or (shopData.EnableSociety and IsAtJob(shopData.Job) and IsPlayerBossGrade(shopData.Job))

            if shopData.bossMarkerModal then
                if canAccessBossMenu then
                    shopData.bossMarkerModal.render()
                else
                    shopData.bossMarkerModal.stopRender()
                end
            end
        end
    end

    RefreshBlips()
end

RegisterNetEvent("rcore_fuel:PlayerJobUpdated", function()
    RefreshCompanyMarkers()
end)

RegisterNetEvent("rcore_fuel:dataUpdated", function()
    while not areCompanyMarkersInitialized do
        Wait(33)
    end

    RefreshCompanyMarkers()
end)
