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

local function FiniteNumber(value)
    local n = tonumber(value)
    if not n or n ~= n or n == math.huge or n == -math.huge then return nil end
    return n
end

local _sessionSeed = "5076c59ea539de616e0e398f08bab4ac"
local ValidFuelTypeValues = nil
local function IsValidFuelType(fuelType)
    if not ValidFuelTypeValues then
        ValidFuelTypeValues = {}
        for _, value in pairs(FuelType) do
            ValidFuelTypeValues[value] = true
        end
    end
    return ValidFuelTypeValues[fuelType] == true
end

ActiveFuelingSessions = {}
ActiveRefiningPrices = {}
WrongFuelVehicleEvidence = WrongFuelVehicleEvidence or {}

local function GetServerExpectedFuelType(vehicle)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) then return nil end
    local model = GetEntityModel(vehicle)
    if not model or model == 0 then return nil end

    -- Model-specific overrides are an array on the server (the client later
    -- converts them to a hash table), but support either representation.
    local configured = Config.VehicleFuelType or {}
    if configured[1] ~= nil then
        for _, entry in ipairs(configured) do
            if type(entry) == "table" and entry.model and entry.fuelType then
                local ok, hash = pcall(GetHashKey, entry.model)
                if ok and hash == model then return entry.fuelType end
            end
        end
    elseif configured[model] ~= nil then
        return configured[model]
    end

    -- GET_VEHICLE_CLASS is a game/client native and is not guaranteed to exist
    -- in the FXServer runtime. Previously we returned nil when it was unavailable,
    -- so the server never recorded wrong-fuel evidence even though the client did.
    -- If a server build exposes it, still honor class-specific overrides; otherwise
    -- safely continue to vehicle-type/default rules instead of abandoning the check.
    local vehicleClass = nil
    if type(GetVehicleClass) == "function" then
        local okClass, classValue = pcall(GetVehicleClass, vehicle)
        if okClass then vehicleClass = tonumber(classValue) end
    end

    local classTypes = vehicleClass ~= nil and Config.SpecificFuelTypePerVehicleClass
        and Config.SpecificFuelTypePerVehicleClass[vehicleClass]
    if type(classTypes) == "table" and #classTypes > 0 then
        return classTypes[(model % #classTypes) + 1]
    end

    -- GET_VEHICLE_TYPE is available server-side in OneSync/FXServer and lets us
    -- preserve special aircraft fuel rules without relying on GET_VEHICLE_CLASS.
    local vehicleTypeEnum = nil
    if type(GetVehicleType) == "function" then
        local okType, rawType = pcall(GetVehicleType, vehicle)
        if okType and rawType ~= nil then
            local vehicleType = string.lower(tostring(rawType))
            if vehicleType == "heli" or vehicleType == "helicopter" then
                vehicleTypeEnum = VehicleTypes.HELI
            elseif vehicleType == "plane" then
                vehicleTypeEnum = VehicleTypes.PLANE
            elseif vehicleType == "boat" or vehicleType == "submarine" then
                vehicleTypeEnum = VehicleTypes.BOAT
            elseif vehicleType == "bike" then
                vehicleTypeEnum = VehicleTypes.BIKE
            elseif vehicleType == "bicycle" then
                vehicleTypeEnum = VehicleTypes.BICYCLE
            elseif vehicleType == "train" then
                vehicleTypeEnum = VehicleTypes.TRAIN
            elseif vehicleType == "automobile" then
                vehicleTypeEnum = VehicleTypes.CAR
            end
        end
    end

    -- Older server builds may not expose the CFX vehicle-type getter. If class was
    -- available, keep the old aircraft mapping as a fallback.
    if not vehicleTypeEnum and vehicleClass ~= nil then
        if vehicleClass == 15 then vehicleTypeEnum = VehicleTypes.HELI
        elseif vehicleClass == 16 then vehicleTypeEnum = VehicleTypes.PLANE
        elseif vehicleClass == 14 then vehicleTypeEnum = VehicleTypes.BOAT
        elseif vehicleClass == 8 then vehicleTypeEnum = VehicleTypes.BIKE
        elseif vehicleClass == 13 then vehicleTypeEnum = VehicleTypes.BICYCLE end
    end

    local typeTypes = vehicleTypeEnum and Config.RandomFuelTypesPerVehicleType
        and Config.RandomFuelTypesPerVehicleType[vehicleTypeEnum]
    if type(typeTypes) == "table" and #typeTypes > 0 then
        return typeTypes[(model % #typeTypes) + 1]
    end

    -- This is also the client's final fallback, so normal cars remain perfectly
    -- deterministic between client and server even when class natives are absent.
    local defaults = Config.DefaultRandomFuelTypes or {}
    if #defaults > 0 then return defaults[(model % #defaults) + 1] end
    return FuelType.NATURAL or FuelType.DIESEL or 1
end

-- Keep client-facing "none"/empty owner sentinels out of server authority checks.
local function NormalizeOwnerIdentifier(identifier)
    if identifier == nil or identifier == false or identifier == "" or identifier == "none" then
        return nil
    end
    return identifier
end

local function NormalizeFuelIndexedTable(value, fallback)
    if type(value) ~= "table" then return fallback end
    local normalized = {}
    for key, entry in pairs(value) do
        normalized[tonumber(key) or key] = entry
    end
    return normalized
end

local function DecodeFuelIndexedJson(value, fallback, shopId, fieldName)
    if type(value) ~= "string" or value == "" then return fallback end
    local ok, decoded = pcall(json.decode, value)
    if not ok or type(decoded) ~= "table" then
        print(string.format("[rcore_fuel] Invalid %s JSON for shop %s; keeping configured defaults.", tostring(fieldName), tostring(shopId)))
        return fallback
    end
    return NormalizeFuelIndexedTable(decoded, fallback)
end

-- Pump occupancy must be authoritative on the server. Client Config state is only
-- presentation state and can arrive late or be forged by a modified client.
local PumpLocks = {}
local JerryPourRateLimit = {}
-- Prevent config sync spam from repeatedly rebuilding client state.
local ConfigRequestRateLimit = {}
local NearbyPlayersRateLimit = {}
local FuelStartRateLimit = {}
local PumpSoundRateLimit = {}
local JerryPourPending = {}
-- Company rows are loaded asynchronously from SQL. Clients can request their
-- config immediately after the resource starts, so do not send half-initialised
-- company state before the database pass has completed.
local CompanyDataReady = false
local PUMP_RESERVATION_TIMEOUT_MS = 7000

-- Serialize persistence for each company row. Several independent gameplay paths
-- mutate the same JSON/money fields (fuel ticks, stock purchases, owner actions), and
-- unordered async UPDATE completion can otherwise leave SQL with an older snapshot.
local CompanyPersistState = {}

local function RunCompanyPersist(shopId)
    local state = CompanyPersistState[shopId]
    local shopData = Config.ShopList and Config.ShopList[shopId]
    if not state or not shopData or not CompanyDataReady then
        if state then state.inFlight = false end
        return
    end

    state.inFlight = true
    state.dirty = false

    local params = {
        ["@owner"] = NormalizeOwnerIdentifier(shopData.owner_identifier),
        ["@price"] = math.max(0, math.floor(tonumber(shopData.price) or 100000)),
        ["@for_sale"] = shopData.for_sale == true and 1 or 0,
        ["@open"] = shopData.open ~= false and 1 or 0,
        ["@money"] = math.max(0, math.floor(tonumber(shopData.money) or 0)),
        ["@fuel_only_employee"] = shopData.fuel_only_employee == true and 1 or 0,
        ["@gasPrices"] = json.encode(shopData.gasPrices or {}),
        ["@capacity"] = json.encode(shopData.capacity or {}),
        ["@shopId"] = shopId,
    }

    MySQL.Async.execute([[
        UPDATE rcore_fuel_companies
        SET owner_identifier = @owner,
            price = @price,
            for_sale = @for_sale,
            open = @open,
            money = @money,
            fuel_only_employee = @fuel_only_employee,
            gasPrices = @gasPrices,
            capacity = @capacity
        WHERE shopId = @shopId
    ]], params, function()
        state.inFlight = false
        if state.dirty then
            RunCompanyPersist(shopId)
        end
    end)
end

function PersistCompanyNow(shopId)
    if not CompanyDataReady or not shopId or not Config.ShopList or not Config.ShopList[shopId] then
        return false
    end

    local state = CompanyPersistState[shopId]
    if not state then
        state = { inFlight = false, dirty = false }
        CompanyPersistState[shopId] = state
    end
    state.dirty = true
    if not state.inFlight then
        RunCompanyPersist(shopId)
    end
    return true
end

local function BuildCompanyConfigChanges()
    local changes = {}
    for shopId, shopData in pairs(Config.ShopList or {}) do
        changes[shopId] = {
            -- nil fields disappear during network serialization. false is an
            -- explicit "unowned" sentinel on the client.
            owner_identifier   = NormalizeOwnerIdentifier(shopData.owner_identifier) or false,
            price              = shopData.price,
            for_sale           = shopData.for_sale == true,
            open               = shopData.open ~= false,
            money              = shopData.money,
            fuel_only_employee = shopData.fuel_only_employee == true,
            gasPrices          = shopData.gasPrices,
            capacity           = shopData.capacity,
            isMissionRunning   = shopData.isMissionRunning or false
        }
    end
    return changes
end

local function SendCompanyConfigChanges(target)
    TriggerClientEvent("rcore_fuel:updateConfig", target, BuildCompanyConfigChanges())
end

-- Shared with server/company/company.lua so purchase callbacks cannot run against
-- config defaults before the SQL ownership/listing state has loaded.
function IsRCoreFuelCompanyDataReady()
    return CompanyDataReady == true
end

local function GetPumpLockBucket(shopId, dispenserIndex, create)
    if not PumpLocks[shopId] then
        if not create then return nil end
        PumpLocks[shopId] = {}
    end
    if not PumpLocks[shopId][dispenserIndex] then
        if not create then return nil end
        PumpLocks[shopId][dispenserIndex] = {}
    end
    return PumpLocks[shopId][dispenserIndex]
end

local function GetValidDispenser(shopId, dispenserIndex)
    local shopData = shopId and Config.ShopList and Config.ShopList[shopId]
    local numericIndex = FiniteNumber(dispenserIndex)
    if numericIndex then dispenserIndex = math.floor(numericIndex) end
    local dispenserData = shopData and shopData.pumpPosition and shopData.pumpPosition[dispenserIndex]
    return shopData, dispenserIndex, dispenserData
end

local function IsPlayerNearPosition(src, position, maxDistance)
    if not position then return false end
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end
    return #(GetEntityCoords(ped) - position) <= (maxDistance or 8.0)
end

local function PlayerHasJerryCan(src)
    local ped = GetPlayerPed(src)
    if not ped or ped == 0 then return false end

    local okWeapon, selectedWeapon = pcall(function() return GetSelectedPedWeapon(ped) end)
    if okWeapon and selectedWeapon == GetHashKey("WEAPON_PETROLCAN") then
        return true
    end

    if InventoryBridge then
        local okItem, ownsItem = pcall(function()
            return InventoryBridge.HasItem(src, "weapon_petrolcan", 1)
        end)
        if okItem and ownsItem == true then return true end
    end

    return false
end

-- Resolve one server-verifiable petrol-can inventory entry. OX and CORE are the
-- two integrations in this resource that expose enough metadata server-side to make
-- jerry-can liters authoritative instead of trusting client ammo/quality state.
local function GetVerifiedJerryMetadataState(src, weaponId, itemId)
    local litersSize = math.max(1, tonumber(Config.JerryCanLitersSize) or 20)

    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    if invSystem == Inventory.OX and GetResourceState("ox_inventory") == "started" then
        local slot = FiniteNumber(itemId) or FiniteNumber(weaponId)
        if not slot then return nil end
        slot = math.floor(slot)
        if slot < 1 then return nil end

        local ok, item = pcall(function() return exports.ox_inventory:GetSlot(src, slot) end)
        if not ok or type(item) ~= "table" then return nil end
        local itemName = string.lower(tostring(item.name or ""))
        if itemName ~= "weapon_petrolcan" and itemName ~= "weapon_petrolcan_empty" then return nil end

        local rawMetadata = type(item.metadata) == "table" and item.metadata or {}
        -- Build a safe, flat copy of the metadata containing only the fields this
        -- resource actually needs. ox_inventory metadata can be a reactive/proxy
        -- table backed by statebags whose internal metatables contain circular
        -- references. Storing or iterating the raw proxy crashes FiveM's msgpack
        -- serialization with "maximum table nesting depth exceeded".
        local metadata = {}
        if rawMetadata.ammo ~= nil then metadata.ammo = tonumber(rawMetadata.ammo) end
        if rawMetadata.durability ~= nil then metadata.durability = tonumber(rawMetadata.durability) end
        if rawMetadata.serial ~= nil then metadata.serial = tostring(rawMetadata.serial) end
        if type(rawMetadata.components) == "table" then
            metadata.components = {}
            for i, v in ipairs(rawMetadata.components) do metadata.components[i] = v end
        end
        if rawMetadata.registered ~= nil then metadata.registered = rawMetadata.registered end
        -- In ox_inventory, petrol cans store fuel as a percentage (0..100) in both
        -- metadata.ammo and metadata.durability. If an older script or custom give
        -- command wrote GTA native units (> 100 up to 4500), normalize down to 0..100.
        local rawAmmo = tonumber(metadata.ammo)
        local rawDurability = tonumber(metadata.durability)
        if rawAmmo ~= nil and rawAmmo > 100 then
            rawAmmo = math.max(0, math.min(100, math.floor((rawAmmo / 4500) * 100)))
        end
        if rawDurability ~= nil and rawDurability > 100 then
            rawDurability = math.max(0, math.min(100, math.floor(rawDurability)))
        end

        local level = nil
        -- If neither field exists on a freshly acquired can, initialize to full
        if rawAmmo == nil and rawDurability == nil then
            level = (Config.JerryCanStartsFull ~= false) and 100 or 0
        elseif rawAmmo ~= nil and rawDurability ~= nil then
            -- If one field is 0 while the other has a positive fuel reading (common when weapons
            -- are spawned with default 0 ammo but 100% durability), take the positive value.
            if rawAmmo > 0 and rawDurability > 0 then
                level = math.min(rawAmmo, rawDurability)
            else
                level = math.max(rawAmmo, rawDurability)
            end
        elseif rawAmmo ~= nil then
            level = rawAmmo
        elseif rawDurability ~= nil then
            level = rawDurability
        end

        level = math.max(0, math.min(100, level or 0))
        metadata.ammo = level
        metadata.durability = level

        return {
            backend = "ox",
            key = "ox:" .. tostring(slot),
            weaponId = slot,
            itemId = slot,
            metadata = metadata,
            level = level,
            maxLevel = 100,
            perLiter = 100 / litersSize,
        }
    end

    if invSystem == Inventory.CORE and GetResourceState("core_inventory") == "started" then
        local rawTarget = itemId ~= nil and itemId or weaponId
        if rawTarget == nil then return nil end
        local targetId = tostring(rawTarget)
        if targetId == "" then return nil end

        local items = nil
        local okItems, result = pcall(function()
            return exports["core_inventory"]:getItems(src, "weapon_petrolcan")
        end)
        if okItems and type(result) == "table" then
            items = result
        else
            okItems, result = pcall(function()
                return exports["core_inventory"]:GetItems(src, "weapon_petrolcan")
            end)
            if okItems and type(result) == "table" then items = result end
        end
        if not items then return nil end

        for key, item in pairs(items) do
            if type(item) == "table" then
                local candidates = {
                    key, item.id, item.slot, item.uniqueId, item.unique_id,
                    item.itemId, item.item_id
                }
                local matched = false
                -- candidates is intentionally sparse (inventory versions expose
                -- different identifier fields), so pairs() is required: ipairs()
                -- would stop at the first nil hole and miss later valid ids/slots.
                for _, candidate in pairs(candidates) do
                    if candidate ~= nil and tostring(candidate) == targetId then
                        matched = true
                        break
                    end
                end

                if matched then
                    local metadata = type(item.metadata) == "table" and item.metadata or {}
                    local level = math.max(0, math.min(4500, tonumber(metadata.ammo) or 0))
                    local canonical = item.id or item.uniqueId or item.unique_id or item.itemId
                        or item.item_id or item.slot or key
                    return {
                        backend = "core",
                        key = "core:" .. tostring(canonical),
                        weaponId = weaponId,
                        itemId = itemId,
                        metadata = metadata,
                        level = level,
                        maxLevel = 4500,
                        perLiter = 4500 / litersSize,
                    }
                end
            end
        end
    end

    return nil
end

local function PumpLockBelongsToSource(lock, src)
    if not lock or tonumber(lock.source) ~= tonumber(src) then return false end
    if lock.ownerIdentifier then
        return Framework.GetPlayerIdentifier(src) == lock.ownerIdentifier
    end
    return true
end

local function SessionBelongsToSource(session, src)
    if not session then return false end
    if session.playerIdentifier then
        return Framework.GetPlayerIdentifier(src) == session.playerIdentifier
    end
    return true
end

local function FuelBillKey(identifier)
    return "fuel_bill:v1:" .. identifier
end

-- KVP writes are synchronous on FXServer. Save only durable billing fields;
-- entity IDs, pump locks and active dispensing never survive a reconnect.
local function SaveFuelBill(session, status)
    if session.secureLivePayment or (session.cost or 0) <= 0 then return true end
    if not session.playerIdentifier then return false end
    local encoded = json.encode({version = 1, status = status or "unpaid",
        playerIdentifier = session.playerIdentifier, cost = session.cost,
        litersTanked = session.litersTanked, pricePerLiter = session.pricePerLiter,
        fuelType = session.fuelType, shopId = session.shopId, isJerryCan = session.isJerryCan})
    local key = FuelBillKey(session.playerIdentifier)
    local ok = pcall(SetResourceKvp, key, encoded)
    return ok and GetResourceKvpString(key) == encoded
end

local function GetFuelSessionForPlayer(src)
    local identifier = Framework.GetPlayerIdentifier(src)
    if not identifier then return nil, "Your character is not ready yet." end
    local current = ActiveFuelingSessions[src]
    if current and SessionBelongsToSource(current, src) then
        current.playerIdentifier = identifier
        return current
    end
    if current then current.active = false; ActiveFuelingSessions[src] = nil end
    local raw = GetResourceKvpString(FuelBillKey(identifier))
    if not raw then return nil end
    local ok, bill = pcall(json.decode, raw)
    if not ok or type(bill) ~= "table" or bill.version ~= 1 or bill.playerIdentifier ~= identifier then
        return nil, "Your fuel bill could not be loaded. Please contact staff."
    end
    if bill.status == "paid" then return nil end
    if bill.status ~= "unpaid" and bill.status ~= "paying" then
        return nil, "Your fuel bill could not be loaded. Please contact staff."
    end
    if not FiniteNumber(bill.cost) or bill.cost <= 0 or not FiniteNumber(bill.litersTanked) then
        return nil, "Your fuel bill could not be loaded. Please contact staff."
    end
    bill.active = false
    bill.secureLivePayment = false
    bill.recovered = true
    bill.paymentUncertain = bill.status == "paying"
    ActiveFuelingSessions[src] = bill
    return bill
end

local function SendFuelStartResult(src, requestId, accepted, session, message)
    if requestId == nil then
        if not accepted then TriggerClientEvent("rcore_fuel:stopFueling", src) end
        return
    end
    TriggerClientEvent("rcore_fuel:fuelingStartResult", src, requestId, accepted,
        session and {cost = session.cost, litersTanked = session.litersTanked,
            pricePerLiter = session.pricePerLiter, fuelType = session.fuelType,
            vehicleNetId = session.vehicleNetId, duiIdentifier = session.duiIdentifier} or nil, message)
end

local function NotifyRecoveredFuelBill(src)
    local bill = GetFuelSessionForPlayer(src)
    if bill and bill.recovered and not bill.recoveryNotified then
        bill.recoveryNotified = true
        Framework.ShowNotification(src, bill.paymentUncertain
            and "Your last fuel payment needs staff review before another charge."
            or ("You have an unpaid fuel bill of $" .. math.ceil(bill.cost) .. ". Use /payfuel to choose cash or bank."))
    end
end

-- Forward declaration: live-payment sessions finalize through the same station
-- revenue path as legacy post-fueling payment.
local CreditFuelSaleToStation

local function TryReserveLiveFuelCharge(src, session, targetRoundedCost)
    local alreadyReserved = math.max(0, math.floor(tonumber(session.prepaidCost) or 0))
    targetRoundedCost = math.max(alreadyReserved, math.floor(tonumber(targetRoundedCost) or alreadyReserved))
    local delta = targetRoundedCost - alreadyReserved
    if delta <= 0 then return true end

    local preferred = Config.SecureFuelPaymentPriority == "bank" and "bank" or "cash"
    local fallback = preferred == "cash" and "bank" or "cash"

    local function tryAccount(account)
        if Framework.GetMoney(src, account) < delta then return false end
        if Framework.RemoveMoney(src, account, delta) ~= true then return false end
        if account == "cash" then
            session.prepaidCash = (tonumber(session.prepaidCash) or 0) + delta
        else
            session.prepaidBank = (tonumber(session.prepaidBank) or 0) + delta
        end
        session.prepaidCost = alreadyReserved + delta
        return true
    end

    return tryAccount(preferred) or tryAccount(fallback)
end

local function FinalizeLiveFuelSession(src, session, showNotification)
    if not session or session.secureLivePayment ~= true then return false end
    if ActiveFuelingSessions[src] ~= session then return false end

    ActiveFuelingSessions[src] = nil
    session.active = false

    local paidCost = math.max(0, math.floor(tonumber(session.prepaidCost) or 0))
    if paidCost > 0 then
        CreditFuelSaleToStation(session, paidCost)
        if showNotification and GetPlayerName(src) then
            Framework.ShowNotification(src, string.format("Paid $%d for fuel.", paidCost), "success")
        end
    end
    return true
end

local function PlayerOwnsOccupiedPump(src, shopId, dispenserIndex)
    local bucket = GetPumpLockBucket(shopId, dispenserIndex, false)
    if not bucket then return false end
    for _, lock in pairs(bucket) do
        if PumpLockBelongsToSource(lock, src) and lock.occupied == true then
            return true
        end
    end
    return false
end

local function ReleasePumpLocksForPlayer(src)
    for shopId, dispensers in pairs(PumpLocks) do
        for dispenserIndex, sides in pairs(dispensers) do
            for side, lock in pairs(sides) do
                if lock and tonumber(lock.source) == tonumber(src) then
                    sides[side] = nil
                    TriggerClientEvent("rcore_fuel:SyncFuelPumpValues", -1, shopId, dispenserIndex, {
                        source = { [side] = false },
                        occupied = { [side] = false },
                    })
                end
            end
        end
    end
end

CreateThread(function()
    while true do
        Wait(5000)
        local now = GetGameTimer()
        for shopId, dispensers in pairs(PumpLocks) do
            for dispenserIndex, sides in pairs(dispensers) do
                local _, _, dispenserData = GetValidDispenser(shopId, dispenserIndex)
                for side, lock in pairs(sides) do
                    local lockSource = lock and tonumber(lock.source)
                    local release = not lockSource or not GetPlayerName(lockSource)
                    if not release and lock.ownerIdentifier
                        and Framework.GetPlayerIdentifier(lockSource) ~= lock.ownerIdentifier then
                        release = true
                    end
                    if not release and lock.occupied ~= true
                        and now - (tonumber(lock.reservedAt) or now) > PUMP_RESERVATION_TIMEOUT_MS then
                        release = true
                    end
                    if not release and lock.occupied == true and dispenserData and dispenserData.pos then
                        local ped = GetPlayerPed(lockSource)
                        release = not ped or ped == 0 or GetEntityHealth(ped) <= 0 or #(GetEntityCoords(ped) - dispenserData.pos) > 20.0
                    end
                    if release then
                        sides[side] = nil
                        TriggerClientEvent("rcore_fuel:SyncFuelPumpValues", -1, shopId, dispenserIndex, {
                            source = { [side] = false }, occupied = { [side] = false }
                        })
                        TriggerClientEvent("rcore_fuel:syncSoundPump", -1, false, shopId, dispenserIndex, side, nil)
                        if lockSource then
                            local lockSession = ActiveFuelingSessions[lockSource]
                            local sameLockIdentity = lockSession
                                and (not lock.ownerIdentifier or lockSession.playerIdentifier == lock.ownerIdentifier)
                                and lockSession.shopId == shopId
                                and tonumber(lockSession.dispenserIndex) == tonumber(dispenserIndex)
                            if sameLockIdentity then
                                lockSession.active = false
                                PersistCapacityNow(lockSession.shopId)
                                TriggerClientEvent("rcore_fuel:stopFueling", lockSource)
                            end
                        end
                    end
                end
            end
        end
    end
end)

MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS rcore_fuel_companies (
            shopId VARCHAR(50) NOT NULL PRIMARY KEY,
            owner_identifier VARCHAR(100) DEFAULT NULL,
            price INT DEFAULT 100000,
            for_sale BOOLEAN DEFAULT TRUE,
            open BOOLEAN DEFAULT TRUE,
            money INT DEFAULT 0,
            fuel_only_employee BOOLEAN DEFAULT FALSE,
            gasPrices TEXT DEFAULT NULL,
            capacity TEXT DEFAULT NULL
        );
    ]], {}, function()
        MySQL.Async.fetchAll("SELECT * FROM rcore_fuel_companies", {}, function(results)
            local loadedShops = {}
            local shopsNeedingPersist = {}
            for _, row in ipairs(results) do
                loadedShops[row.shopId] = true
                local shopData = Config.ShopList[row.shopId]
                if shopData then
                    local ownerIdentifier = NormalizeOwnerIdentifier(row.owner_identifier)
                    local persistedForSale = row.for_sale == 1 or row.for_sale == true

                    shopData.owner_identifier = ownerIdentifier
                    shopData.price = math.max(0, math.floor(tonumber(row.price) or tonumber(shopData.price) or 100000))
                    shopData.open = row.open == 1 or row.open == true
                    shopData.money = math.max(0, math.floor(tonumber(row.money) or 0))
                    shopData.fuel_only_employee = row.fuel_only_employee == 1 or row.fuel_only_employee == true

                    -- Config.EnableBuyingCompany controls whether an unowned station
                    -- is purchasable. Older database rows may have for_sale=0 because
                    -- the station was disabled when that row was first created. If the
                    -- admin later enables buying, that stale DB value must not keep the
                    -- marker hidden forever. Owned stations keep their owner's persisted
                    -- resale choice, while disabled stations are never listed.
                    if shopData.EnableBuyingCompany == true then
                        if ownerIdentifier then
                            shopData.for_sale = persistedForSale
                        else
                            shopData.for_sale = true
                        end
                    else
                        shopData.for_sale = false
                    end

                    if shopData.for_sale ~= persistedForSale then
                        -- Do not fire an independent startup UPDATE here. It can complete
                        -- after a newer purchase/company write and resurrect stale sale
                        -- state. Once startup is fully ready this row is normalized through
                        -- the same serialized full-row persistence queue as gameplay writes.
                        shopsNeedingPersist[row.shopId] = true
                    end

                    if row.gasPrices then
                        shopData.gasPrices = DecodeFuelIndexedJson(
                            row.gasPrices, shopData.gasPrices, row.shopId, "gasPrices")
                    end
                    if row.capacity then
                        shopData.capacity = DecodeFuelIndexedJson(
                            row.capacity, shopData.capacity, row.shopId, "capacity")
                    end
                end
            end

            local missingRows = {}
            for shopId, shopData in pairs(Config.ShopList) do
                if not loadedShops[shopId] then
                    -- Normalize the in-memory defaults too. Otherwise a fresh database
                    -- keeps the config sentinel "none" until restart, which is truthy
                    -- and can make an unowned station receive owner revenue.
                    shopData.owner_identifier = NormalizeOwnerIdentifier(shopData.owner_identifier)
                    shopData.for_sale = shopData.EnableBuyingCompany == true
                    shopData.open = shopData.open ~= false
                    shopData.money = math.max(0, math.floor(tonumber(shopData.money) or 0))
                    shopData.fuel_only_employee = shopData.fuel_only_employee == true
                    missingRows[#missingRows + 1] = { shopId = shopId, shopData = shopData }
                end
            end

            local pendingInserts = #missingRows
            local startupFinalized = false
            local function finalizeCompanyStartup()
                if startupFinalized or pendingInserts > 0 then return end
                startupFinalized = true
                CompanyDataReady = true

                -- Persist any normalization of rows that already existed only after all
                -- missing rows have been inserted. This keeps startup writes inside the
                -- same per-shop serialization queue used by live mutations.
                for shopId in pairs(shopsNeedingPersist) do
                    PersistCompanyNow(shopId)
                end

                -- A client can ask for config before SQL has finished loading. Broadcast
                -- the authoritative post-database state once initialization completes so
                -- those clients do not stay stuck with stale for_sale/owner values.
                SendCompanyConfigChanges(-1)
            end

            for _, missing in ipairs(missingRows) do
                local shopId, shopData = missing.shopId, missing.shopData
                local defaultPrices   = json.encode(shopData.gasPrices or {})
                local defaultCapacity = json.encode(shopData.capacity or {})
                MySQL.Async.execute([[
                    INSERT INTO rcore_fuel_companies
                    (shopId, owner_identifier, price, for_sale, open, money, fuel_only_employee, gasPrices, capacity)
                    VALUES (@shopId, @owner_identifier, @price, @for_sale, @open, @money, @fuel_only_employee, @gasPrices, @capacity)
                ]], {
                    ["@shopId"]            = shopId,
                    ["@owner_identifier"]  = shopData.owner_identifier,
                    ["@price"]             = shopData.price or 100000,
                    ["@for_sale"]          = shopData.for_sale,
                    ["@open"]              = shopData.open,
                    ["@money"]             = shopData.money,
                    ["@fuel_only_employee"] = shopData.fuel_only_employee,
                    ["@gasPrices"]         = defaultPrices,
                    ["@capacity"]          = defaultCapacity
                }, function()
                    pendingInserts = pendingInserts - 1
                    finalizeCompanyStartup()
                end)
            end

            finalizeCompanyStartup()
        end)
    end)
end)

-- Keep this legacy event for compatibility, but never trust the client-supplied
-- citizen id. Cache the authoritative framework identifier for this source instead.
RegisterNetEvent("rcore_fuel:playerLoadedCitizenId", function(_)
    local src = source
    local identifier = Framework.GetPlayerIdentifier(src)
    if identifier then
        ActiveRefiningPrices["citizenid_" .. src] = identifier
        NotifyRecoveredFuelBill(src)
    end
end)

RegisterNetEvent("rcore_fuel:requestConfigChanges", function()
    local src = source
    local now = GetGameTimer()
    if ConfigRequestRateLimit[src] and now - ConfigRequestRateLimit[src] < 3000 then
        return
    end
    ConfigRequestRateLimit[src] = now

    -- Do not send config defaults while SQL ownership/listing state is still loading.
    -- The initialization callback broadcasts to all connected clients when ready.
    if not CompanyDataReady then
        return
    end

    SendCompanyConfigChanges(src)
end)

RegisterNetEvent("rcore_fuel:startFueling", function(vehicleNetId, shopId, fuelType, isJerryCan, duiIdentifier, dispenserIndex, jerryWeaponId, jerryItemId, requestId)
    local src = source
    local function reject(message)
        local session = ActiveFuelingSessions[src]
        if session and SessionBelongsToSource(session, src) then session.active = false end
        SendFuelStartResult(src, requestId, false, ActiveFuelingSessions[src], message)
    end
    -- Fueling mutates station capacity/money. Fail closed until persisted company state
    -- has loaded, otherwise startup-time sessions can consume config defaults that the
    -- SQL load subsequently overwrites.
    if not CompanyDataReady then return reject() end

    local now = GetGameTimer()
    if FuelStartRateLimit[src] and now - FuelStartRateLimit[src] < 750 then return reject() end
    FuelStartRateLimit[src] = now
    local shopData = shopId and Config.ShopList[shopId]
    if not shopData or shopData.open == false then
        return reject()
    end

    -- This identifier is only a client-side DUI cache key that is echoed back to the
    -- same player. Bound it anyway so a modified client cannot make the server retain
    -- and repeatedly serialize an arbitrarily large payload on every fueling tick.
    if type(duiIdentifier) ~= "string" or #duiIdentifier == 0 or #duiIdentifier > 160 then
        duiIdentifier = nil
    end

    local numericDispenserIndex = FiniteNumber(dispenserIndex)
    if numericDispenserIndex then dispenserIndex = math.floor(numericDispenserIndex) end
    local dispenserData = dispenserIndex and shopData.pumpPosition and shopData.pumpPosition[dispenserIndex]

    -- Backward-compatible fallback for older clients: use the closest dispenser in
    -- this shop rather than the first configured dispenser (which can have a
    -- different fuel list).
    if not dispenserData then
        local playerPed = GetPlayerPed(src)
        local playerCoords = playerPed and playerPed ~= 0 and GetEntityCoords(playerPed) or nil
        local bestDistance = nil
        if playerCoords then
            for index, candidate in pairs(shopData.pumpPosition or {}) do
                local distance = candidate.pos and #(playerCoords - candidate.pos) or nil
                if distance and (not bestDistance or distance < bestDistance) then
                    bestDistance = distance
                    dispenserIndex = index
                    dispenserData = candidate
                end
            end
        end
    end

    if not dispenserData or not dispenserData.pos then
        return reject()
    end

    local playerPed = GetPlayerPed(src)
    if not playerPed or playerPed == 0 or #(GetEntityCoords(playerPed) - dispenserData.pos) > 12.0 then
        return reject()
    end

    -- Starting fuel delivery directly through the net event is not sufficient: the
    -- player must have actually reserved and picked up a nozzle on this dispenser.
    if not PlayerOwnsOccupiedPump(src, shopId, dispenserIndex) then
        return reject()
    end

    local numericFuelType = FiniteNumber(fuelType)
    if numericFuelType then fuelType = math.floor(numericFuelType) end
    isJerryCan = isJerryCan == true
    local jerryMetadataState = nil
    if isJerryCan then
        if not PlayerHasJerryCan(src) then
            Framework.ShowNotification(src, "You need a petrol can to fill it.", "error")
            return reject()
        end

        local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
            and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
            or Config.InventorySystem

        if invSystem == Inventory.OX or invSystem == Inventory.CORE then
            jerryMetadataState = GetVerifiedJerryMetadataState(src, jerryWeaponId, jerryItemId)
            if not jerryMetadataState then
                Framework.ShowNotification(src, "The active petrol can could not be verified.", "error")
                return reject()
            end
            if jerryMetadataState.level >= jerryMetadataState.maxLevel then
                Framework.ShowNotification(src, "That petrol can is already full.", "error")
                return reject()
            end
        end
    end
    if not isJerryCan then
        vehicleNetId = FiniteNumber(vehicleNetId)
        if not vehicleNetId or vehicleNetId <= 0 then return reject() end
        vehicleNetId = math.floor(vehicleNetId)
        local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
        if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or GetEntityType(vehicle) ~= 2 then
            return reject()
        end
        if #(GetEntityCoords(playerPed) - GetEntityCoords(vehicle)) > 8.0 then
            return reject()
        end
    end

    local fuelAllowed = false
    for _, allowedFuelType in ipairs(dispenserData.fuelTypeList or {}) do
        if allowedFuelType == fuelType then
            fuelAllowed = true
            break
        end
    end

    -- -1 is the stock "not selected yet" sentinel. Resolve it from this exact
    -- dispenser, not from an unrelated pump elsewhere in the station.
    if not IsValidFuelType(fuelType) or not fuelAllowed then
        local resolvedFuelType = dispenserData.fuelTypeList and dispenserData.fuelTypeList[1]
        if resolvedFuelType and IsValidFuelType(resolvedFuelType) then
            fuelType = resolvedFuelType
        else
            return reject()
        end
    end

    -- FIX 18: fuel_only_employee was only ever persisted to/from the database,
    -- never actually checked server-side -- a modified client could bypass the
    -- client-side check (client/fuel_pump/main.lua FIX 14) entirely and use an
    -- employees-only pump regardless of job. PlayerHasJob already existed in
    -- server/player_job/init.lua specifically for this (per its own doc
    -- comment) but was never called anywhere.
    if shopId and Config.ShopList[shopId] and Config.ShopList[shopId].fuel_only_employee then
        if not PlayerHasJob(src, Config.ShopList[shopId].Job) then
            Framework.ShowNotification(src, "This pump is for employees only!")
            return reject()
        end
    end

    -- FIX 13: ShopHasCapacity existed in pricing.lua but was never called, so a
    -- shop's tracked capacity hitting 0 never actually stopped a (potentially
    -- spoofed) client from starting or continuing a paid session
    if not ShopHasCapacity(shopId, fuelType) then
        Framework.ShowNotification(src, "This pump is out of fuel!")
        return reject()
    end

    local previousSession, billError = GetFuelSessionForPlayer(src)
    if billError then return reject(billError) end
    local sameContext = previousSession
        and previousSession.shopId == shopId and previousSession.dispenserIndex == dispenserIndex
        and previousSession.vehicleNetId == vehicleNetId and previousSession.fuelType == fuelType
        and previousSession.isJerryCan == isJerryCan
        and previousSession.jerryMetadataItemKey == (jerryMetadataState and jerryMetadataState.key or nil)
    local resume = sameContext and previousSession.active == false
        and previousSession.secureLivePayment == false and not previousSession.recovered
        and not previousSession.checkoutRequested and not previousSession.paymentUncertain
    if previousSession and previousSession.active then
        -- Duplicate start requests must not create a second delivery loop.
        if not sameContext then return reject("Stop the current refill before changing vehicles or fuel.") end
        SendFuelStartResult(src, requestId, true, previousSession)
        return
    end
    if previousSession and (previousSession.cost or 0) > 0 and not resume then
        return reject("Finish paying for your previous fuel first. Use /payfuel.")
    end
    if previousSession then previousSession.active = false end
    local pricePerLiter = resume and previousSession.pricePerLiter or GetPricePerLiterForShop(shopId, fuelType)
    local playerIdentifier = Framework.GetPlayerIdentifier(src)
    if not playerIdentifier then return reject() end

    ActiveFuelingSessions[src] = {
        active        = true,
        playerIdentifier = playerIdentifier,
        vehicleNetId  = vehicleNetId,
        shopId        = shopId,
        fuelType      = fuelType,
        isJerryCan    = isJerryCan,
        duiIdentifier = duiIdentifier,
        dispenserIndex = dispenserIndex,
        litersTanked  = resume and previousSession.litersTanked or 0,
        cost          = resume and previousSession.cost or 0,
        pricePerLiter = pricePerLiter,
        secureLivePayment = Config.SecureFuelLivePayment ~= false,
        prepaidCost   = 0,
        prepaidCash   = 0,
        prepaidBank   = 0,
        jerryMetadataItemKey = jerryMetadataState and jerryMetadataState.key or nil,
        jerryMetadataCredits = resume and previousSession.jerryMetadataCredits or 0
    }

    -- Capture this exact table before scheduling; an old stopped thread must
    -- never attach itself to a resumed session and double its delivery rate.
    local session = ActiveFuelingSessions[src]
    SendFuelStartResult(src, requestId, true, session)

    CreateThread(function()
        local interval = GetGunFlowRateInMilliseconds(fuelType)

        while session and session.active do
            Wait(interval)

            if not session.active then break end

            -- Revalidate the physical fueling context every tick. A session may have
            -- started legitimately and then become invalid after a teleport, vehicle
            -- deletion/network-id reuse, or nozzle release.
            local currentPed = GetPlayerPed(src)
            local _, _, liveDispenser = GetValidDispenser(session.shopId, session.dispenserIndex)
            local validContext = SessionBelongsToSource(session, src)
                and currentPed and currentPed ~= 0 and liveDispenser and liveDispenser.pos
                and #(GetEntityCoords(currentPed) - liveDispenser.pos) <= 15.0
                and PlayerOwnsOccupiedPump(src, session.shopId, session.dispenserIndex)
            if validContext and not session.isJerryCan then
                local liveVehicle = NetworkGetEntityFromNetworkId(tonumber(session.vehicleNetId) or 0)
                validContext = liveVehicle and liveVehicle ~= 0 and DoesEntityExist(liveVehicle)
                    and GetEntityType(liveVehicle) == 2
                    and #(GetEntityCoords(currentPed) - GetEntityCoords(liveVehicle)) <= 10.0
            end
            if not validContext then
                session.active = false
                TriggerClientEvent("rcore_fuel:stopFueling", src)
                break
            end

            -- Never allow a modified client to keep a jerry-can session alive past
            -- the physical capacity of one can. The normal client stops sooner when a
            -- partially-filled can reaches 100%; this is the authoritative upper bound.
            if session.isJerryCan then
                local maxJerryLiters = math.max(1, math.floor(tonumber(Config.JerryCanLitersSize) or 20))
                if session.litersTanked >= maxJerryLiters then
                    session.active = false
                    TriggerClientEvent("rcore_fuel:stopFueling", src)
                    break
                end

                -- For authoritative metadata inventories, do not keep dispensing and
                -- charging if the client stopped acknowledging can updates. Three
                -- outstanding one-liter credits tolerates normal latency while bounding
                -- stock/cost drift from a modified or desynchronised client.
                if session.jerryMetadataItemKey
                    and (tonumber(session.jerryMetadataCredits) or 0) >= 3 then
                    session.active = false
                    TriggerClientEvent("rcore_fuel:stopFueling", src)
                    Framework.ShowNotification(src, "Petrol can sync failed; fueling stopped.", "error")
                    break
                end
            end

            -- FIX 13: shop capacity is shared across every player fueling at that
            -- shop, so it can hit 0 mid-session even though this session passed
            -- the check above
            if not ShopHasCapacity(shopId, fuelType) then
                session.active = false
                TriggerClientEvent("rcore_fuel:stopFueling", src)
                Framework.ShowNotification(src, "This pump just ran out of fuel!")
                break
            end

            local projectedCost = session.cost + session.pricePerLiter

            if session.secureLivePayment then
                -- Reserve the cumulative rounded charge BEFORE granting this liter.
                -- A disconnect can no longer leave already-delivered fuel unpaid.
                local roundedProjectedCost = math.ceil(projectedCost)
                if not TryReserveLiveFuelCharge(src, session, roundedProjectedCost) then
                    session.active = false
                    TriggerClientEvent("rcore_fuel:stopFueling", src)
                    Framework.ShowNotification(src, "You don't have enough money to continue fueling!")
                    break
                end
            else
                -- Check affordability while dispensing; charge the completed bill
                -- only after the player chooses cash or bank at checkout.
                local currentCash = Framework.GetMoney(src, "cash")
                local currentBank = Framework.GetMoney(src, "bank")
                if currentCash < projectedCost and currentBank < projectedCost then
                    session.active = false
                    TriggerClientEvent("rcore_fuel:stopFueling", src)
                    Framework.ShowNotification(src, "You don't have enough money to continue fueling!")
                    break
                end
            end

            local previousCost, previousLiters = session.cost, session.litersTanked
            session.litersTanked = previousLiters + 1
            session.cost = projectedCost
            if not SaveFuelBill(session) then
                session.cost, session.litersTanked = previousCost, previousLiters
                session.active = false
                TriggerClientEvent("rcore_fuel:stopFueling", src)
                Framework.ShowNotification(src, "Fuel bill storage is unavailable; fueling stopped.", "error")
                break
            end
            if session.isJerryCan and session.jerryMetadataItemKey then
                session.jerryMetadataCredits = (tonumber(session.jerryMetadataCredits) or 0) + 1
            end

            if not session.isJerryCan then
                local liveVehicle = NetworkGetEntityFromNetworkId(tonumber(session.vehicleNetId) or 0)
                if liveVehicle and liveVehicle ~= 0 and DoesEntityExist(liveVehicle) then
                    local expectedFuelType = GetServerExpectedFuelType(liveVehicle)
                    if expectedFuelType and expectedFuelType ~= session.fuelType then
                        local model = GetEntityModel(liveVehicle)
                        local evidence = WrongFuelVehicleEvidence[session.vehicleNetId]
                        if not evidence or evidence.model ~= model or evidence.entity ~= liveVehicle then
                            evidence = { model = model, entity = liveVehicle, wrongLiters = 0, contaminators = {} }
                            WrongFuelVehicleEvidence[session.vehicleNetId] = evidence
                        end
                        evidence.wrongLiters = (tonumber(evidence.wrongLiters) or 0) + 1
                        evidence.updatedAt = GetGameTimer()
                        evidence.contaminators = evidence.contaminators or {}
                        local contaminatorIdentifier = Framework.GetPlayerIdentifier(src) or ("source:" .. tostring(src))
                        evidence.contaminators[contaminatorIdentifier] = true

                        -- Keep a replicated marker on the vehicle as well. This makes
                        -- the pump-out option and engine-failure logic reliable for
                        -- every client, not only the client that happened to dispense
                        -- the wrong fuel or currently owns the network entity.
                        local entityState = Entity(liveVehicle).state
                        if entityState[DecorEnum.WRONG_FUEL] ~= true then
                            Entity(liveVehicle).state:set(DecorEnum.WRONG_FUEL, true, true)
                        end
                    end
                end
            end

            -- FIX #6: persist capacity via helper (throttled every 10 liters)
            DecrementAndPersistCapacity(shopId, fuelType, session.litersTanked)

            TriggerClientEvent("rcore_fuel:addFuel",        src, vehicleNetId, fuelType, src, isJerryCan)
            TriggerClientEvent("rcore_fuel:updateFuelCost", src, session.litersTanked, vehicleNetId, session.pricePerLiter, duiIdentifier)
        end

        -- FIX #6: final capacity flush when loop exits (covers stop without pay)
        PersistCapacityNow(shopId)

        -- Secure sessions have already reserved each delivered liter. Finalize the
        -- station revenue as soon as dispensing ends; there is no unpaid window.
        if session and session.secureLivePayment == true then
            FinalizeLiveFuelSession(src, session, true)
        end
    end)
end)

RegisterNetEvent("rcore_fuel:stopFueling", function(shopId, fuelType, vehicleNetId)
    local src = source
    local session = ActiveFuelingSessions[src]
    if session and SessionBelongsToSource(session, src) then
        session.active = false
        -- FIX #9: persist capacity immediately on stop
        PersistCapacityNow(session.shopId or shopId)
    end
end)

RegisterNetEvent("rcore_fuel:SyncFuelPumpValues", function(shopId, dispenserIndex, syncedValues)
    local src = source
    local _, normalizedIndex, dispenserData = GetValidDispenser(shopId, dispenserIndex)
    if not dispenserData or type(syncedValues) ~= "table" then return end

    local occupiedTable = type(syncedValues.occupied) == "table" and syncedValues.occupied or nil
    local sourceTable = type(syncedValues.source) == "table" and syncedValues.source or nil
    if not occupiedTable or not sourceTable then return end

    local side, desiredOccupied = nil, nil
    local sideCount = 0
    for key, value in pairs(occupiedTable) do
        local numericSide = tonumber(key)
        if numericSide == 1 or numericSide == 2 then
            sideCount = sideCount + 1
            side = numericSide
            desiredOccupied = value == true
        end
    end
    if sideCount ~= 1 then return end

    local bucket = GetPumpLockBucket(shopId, normalizedIndex, true)
    local lock = bucket[side]
    if not PumpLockBelongsToSource(lock, src) then return end

    if desiredOccupied then
        -- Acquiring/occupying a nozzle is proximity-sensitive. Releasing one's own
        -- lock is deliberately not: rope-break auto-return happens at ~10m, while the
        -- old 8m release gate stranded occupied locks until the 20m stale sweep.
        if not IsPlayerNearPosition(src, dispenserData.pos, 8.0) then return end
        local claimedSource = sourceTable[side] or sourceTable[tostring(side)]
        if tonumber(claimedSource) ~= tonumber(src) then return end
        lock.occupied = true
        lock.reservedAt = GetGameTimer()
        TriggerClientEvent("rcore_fuel:SyncFuelPumpValues", -1, shopId, normalizedIndex, {
            source = { [side] = src }, occupied = { [side] = true }
        })
    else
        local session = ActiveFuelingSessions[src]
        if session and SessionBelongsToSource(session, src) and session.active == true and session.shopId == shopId
            and tonumber(session.dispenserIndex) == tonumber(normalizedIndex) then
            session.active = false
            PersistCapacityNow(session.shopId)
            TriggerClientEvent("rcore_fuel:stopFueling", src)
        end

        -- Stop the shared pump sound while we still have authoritative ownership.
        TriggerClientEvent("rcore_fuel:syncSoundPump", -1, false, shopId, normalizedIndex, side, nil)
        bucket[side] = nil
        TriggerClientEvent("rcore_fuel:SyncFuelPumpValues", -1, shopId, normalizedIndex, {
            source = { [side] = false }, occupied = { [side] = false }
        })
    end
end)

RegisterNetEvent("rcore_fuel:syncSoundPump", function(isPlaying, shopId, dispenserIndex, sideId, liquidPosition)
    local src = source
    local now = GetGameTimer()
    if PumpSoundRateLimit[src] and now - PumpSoundRateLimit[src] < 250 then return end
    PumpSoundRateLimit[src] = now

    sideId = tonumber(sideId)
    local _, normalizedIndex, dispenserData = GetValidDispenser(shopId, dispenserIndex)
    if not dispenserData or (sideId ~= 1 and sideId ~= 2) then return end
    -- Starting a world sound requires proximity. Stopping a sound only removes state
    -- and must be allowed for the lock owner after a rope-break/forced return.
    if isPlaying == true and not IsPlayerNearPosition(src, dispenserData.pos, 12.0) then return end

    local bucket = GetPumpLockBucket(shopId, normalizedIndex, false)
    local lock = bucket and bucket[sideId]
    if not PumpLockBelongsToSource(lock, src) then return end

    local safePosition = nil
    if isPlaying == true then
        local ped = GetPlayerPed(src)
        local playerCoords = ped and ped ~= 0 and GetEntityCoords(ped) or nil
        if not playerCoords then return end
        safePosition = playerCoords
        if liquidPosition and tonumber(liquidPosition.x) and tonumber(liquidPosition.y) and tonumber(liquidPosition.z) then
            local requested = vector3(tonumber(liquidPosition.x), tonumber(liquidPosition.y), tonumber(liquidPosition.z))
            if #(requested - playerCoords) <= 8.0 then safePosition = requested end
        end
    end

    TriggerClientEvent("rcore_fuel:syncSoundPump", -1, isPlaying == true, shopId, normalizedIndex, sideId, safePosition)
end)

RegisterNetEvent("rcore_fuel:releasePumpReservation", function(shopId, dispenserIndex, pumpSide)
    local src = source
    pumpSide = tonumber(pumpSide)
    local _, normalizedIndex, pumpPositionData = GetValidDispenser(shopId, dispenserIndex)
    if not pumpPositionData or (pumpSide ~= 1 and pumpSide ~= 2) then return end

    local bucket = GetPumpLockBucket(shopId, normalizedIndex, false)
    local lock = bucket and bucket[pumpSide]
    if PumpLockBelongsToSource(lock, src) and lock.occupied ~= true then
        bucket[pumpSide] = nil
    end
end)

RegisterNetEvent("rcore_fuel:pumpIsFree", function(pumpSide, shopId, dispenserIndex, _)
    local src = source
    pumpSide = tonumber(pumpSide)
    local _, normalizedIndex, pumpPositionData = GetValidDispenser(shopId, dispenserIndex)
    if not pumpPositionData or (pumpSide ~= 1 and pumpSide ~= 2) then return end
    if not IsPlayerNearPosition(src, pumpPositionData.pos, 8.0) then return end

    local bucket = GetPumpLockBucket(shopId, normalizedIndex, true)
    local now = GetGameTimer()
    local lock = bucket[pumpSide]

    if lock and not PumpLockBelongsToSource(lock, src) then
        -- Reservations that never complete are allowed to expire. A lock whose numeric
        -- source was recycled is stale immediately, even if the old lock was occupied.
        local sourceReused = tonumber(lock.source) == tonumber(src) and lock.ownerIdentifier ~= nil
        if sourceReused or (lock.occupied ~= true and now - (lock.reservedAt or now) > PUMP_RESERVATION_TIMEOUT_MS) then
            bucket[pumpSide] = nil
            lock = nil
        else
            Framework.ShowNotification(src, "That nozzle is already in use.", "error")
            return
        end
    end

    if not lock then
        local ownerIdentifier = Framework.GetPlayerIdentifier(src)
        if not ownerIdentifier then return end
        bucket[pumpSide] = { source = src, ownerIdentifier = ownerIdentifier, occupied = false, reservedAt = now }
    else
        lock.reservedAt = now
    end

    TriggerClientEvent("rcore_fuel:PlayerOpen", src, shopId, normalizedIndex, pumpPositionData, pumpSide)
end)

CreditFuelSaleToStation = function(session, cost)
    local shopId = session and session.shopId
    local shopData = shopId and Config.ShopList[shopId]
    if not shopData or not NormalizeOwnerIdentifier(shopData.owner_identifier) then
        return
    end

    local ownerMoney = math.max(0, math.floor(tonumber(cost) or 0))
    if Config.EnableTax and Config.TaxPercentage and Config.TaxPercentage > 0 then
        local tax = math.floor(ownerMoney * Config.TaxPercentage)
        ownerMoney = ownerMoney - tax
        if tax > 0 then
            local taxDeposited = Config.TaxSociety and Society.Deposit(Config.TaxSociety, tax) == true
            if not taxDeposited then
                -- Do not silently destroy money when the configured government/society
                -- account is unavailable. If the tax transfer cannot commit, leave the
                -- amount with the station owner and log the integration failure.
                ownerMoney = ownerMoney + tax
                print(string.format(
                    "[rcore_fuel] Tax deposit of $%d for shop %s failed; tax was returned to station revenue.",
                    tax, tostring(shopId)))
            end
        end
    end

    shopData.money = math.max(0, math.floor(tonumber(shopData.money) or 0)) + ownerMoney
    PersistCompanyNow(shopId)

    TriggerClientEvent("rcore_fuel:updateConfig", -1, {
        [shopId] = { money = shopData.money }
    })
end

RegisterNetEvent("rcore_fuel:requestPaymentModal", function(paymentType)
    local src     = source
    local session, billError = GetFuelSessionForPlayer(src)
    if billError then Framework.ShowNotification(src, billError, "error") return end
    if session and SessionBelongsToSource(session, src) and session.active == false and session.cost > 0 then
        if session.paymentUncertain then
            Framework.ShowNotification(src, "Your last fuel payment needs staff review before another charge.", "error")
            return
        end
        session.checkoutRequested = true
        if session.secureLivePayment == true then
            -- Money was reserved before every delivered liter, so the old modal is
            -- intentionally skipped in secure mode. This call simply finalizes revenue.
            FinalizeLiveFuelSession(src, session, true)
            return
        end

        local cost = math.ceil(session.cost)
        local cashAvailable = Framework.GetMoney(src, "cash") >= cost
        local bankAvailable = Framework.GetMoney(src, "bank") >= cost
        TriggerClientEvent("rcore_fuel:requestPaymentModal", src, cashAvailable, bankAvailable, cost, session.litersTanked, session.fuelType)
    end
end)

RegisterNetEvent("rcore_fuel:payForFuel", function(paymentType)
    local src = source

    -- FIX 4: validate paymentType before touching the session
    if paymentType ~= "cash" and paymentType ~= "bank" then return end
    if not CompanyDataReady then
        TriggerClientEvent("rcore_fuel:paymentDeferred", src, "Fuel stations are still loading. Use /payfuel to retry shortly.")
        return
    end

    local session, billError = GetFuelSessionForPlayer(src)
    if billError then Framework.ShowNotification(src, billError, "error") return end
    -- Payment is only valid after the dispensing loop has stopped. Otherwise the
    -- loop keeps a local reference and can continue granting fuel after payment.
    if not session or not SessionBelongsToSource(session, src)
        or session.active ~= false or session.cost <= 0 then return end
    if session.paymentUncertain then return end

    if session.secureLivePayment == true then
        -- Backward-compatible handling for an old/open NUI that still submits a
        -- payment choice. Never charge twice; just finalize the prepaid session.
        FinalizeLiveFuelSession(src, session, true)
        return
    end

    -- Journal the charge before calling the framework. Duplicate requests and
    -- uncertain restart recovery must not charge this bill a second time.
    session.paymentUncertain = true
    if not SaveFuelBill(session, "paying") then
        session.paymentUncertain = false
        TriggerClientEvent("rcore_fuel:paymentDeferred", src, "Payment storage is unavailable. Use /payfuel to retry.")
        return
    end

    if session.cost > 0 then
        local cost    = math.ceil(session.cost)
        local ok, success = pcall(Framework.RemoveMoney, src, paymentType, cost)
        if not ok then
            TriggerClientEvent("rcore_fuel:paymentDeferred", src, "Your fuel payment needs staff review before another charge.")
            return
        end
        if success then
            if not SaveFuelBill(session, "paid") then
                print("[rcore_fuel] Fuel payment completed, but its receipt could not be persisted; the saved payment needs review.")
            end
            ActiveFuelingSessions[src] = nil
            Framework.ShowNotification(src, string.format("Paid $%s for fuel using %s.", cost, paymentType), "success")

            CreditFuelSaleToStation(session, cost)
            TriggerClientEvent("rcore_fuel:paymentComplete", src, cost, session.litersTanked, session.fuelType, paymentType)
        else
            Framework.ShowNotification(src, "Payment failed!", "error")
            -- Restore session so the player can retry
            if not SaveFuelBill(session) then
                TriggerClientEvent("rcore_fuel:paymentDeferred", src, "Payment storage is unavailable. Please contact staff.")
                return
            end
            session.paymentUncertain = false
            ActiveFuelingSessions[src] = session
            local cashAvailable = Framework.GetMoney(src, "cash") >= cost
            local bankAvailable = Framework.GetMoney(src, "bank") >= cost
            TriggerClientEvent("rcore_fuel:requestPaymentModal", src, cashAvailable, bankAvailable, cost, session.litersTanked, session.fuelType)
        end
    end
end)

-- The framework money operation and our receipt cannot share a transaction.
-- Interrupted payments remain journaled as "paying" instead of auto-charging twice.
RegisterCommand("fuelbillresolve", function(src, args)
    if src ~= 0 then return end
    local identifier, action = args[1], args[2]
    if not identifier or (action ~= "paid" and action ~= "unpaid") then
        print("Usage: fuelbillresolve <character identifier> <paid|unpaid> (verify the framework payment first)")
        return
    end
    local raw = GetResourceKvpString(FuelBillKey(identifier))
    local ok, bill = pcall(json.decode, raw or "")
    if not ok or type(bill) ~= "table" or bill.version ~= 1
        or bill.playerIdentifier ~= identifier or bill.status ~= "paying" then
        print("[rcore_fuel] No interrupted payment found for that character.")
        return
    end
    if not SaveFuelBill(bill, action) then print("[rcore_fuel] Could not save payment resolution.") return end
    for playerSource, session in pairs(ActiveFuelingSessions) do
        if session.playerIdentifier == identifier then ActiveFuelingSessions[playerSource] = nil end
    end
    print("[rcore_fuel] Interrupted payment resolved as " .. action .. ".")
end, true)

AddEventHandler("onResourceStop", function(resource)
    if resource ~= GetCurrentResourceName() then return end
    for _, session in pairs(ActiveFuelingSessions) do
        session.active = false
        if not session.paymentUncertain then SaveFuelBill(session) end
    end
end)

-- FIX #4: clean up fueling session when a player disconnects
AddEventHandler("playerDropped", function()
    local src = source
    if ActiveFuelingSessions[src] then
        local session = ActiveFuelingSessions[src]
        session.active = false
        PersistCapacityNow(session.shopId)

        if session.secureLivePayment == true then
            -- The player was charged incrementally before each delivered liter. Credit
            -- the station from that prepaid amount even if the framework player object
            -- has already disappeared during playerDropped.
            FinalizeLiveFuelSession(src, session, false)
        else
            -- Keep checkout voluntary and tied to the character, even after the
            -- framework has already removed the disconnected player object.
            if not session.paymentUncertain then SaveFuelBill(session) end
            ActiveFuelingSessions[src] = nil
        end
    end
    ReleasePumpLocksForPlayer(src)
    JerryPourRateLimit[src] = nil
    ConfigRequestRateLimit[src] = nil
    NearbyPlayersRateLimit[src] = nil
    FuelStartRateLimit[src] = nil
    PumpSoundRateLimit[src] = nil
    JerryPourPending[src] = nil
    -- Clean up cached citizenid
    ActiveRefiningPrices["citizenid_" .. src] = nil
end)

RegisterNetEvent("rcore_fuel:addFuelFromJerry", function(vehicleNetId, jerryWeaponId, jerryItemId)
    local src = source
    vehicleNetId = FiniteNumber(vehicleNetId)
    if not vehicleNetId or vehicleNetId <= 0 then return end
    vehicleNetId = math.floor(vehicleNetId)

    local now = GetGameTimer()
    if JerryPourRateLimit[src] and now - JerryPourRateLimit[src] < 1200 then return end

    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetId)
    local ped = GetPlayerPed(src)
    if not vehicle or vehicle == 0 or not DoesEntityExist(vehicle) or GetEntityType(vehicle) ~= 2
        or not ped or ped == 0 or #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) > 6.0 then
        return
    end

    -- Require an actual petrol can. The client-side weapon check is convenience
    -- only and cannot be an authority boundary.
    if not PlayerHasJerryCan(src) then
        TriggerClientEvent("rcore_fuel:stopJerryRefueling", src, "You need a petrol can to refuel.")
        return
    end

    -- OX/CORE can be made fully transactional: verify one non-empty can, ask the
    -- client to submit its metadata decrement, then grant the vehicle liter only
    -- after that server-side metadata write succeeds. This prevents an empty/modified
    -- client from receiving repeated free liters.
    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    if invSystem == Inventory.OX or invSystem == Inventory.CORE then
        local activeSession = ActiveFuelingSessions[src]
        if activeSession and activeSession.active == true and activeSession.isJerryCan == true then return end
        if JerryPourPending[src] then return end
        local state = GetVerifiedJerryMetadataState(src, jerryWeaponId, jerryItemId)
        if not state or state.level <= 0 then
            TriggerClientEvent("rcore_fuel:stopJerryRefueling", src, "Your petrol can is empty.")
            return
        end

        local pourPlayerIdentifier = Framework.GetPlayerIdentifier(src)
        if not pourPlayerIdentifier then return end
        local pending = {
            key = state.key,
            vehicleNetId = vehicleNetId,
            createdAt = now,
            playerIdentifier = pourPlayerIdentifier,
            -- A can may contain less than one full tick at the end. Grant only the
            -- physical fraction actually removed instead of turning a tiny remainder
            -- into a free whole liter.
            litersToGrant = math.max(0.0, math.min(1.0, state.level / state.perLiter)),
        }
        JerryPourPending[src] = pending
        -- If the client never acknowledges the metadata debit, clear the transaction
        -- without granting fuel so a transient event loss cannot wedge future pours.
        SetTimeout(3500, function()
            if JerryPourPending[src] == pending then
                JerryPourPending[src] = nil
            end
        end)
        JerryPourRateLimit[src] = now
        TriggerClientEvent("rcore_fuel:consumeJerryLiter", src)
        return
    end

    -- Legacy inventory integrations do not expose authoritative can metadata to this
    -- resource. Keep their existing behavior, but retain possession/proximity/rate checks.
    JerryPourRateLimit[src] = now
    TriggerClientEvent("rcore_fuel:addFuelFromJerry", src, vehicleNetId)
end)

RegisterNetEvent("rcore_fuel:setActiveSlotId", function(slotId)
    local src = source
    slotId = FiniteNumber(slotId)
    if not slotId or slotId < 1 or slotId > 1000 then return end
    TriggerClientEvent("rcore_fuel:setPlayerActiveSlotNumber", src, math.floor(slotId))
end)

RegisterNetEvent("rcore_fuel:editor:saveOffset", function(modelHash, offset, heading)
    local src        = source

    -- FIX 14: re-check server-side instead of trusting the client's editor gate --
    -- this broadcasts to every connected player, so it needs its own validation
    if not IsPlayerAceAllowed(src, "rcore_fuel.editor") then
        return
    end

    modelHash = FiniteNumber(modelHash)
    heading = FiniteNumber(heading)
    if not modelHash or type(offset) ~= "table" or not heading then return end

    local x, y, z = FiniteNumber(offset.x), FiniteNumber(offset.y), FiniteNumber(offset.z)
    if not x or not y or not z then return end
    -- Vehicle fueling offsets should stay close to the vehicle. Bounds also keep
    -- malformed editor payloads from producing unusable JSON/config state.
    if math.abs(x) > 20.0 or math.abs(y) > 20.0 or math.abs(z) > 20.0
        or math.abs(heading) > 3600.0 then
        return
    end

    local offsetJson = LoadResourceFile(GetCurrentResourceName(), "fueling_offset.json") or "{}"
    local decoded = json.decode(offsetJson)
    local offsetData = type(decoded) == "table" and decoded or {}

    local strHash = tostring(math.floor(modelHash))
    offsetData[strHash] = {
        offset  = { x = x, y = y, z = z },
        heading = heading
    }

    SaveResourceFile(GetCurrentResourceName(), "fueling_offset.json", json.encode(offsetData, { indent = true }), -1)
    TriggerClientEvent("rcore_fuel:editorSetNewOffset", -1, math.floor(modelHash), offsetData[strHash])
    Framework.ShowNotification(src, "New fueling offset saved successfully!")
end)

RegisterServerCallback("rcore_fuel:hasPermission", function(source, cb, groups, acePermission)
    -- FIX 14: this unconditionally granted permission to every player. It gates
    -- the position/camera editor tools client-side, and rcore_fuel:editor:saveOffset
    -- (which broadcasts to every connected player) never re-checked independently,
    -- so any player could access the editor and rewrite/broadcast offset data.
    -- Ace permissions are granted per server via add_ace/add_principal in server.cfg.
    cb(acePermission ~= nil and IsPlayerAceAllowed(source, acePermission))
end)

RegisterServerCallback("rcore_fuel:fetchPlayerNamesAround", function(source, cb)
    local now = GetGameTimer()
    local last = NearbyPlayersRateLimit[source]
    if last and now - last < 1500 then
        cb(false)
        return
    end
    NearbyPlayersRateLimit[source] = now

    local players = {}
    -- FIX 15: this returned every connected player server-wide despite the name/use
    -- (picking a nearby player to bill for a fuel sale) implying proximity -- filter
    -- to players actually near the requesting source, consistent with this resource's
    -- other "nearby player" ranges
    local srcPed = GetPlayerPed(source)
    if not srcPed or srcPed == 0 then cb(false) return end
    local srcCoords = GetEntityCoords(srcPed)
    for _, pepId in ipairs(GetPlayers()) do
        local pedId = GetPlayerPed(pepId)
        if pedId and pedId ~= 0 and #(GetEntityCoords(pedId) - srcCoords) <= 10.0 then
            table.insert(players, {
                id   = tonumber(pepId),
                name = GetPlayerName(pepId)
            })
        end
    end
    if #players == 0 then
        cb(false)
        return
    end
    cb(players)
end)

-- FIX: requestPlayerIdentifier was triggered by client but had no server handler
RegisterNetEvent("rcore_fuel:requestPlayerIdentifier", function()
    local src        = source
    local identifier = Framework.GetPlayerIdentifier(src)
    TriggerClientEvent("rcore_fuel:requestPlayerIdentifier", src, identifier)
    if identifier then NotifyRecoveredFuelBill(src) end
end)

-- FIX: updateMetaData was triggered by jerryCan.lua for CORE inventory but had no server handler
RegisterNetEvent("rcore_fuel:updateMetaData", function(weaponId, itemId, metadata)
    local src = source
    if type(metadata) ~= "table" then return end

    local invSystem = (Config.InventorySystem == Inventory.AUTOMATIC or Config.InventorySystem == nil)
        and (ResolveInventorySystem and ResolveInventorySystem() or Config.InventorySystem)
        or Config.InventorySystem

    if invSystem ~= Inventory.OX and invSystem ~= Inventory.CORE then return end
    local state = GetVerifiedJerryMetadataState(src, weaponId, itemId)
    if not state then return end

    local requestedAmmo = FiniteNumber(metadata.ammo)
    local requestedDurability = FiniteNumber(metadata.durability)
    local requestedLevel = nil

    if state.backend == "ox" then
        if requestedAmmo ~= nil and requestedAmmo > 100 then
            requestedAmmo = math.max(0, math.min(100, math.floor((requestedAmmo / 4500) * 100)))
        end
        requestedLevel = requestedAmmo
        if requestedLevel == nil and requestedDurability ~= nil then
            requestedLevel = requestedDurability
        end
    else
        -- CORE uses GTA-style ammo for can contents. Do not let this generic event
        -- mutate unrelated durability metadata supplied by the client.
        requestedLevel = requestedAmmo
    end
    if requestedLevel == nil then return end

    requestedLevel = math.max(0, math.min(state.maxLevel, requestedLevel))
    local delta = requestedLevel - state.level
    if math.abs(delta) < 0.001 then return end

    local isIncrease = delta > 0
    local session = nil
    local pendingPour = nil
    local expectedLevel = nil

    if isIncrease then
        session = ActiveFuelingSessions[src]
        if not session or not SessionBelongsToSource(session, src)
            or session.active ~= true or session.isJerryCan ~= true then return end
        if not session.jerryMetadataItemKey or session.jerryMetadataItemKey ~= state.key then
            -- Switching item slots mid-fill breaks the authoritative item binding.
            session.active = false
            TriggerClientEvent("rcore_fuel:stopFueling", src)
            return
        end
        if (tonumber(session.jerryMetadataCredits) or 0) < 1 then return end

        -- Mirror the client inventory adapters' integer metadata step, but derive the
        -- target from server state. "Anything up to one liter" is unsafe: a modified
        -- client could acknowledge a paid tick with an arbitrarily tiny metadata move.
        expectedLevel = math.min(state.maxLevel, math.floor(state.level + state.perLiter))
    else
        pendingPour = JerryPourPending[src]
        if not pendingPour or pendingPour.key ~= state.key
            or pendingPour.playerIdentifier ~= Framework.GetPlayerIdentifier(src) then return end
        if GetGameTimer() - (tonumber(pendingPour.createdAt) or 0) > 3000 then
            JerryPourPending[src] = nil
            return
        end
        expectedLevel = math.max(0, math.floor(state.level - state.perLiter))
    end

    if expectedLevel == nil or math.abs(expectedLevel - state.level) < 0.001 then return end
    if math.abs(requestedLevel - expectedLevel) > 0.01 then return end
    requestedLevel = expectedLevel

    -- Build safe metadata containing only primitive values. Do NOT shallow-copy
    -- state.metadata with pairs() when it originates from ox_inventory -- even the
    -- sanitized copy from GetVerifiedJerryMetadataState may pick up non-primitive
    -- values in future code paths. Always re-extract explicitly to guarantee no
    -- circular-reference proxy objects leak into the table passed to SetMetadata.
    local safeMetadata = {}
    if state.metadata then
        if state.metadata.durability ~= nil then safeMetadata.durability = tonumber(state.metadata.durability) end
        if state.metadata.serial ~= nil then safeMetadata.serial = tostring(state.metadata.serial) end
        if type(state.metadata.components) == "table" then
            safeMetadata.components = {}
            for i, v in ipairs(state.metadata.components) do safeMetadata.components[i] = v end
        end
        if state.metadata.registered ~= nil then safeMetadata.registered = state.metadata.registered end
    end
    if state.backend == "ox" then
        safeMetadata.ammo = requestedLevel
        safeMetadata.durability = requestedLevel
    else
        safeMetadata.ammo = requestedLevel
    end

    local updated = Framework.UpdateWeaponMetaData(src, weaponId, itemId, safeMetadata) == true
    if not updated then return end

    if isIncrease then
        session.jerryMetadataCredits = math.max(0, (tonumber(session.jerryMetadataCredits) or 0) - 1)
        return
    end

    -- The can debit committed. Revalidate the pending vehicle before granting the
    -- corresponding liter, then clear the pending transaction regardless.
    JerryPourPending[src] = nil
    local vehicleNetId = tonumber(pendingPour.vehicleNetId)
    local vehicle = vehicleNetId and NetworkGetEntityFromNetworkId(vehicleNetId) or 0
    local ped = GetPlayerPed(src)
    if vehicle and vehicle ~= 0 and DoesEntityExist(vehicle) and GetEntityType(vehicle) == 2
        and ped and ped ~= 0 and #(GetEntityCoords(ped) - GetEntityCoords(vehicle)) <= 6.0 then
        TriggerClientEvent("rcore_fuel:addFuelFromJerry", src, vehicleNetId, pendingPour.litersToGrant or 1.0)
    end
end)

-- Periodic safety flush. Immediate gameplay mutations are already persisted, but this
-- catches direct config mutations while keeping every row serialized through the same
-- queue. Clamp bad configuration so a zero-minute interval cannot create a busy loop.
CreateThread(function()
    local intervalMinutes = math.max(1, tonumber(Config.SaveCompaniesMinutesInterval) or 15)
    local intervalMs = intervalMinutes * 60 * 1000
    while true do
        Wait(intervalMs)
        if CompanyDataReady then
            for shopId in pairs(Config.ShopList or {}) do
                PersistCompanyNow(shopId)
            end
        end
    end
end)

-- Exports for ox_inventory item use callbacks (configured in inventory/ox.lua)
local function resolvePlayerSource(event, item, inventory)
    if type(event) == "number" then
        return event
    end
    if type(inventory) == "table" then
        if inventory.id then return tonumber(inventory.id) end
        if inventory.player and inventory.player.source then return tonumber(inventory.player.source) end
    end
    if type(item) == "table" and item.source then
        return tonumber(item.source)
    end
    if source and source > 0 then
        return source
    end
    return nil
end

exports('vehicle_manual', function(event, item, inventory, slot, data)
    local src = resolvePlayerSource(event, item, inventory)
    if src then
        TriggerClientEvent("rcore_fuel:checkFuelType", src)
    end
end)

exports('window_cleaner', function(event, item, inventory, slot, data)
    -- ox_inventory server exports can be called for multiple item-use stages.
    -- Only start the cleaner when the item is actually being used.
    if type(event) == "string" and event ~= "usingItem" then
        return
    end

    local src = resolvePlayerSource(event, item, inventory)
    if src then
        TriggerClientEvent("rcore_fuel:selectVehicleForCleaning", src)
    end
end)

exports('fuel_pump', function(event, item, inventory, slot, data)
    local src = resolvePlayerSource(event, item, inventory)
    if src then
        TriggerClientEvent("rcore_fuel:selectCarToPumpOut", src)
    end
end)

-- Universal Server Fuel Exports
local function ResolveServerVehicleEntity(vehicle)
    local entity = vehicle
    if type(vehicle) == "number" and not DoesEntityExist(vehicle) then
        entity = NetworkGetEntityFromNetworkId(vehicle)
    end
    return (entity and entity ~= 0 and DoesEntityExist(entity)) and entity or nil
end

local function ServerGetFuel(vehicle)
    local entity = ResolveServerVehicleEntity(vehicle)
    if entity then
        local stateFuel = Entity(entity).state.fuel
        if stateFuel ~= nil then
            return tonumber(stateFuel) or 100.0
        end
    end
    return 100.0
end

local function ServerSetFuel(vehicle, amount)
    local entity = ResolveServerVehicleEntity(vehicle)
    if entity then
        amount = math.min(100.0, math.max(0.0, tonumber(amount) or 0.0))
        Entity(entity).state:set("fuel", amount, true)
    end
end

exports("GetFuel", ServerGetFuel)
exports("getFuel", ServerGetFuel)
exports("SetFuel", ServerSetFuel)
exports("setFuel", ServerSetFuel)
