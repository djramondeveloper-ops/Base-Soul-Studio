_G.Bridge = _G.Bridge or {}
Bridge = _G.Bridge

local function Lower(value)
    local normalized = string.lower(tostring(value or ""))
    normalized = normalized:gsub("_", "-")
    return normalized
end

local function IsStarted(resourceName)
    local state = GetResourceState(resourceName)
    return state == "started" or state == "starting"
end

local function NotifyTypeToOx(value)
    local t = Lower(value)
    if t == "error" then return "error" end
    if t == "success" then return "success" end
    if t == "warning" or t == "warn" then return "warning" end
    return "inform"
end

local function NotifyTypeToQb(value)
    local t = Lower(value)
    if t == "error" then return "error" end
    if t == "success" then return "success" end
    if t == "warning" or t == "warn" then return "primary" end
    return "primary"
end

if not IsDuplicityVersion() then
    local qbCoreObj = nil
    local qbxCoreObj = nil
    local notifySystem = nil
    local targetSystem = nil

    local function GetQBCore()
        if qbCoreObj ~= nil then return qbCoreObj end
        if not IsStarted("qb-core") then return nil end
        local ok, core = pcall(function()
            return exports["qb-core"]:GetCoreObject()
        end)
        if ok then
            qbCoreObj = core
        end
        return qbCoreObj
    end

    local function GetQBXCore()
        if qbxCoreObj ~= nil then return qbxCoreObj end
        if not IsStarted("qbx_core") then return nil end
        local ok, core = pcall(function()
            return exports["qbx_core"]
        end)
        if ok then
            qbxCoreObj = core
        end
        return qbxCoreObj
    end

    function Bridge.GetNotifySystem()
        if notifySystem then return notifySystem end

        local configured = Lower(Config.Bridge and Config.Bridge.Notify or "ox_lib")
        if configured == "qb-core" then configured = "qbcore" end
        if configured == "qbx-core" then configured = "qbx" end
        if configured ~= "auto" then
            if configured == "ox-lib" then configured = "ox_lib" end
            if configured == "ox_lib" and (IsStarted("ox_lib") or (lib and lib.notify)) then
                notifySystem = "ox_lib"
                return notifySystem
            end
            if configured == "qbx" and IsStarted("qbx_core") then
                notifySystem = "qbx"
                return notifySystem
            end
            if configured == "qbcore" and IsStarted("qb-core") then
                notifySystem = "qbcore"
                return notifySystem
            end
            if configured == "esx" and IsStarted("es_extended") then
                notifySystem = "esx"
                return notifySystem
            end
        end

        if IsStarted("ox_lib") then
            notifySystem = "ox_lib"
        elseif IsStarted("qbx_core") then
            notifySystem = "qbx"
        elseif IsStarted("qb-core") then
            notifySystem = "qbcore"
        elseif IsStarted("es_extended") then
            notifySystem = "esx"
        else
            -- Chat fallback istemiyoruz; default notify'ye don.
            notifySystem = "ox_lib"
        end
        return notifySystem
    end

    function Bridge.Notify(message, nType, duration)
        local text = tostring(message or "")
        if text == "" then return end

        local system = Bridge.GetNotifySystem()
        local notifyType = NotifyTypeToOx(nType)
        local time = tonumber(duration) or 5000

        if system == "ox_lib" then
            local payload = {
                description = text,
                type = notifyType,
                duration = time
            }
            if lib and lib.notify then
                lib.notify(payload)
                return
            end
            TriggerEvent("ox_lib:notify", payload)
            return
        end

        if system == "qbx" then
            local core = GetQBXCore()
            if core then
                -- QBX uses ox_lib for notifications, so we can use the same approach
                local payload = {
                    description = text,
                    type = notifyType,
                    duration = time
                }
                if lib and lib.notify then
                    lib.notify(payload)
                    return
                end
                TriggerEvent("ox_lib:notify", payload)
                return
            end
        end

        if system == "qbcore" then
            local core = GetQBCore()
            if core and core.Functions and core.Functions.Notify then
                core.Functions.Notify(text, NotifyTypeToQb(nType), time)
                return
            end
        end

        if system == "esx" then
            TriggerEvent("esx:showNotification", text)
            return
        end

        -- Son fallback: chat yerine default ox_lib dene.
        local fallbackPayload = {
            description = text,
            type = notifyType,
            duration = time
        }
        if lib and lib.notify then
            lib.notify(fallbackPayload)
            return
        end
        TriggerEvent("ox_lib:notify", fallbackPayload)
    end

    function Bridge.GetTargetSystem()
        if targetSystem then return targetSystem end

        local configured = Lower(Config.Bridge and Config.Bridge.Target or "auto")
        if configured == "qbtarget" then configured = "qb-target" end
        if configured == "ox-target" then configured = "ox_target" end
        if configured == "interactions" then configured = "interact" end
        if configured ~= "auto" then
            if configured == "interact" and IsStarted("interact") then
                targetSystem = "interact"
                return targetSystem
            end
            if configured == "ox_target" and IsStarted("ox_target") then
                targetSystem = "ox_target"
                return targetSystem
            end
            if configured == "qb-target" and IsStarted("qb-target") then
                targetSystem = "qb-target"
                return targetSystem
            end
            if configured == "qtarget" and IsStarted("qtarget") then
                targetSystem = "qtarget"
                return targetSystem
            end
        end

        if IsStarted("interact") then
            targetSystem = "interact"
        elseif IsStarted("ox_target") then
            targetSystem = "ox_target"
        elseif IsStarted("qb-target") then
            targetSystem = "qb-target"
        elseif IsStarted("qtarget") then
            targetSystem = "qtarget"
        else
            targetSystem = "none"
        end
        return targetSystem
    end

    -- ── DrawText / TextUI fallback ──────────────────────────────────────────
    -- Hiçbir target sistemi bulunamazsa yakın mesafe + tuş tespiti ile çalışır.
    local drawTextTargets  = {}   -- [entity] = { options = {...} }
    local dtVisible        = false
    local dtLabel          = ""
    local dtIcon           = nil
    local dtCallback       = nil
    local dtShownLabel     = nil  -- ox_lib'e en son gönderilen label (tekrar spam'i önler)

    local function ShowDtUI(label, icon)
        dtLabel = label
        dtIcon  = icon
        dtVisible = true
        if lib and lib.showTextUI then
            local display = ("[E] %s"):format(label)
            if dtShownLabel ~= display then
                dtShownLabel = display
                lib.showTextUI(display, { icon = icon, position = "right-center" })
            end
        end
    end

    local function HideDtUI()
        if not dtVisible then return end
        dtVisible     = false
        dtLabel       = ""
        dtIcon        = nil
        dtCallback    = nil
        dtShownLabel  = nil
        if lib and lib.hideTextUI then
            lib.hideTextUI()
        end
    end

    -- Sadece ox_lib yokken her frame'de native yardım metni çiz.
    CreateThread(function()
        while true do
            if dtVisible and not (lib and lib.showTextUI) then
                BeginTextCommandDisplayHelp("STRING")
                AddTextComponentSubstringPlayerName(("~INPUT_CONTEXT~ %s"):format(dtLabel))
                EndTextCommandDisplayHelp(0, false, true, -1)
                Wait(0)
            else
                Wait(200)
            end
        end
    end)

    -- Yakınlık kontrolü + E tuşu etkileşimi.
    CreateThread(function()
        while true do
            if not next(drawTextTargets) then
                Wait(1000)
            else
                local ped     = PlayerPedId()
                local pedPos  = GetEntityCoords(ped)
                local bestOpt, bestDist = nil, math.huge

                for ent, data in pairs(drawTextTargets) do
                    if DoesEntityExist(ent) then
                        local entPos = GetEntityCoords(ent)
                        local d = #(pedPos - entPos)
                        for _, opt in ipairs(data.options) do
                            local dist = tonumber(opt.distance) or 2.0
                            if d <= dist and d < bestDist then
                                bestDist = d
                                bestOpt  = opt
                            end
                        end
                    end
                end

                if bestOpt then
                    ShowDtUI(bestOpt.label, bestOpt.icon)
                    dtCallback = bestOpt.onSelect
                    if IsControlJustPressed(0, 38) and dtCallback then -- 38 = E tuşu
                        dtCallback()
                    end
                    Wait(0)
                else
                    HideDtUI()
                    Wait(300)
                end
            end
        end
    end)
    -- ────────────────────────────────────────────────────────────────────────

    function Bridge.AddTargetEntity(entity, options, fallbackDistance)
        if not entity or entity == 0 or not options then return false end
        local system = Bridge.GetTargetSystem()

        if system == "interact" then
            exports.interact:addLocalEntity(entity, options)
            return true
        end

        if system == "ox_target" then
            exports.ox_target:addLocalEntity(entity, options)
            return true
        end

        if system == "qb-target" then
            local qbOptions = {}
            local maxDistance = tonumber(fallbackDistance) or 2.0
            for _, item in ipairs(options) do
                qbOptions[#qbOptions + 1] = {
                    label = item.label,
                    icon = item.icon,
                    action = function(ent)
                        if item.onSelect then item.onSelect(ent) end
                    end
                }
                maxDistance = math.max(maxDistance, tonumber(item.distance) or maxDistance)
            end
            exports["qb-target"]:AddTargetEntity(entity, {
                options = qbOptions,
                distance = maxDistance
            })
            return true
        end

        if system == "qtarget" then
            local qtOptions = {}
            local maxDistance = tonumber(fallbackDistance) or 2.0
            for _, item in ipairs(options) do
                qtOptions[#qtOptions + 1] = {
                    label = item.label,
                    icon = item.icon,
                    action = function(ent)
                        if item.onSelect then item.onSelect(ent) end
                    end
                }
                maxDistance = math.max(maxDistance, tonumber(item.distance) or maxDistance)
            end
            exports["qtarget"]:AddTargetEntity(entity, {
                options = qtOptions,
                distance = maxDistance
            })
            return true
        end

        -- Hiçbir target sistemi yok: DrawText / TextUI fallback.
        drawTextTargets[entity] = { options = options }
        return true
    end

    function Bridge.RemoveTargetEntity(entity, optionNames)
        if not entity or entity == 0 then return false end
        local system = Bridge.GetTargetSystem()

        if system == "interact" then
            local ok = pcall(function()
                exports.interact:removeLocalEntity(entity, optionNames)
            end)
            return ok
        end

        if system == "ox_target" then
            local ok = pcall(function()
                exports.ox_target:removeLocalEntity(entity, optionNames)
            end)
            return ok
        end

        if system == "qb-target" then
            local ok = pcall(function()
                exports["qb-target"]:RemoveTargetEntity(entity, optionNames)
            end)
            return ok
        end

        if system == "qtarget" then
            local ok = pcall(function()
                exports["qtarget"]:RemoveTargetEntity(entity, optionNames)
            end)
            return ok
        end

        drawTextTargets[entity] = nil
        return true
    end

    -- Entidade networkada criada pelo servidor/OneSync.
    -- No ox_target usamos o network id diretamente para o target sobreviver a culling/streaming.
    function Bridge.AddTargetNetworkEntity(netId, entity, options, fallbackDistance)
        netId = tonumber(netId)
        if not netId or netId <= 0 or not options then return false end
        local system = Bridge.GetTargetSystem()

        if system == "interact" then
            exports.interact:addEntity(netId, options)
            return true
        end

        if system == "ox_target" then
            exports.ox_target:addEntity(netId, options)
            return true
        end

        -- Fallback para targets que trabalham com handle local.
        if entity and entity ~= 0 then
            return Bridge.AddTargetEntity(entity, options, fallbackDistance)
        end
        return false
    end

    function Bridge.RemoveTargetNetworkEntity(netId, optionNames)
        netId = tonumber(netId)
        if not netId or netId <= 0 then return false end
        local system = Bridge.GetTargetSystem()

        if system == "interact" then
            local ok = pcall(function()
                exports.interact:removeEntity(netId, optionNames)
            end)
            return ok
        end

        if system == "ox_target" then
            local ok = pcall(function()
                exports.ox_target:removeEntity(netId, optionNames)
            end)
            return ok
        end
        return false
    end

    RegisterNetEvent("seoul_soccer:client:BridgeNotify", function(payload)
        payload = payload or {}
        Bridge.Notify(payload.message, payload.type, payload.duration)
    end)
else
    local vrpInterface = nil
    local vrpResolved = false

    local function GetVRP()
        if vrpResolved then
            return vrpInterface
        end
        vrpResolved = true

        if not IsStarted("vrp") or type(module) ~= "function" then
            return nil
        end

        local okProxy, Proxy = pcall(function()
            return module("vrp", "lib/Proxy")
        end)
        if not okProxy or not Proxy or type(Proxy.getInterface) ~= "function" then
            return nil
        end

        local okInterface, iface = pcall(function()
            return Proxy.getInterface("vRP")
        end)
        if okInterface and iface then
            vrpInterface = iface
        end
        return vrpInterface
    end

    function Bridge.GetPassport(src)
        src = tonumber(src)
        if not src then return nil end
        local vRP = GetVRP()
        if not vRP or type(vRP.Passport) ~= "function" then return nil end
        local ok, passport = pcall(vRP.Passport, src)
        passport = ok and tonumber(passport) or nil
        if passport and passport > 0 then return passport end
        return nil
    end

    function Bridge.GetCharacterName(src)
        local passport = Bridge.GetPassport(src)
        if not passport then return nil end
        local vRP = GetVRP()
        if not vRP or type(vRP.Identity) ~= "function" then return nil end
        local ok, identity = pcall(vRP.Identity, passport)
        if not ok or type(identity) ~= "table" then return nil end
        local first = tostring(identity.Name or identity.name or ""):gsub("^%s+", ""):gsub("%s+$", "")
        local last = tostring(identity.Name2 or identity.name2 or ""):gsub("^%s+", ""):gsub("%s+$", "")
        local full = (first .. " " .. last):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
        if full ~= "" then return full end
        return nil
    end

    function Bridge.GetPlayerIdentifier(src)
        local passport = Bridge.GetPassport(src)
        if passport then
            return "passport:" .. tostring(passport)
        end
        local ids = GetPlayerIdentifiers(tonumber(src) or 0) or {}
        for _, id in ipairs(ids) do
            if string.sub(id, 1, 8) == "license:" then
                return id
            end
        end
        return "player:" .. tostring(src)
    end

    function Bridge.NotifyPlayer(src, message, nType, duration)
        if not src then return end
        TriggerClientEvent("seoul_soccer:client:BridgeNotify", src, {
            message = tostring(message or ""),
            type = nType or "inform",
            duration = tonumber(duration) or 5000
        })
    end

    function Bridge.NotifyAll(message, nType, duration)
        TriggerClientEvent("seoul_soccer:client:BridgeNotify", -1, {
            message = tostring(message or ""),
            type = nType or "inform",
            duration = tonumber(duration) or 5000
        })
    end

    local function GetSeoulMoneyAccount()
        local configured = Lower(Config.Seoul and Config.Seoul.MoneyAccount or "bank")
        if configured == "full" then return "full" end
        return "bank"
    end

    function Bridge.RemoveMoney(src, amount)
        src = tonumber(src)
        amount = math.floor(tonumber(amount) or 0)
        if not src or amount <= 0 then return false end

        local vRP = GetVRP()
        local passport = Bridge.GetPassport(src)
        if vRP and passport then
            local fn = GetSeoulMoneyAccount() == "full" and vRP.PaymentFull or vRP.PaymentBank
            if type(fn) ~= "function" then return false end
            local ok, paid = pcall(fn, passport, amount)
            return ok and paid == true
        end

        -- Fallbacks legados para manter o resource multiframework fora da Seoul.
        if IsStarted("es_extended") then
            local ok, ESX = pcall(function() return exports['es_extended']:getSharedObject() end)
            if ok and ESX then
                local player = ESX.GetPlayerFromId(src)
                if player then
                    local current = player.getMoney and player.getMoney() or 0
                    if current < amount then return false end
                    if player.removeMoney then player.removeMoney(amount) end
                    return true
                end
            end
            return false
        end

        if IsStarted("qb-core") then
            local ok, QBCore = pcall(function() return exports['qb-core']:GetCoreObject() end)
            if ok and QBCore then
                local player = QBCore.Functions and QBCore.Functions.GetPlayer(src)
                if player and player.Functions then
                    return player.Functions.RemoveMoney('cash', amount) == true
                end
            end
        end
        return false
    end

    function Bridge.AddMoneyToPassport(passport, amount)
        passport = tonumber(passport)
        amount = math.floor(tonumber(amount) or 0)
        if not passport or amount <= 0 then return false end
        local vRP = GetVRP()
        if not vRP or type(vRP.GiveBank) ~= "function" then return false end
        local ok = pcall(vRP.GiveBank, passport, amount)
        return ok
    end

    function Bridge.AddMoney(src, amount)
        src = tonumber(src)
        amount = math.floor(tonumber(amount) or 0)
        if not src or amount <= 0 then return false end

        local passport = Bridge.GetPassport(src)
        if passport and Bridge.AddMoneyToPassport(passport, amount) then
            return true
        end

        if IsStarted("es_extended") then
            local ok, ESX = pcall(function() return exports['es_extended']:getSharedObject() end)
            if ok and ESX then
                local player = ESX.GetPlayerFromId(src)
                if player and player.addMoney then
                    player.addMoney(amount)
                    return true
                end
            end
            return false
        end

        if IsStarted("qb-core") then
            local ok, QBCore = pcall(function() return exports['qb-core']:GetCoreObject() end)
            if ok and QBCore then
                local player = QBCore.Functions and QBCore.Functions.GetPlayer(src)
                if player and player.Functions then
                    player.Functions.AddMoney('cash', amount)
                    return true
                end
            end
        end
        return false
    end
end
