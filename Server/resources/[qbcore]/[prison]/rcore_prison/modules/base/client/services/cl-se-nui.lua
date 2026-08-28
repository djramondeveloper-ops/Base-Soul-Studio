local activeTablet = nil
local tabletAnimDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnimName = "base"
local tabletModel = -1585232418
local tabletBone = 60309
local tabletOffsetPos = vector3(0.03, 0.002, -0.0)
local tabletOffsetRot = vector3(10.0, 160.0, 0.0)
local isTabletActive = false

local FallbackLocales = {
    UI = {
        PAGES_PRISONER_ACCOUNT = {
            HOME = "Home",
            TRANSACTIONS = "Transactions"
        },
        DIALOG = {
            CONFIRM = "Confirm",
            CANCEL = "Cancel"
        },
        REGISTER_PRISONER_ACCOUNT = {
            TITLE = "Do you want to create prison account?",
            DESC = "Select your option",
            CREATE_ACCOUNT = "Create Account",
            EXIT = "Exit"
        },
        CANTEEN = {
            QUICK_ACTION_MENU_FREE_TITLE = "Do you want to get free package?",
            QUICK_ACTION_MENU_FREE_DESC = "Please confirm to get free package.",
            QUICK_ACTION_MENU_PAID_TITLE = "Exchange credits for item: ",
            QUICK_ACTION_MENU_PAID_DESC = "Total cost of the item: ",
            FREE_PACKAGE_TITLE = "Free Package",
            FREE_PACKAGE_BUTTON_LABEL = "Claim free package",
            PAID_PACKAGE_COST_LABEL = "Credit cost:",
            PAID_PACKAGE_BUTTON_LABEL = "Purchase item",
            PAGE_TITLE = "Prison canteen",
            PAGE_DESC = "Canteen serves as a central hub for inmates to access both essential and supplementary goods. Here, inmates can choose from a variety of products ranging from basic necessities to special items.",
            PAGE_CREDIT_BALANCE = "Credit balance: ",
            FREE_TAB_LABEL = "Free",
            PAID_TAB_LABEL = "Paid",
            ERROR_TITLE = "Canteen",
            ERROR_NO_CANTEEN_ITEMS_LABEL = "Sorry we don't have any offers for you."
        },
        TRADE = {
            PAGE_TITLE = "Trade",
            PAGE_DESC = "Welcome to the prison black market! Find everything from smokes to shivs. Need it? We've got it.",
            QUICK_ACTION_MENU_TITLE = "Exchange item for economy item: ",
            QUICK_ACTION_MENU_DESC = "Total cost of the item: ",
            ECONOMY_COST_LABEL = "Cigarette cost: ",
            ERROR_TITLE = "Trade",
            ERROR_NO_TRADE_ITEMS_LABEL = "Sorry we don't have any offers for you."
        },
        QUEST = {
            QUICK_ACTION_EXIT_TITLE = "Exit"
        },
        BOOTH = {
            START_CALL_BUTTON_LABEL = "Start Call",
            END_CALL_BUTTON_LABEL = "End Call",
            CURRENT_STATION_NUMBER = "Booth number: ",
            DIAL_NUMBER = "Dial number",
            RESET = "Reset"
        },
        PRISONER_MDW = {
            TITLE = "Management",
            PRISONERS_TITLE = "Prisoners",
            COMS_TITLE = "Coms players",
            LOG_TITLE = "Log"
        },
        MDW_STATE_LABELS = {
            IDLE = "This citizen is currently not doing his parolle time.",
            SWEEPING = "This citizen is currently sweeping the floor.",
            RETURN = "This citizen finished sweeping, now needs to report to Officer."
        },
        LOGS_STATE_LABELS = {
            RELEASE_PLAYER = "Released player",
            EDIT_SENTENCE = "Edited sentence",
            PRISON_BREAK = "Prison break",
            CITIZEN_JAILED = "Citizen jailed",
            CITIZEN_PAROLLED = "Citizen parolled"
        },
        MDW_PAGE_COMS = {
            PAGE_TITLE = "COMS Players",
            PAGE_DESC = "This section provides detailed insights into every citizen's background, current confinement conditions, and rehabilitation progress",
            ADD_SENTENCE_TITLE = "Add Sentence",
            SEARCH_PLACEHOLDER = "Search for a prisoner",
            QUICK_ACTION_MENU_LABEL = "COMS Actions",
            QUICK_ACTION_DESC = "Are you sure you want to do this?",
            TABLE_HEADER_COMS_PLAYER_NAME = "Name",
            TABLE_HEADER_COMS_PEROLL_AMOUNT = "Peroll tasks",
            TABLE_HEADER_COMS_PEROLL_AMOUNT_TARGET = "Target amount parolle",
            TABLE_HEADER_COMS_WORK_STATE = "Work state",
            TABLE_HEADER_COMS_SENTENCE_REASON = "Sentence state",
            TABLE_HEADER_COMS_QUICK_ACTIONS = "Quick actions",
            QUICK_ACTION_EDIT_SENTENCE = "Edit Sentence",
            QUICK_ACTION_RELEASE_PLAYER = "Release player",
            QUICK_ACTION_EDIT_NOTE = "Edit Note",
            ADD_SENTENCE_MENU_TITLE = "Add Sentence",
            ADD_SENTENCE_MENU_DESC = "Are you sure you want to proceed?",
            ADD_SENTENCE_MENU_CLOSEST_PLAYERS = "Closest players",
            ADD_SENTENCE_PREFIX = "Peroll tasks: (amount)",
            ERROR_PAGE_TITLE = "COMS",
            ERROR_NO_COMS_CITIZENS_LABEL = "Sorry we don't have any citizen on parolle for you."
        },
        MDW_PAGE_LOGS = {
            PAGE_TITLE = "Logs",
            PAGE_DESC = "This section provides detailed logs of all the actions taken by the officers.",
            SEARCH_PLACEHOLDER = "Search for a log",
            TABLE_HEADER_ACTION = "Action",
            TABLE_HEADER_DESC = "Description",
            TABLE_OFFICER_NAME = "Officer name",
            TABLE_CITIZEN_NAME = "Citizen name",
            TABLE_TIME = "Time",
            ERROR_PAGE_TITLE = "Logs",
            ERROR_NO_LOGS = "Sorry we don't have any logs for you."
        },
        MDW_PAGE_PRISONERS = {
            PAGE_TITLE = "Prisoners",
            PAGE_DESC = "This section provides detailed insights into every prisoner's background, current confinement conditions, and rehabilitation progress.",
            ADD_SENTENCE_DIALOG_TITLE = "Add Sentence",
            ADD_SENTENCE_BUTTON_TITLE = "Add Sentence",
            ADD_SENTENCE_DIALOG_DESC = "Are you sure you want to proceed?",
            ADD_SENTENCE_DIALOG_PREFIX = "Sentence time: ",
            ADD_SENTENCE_CLOSEST_PLAYERS = "Closest players",
            ADD_SENTENCE_SENTENCE_REASON = "Sentence reason",
            ADD_SENTENCE_SENTENCE_PLACEHOLDER = "Enter reason",
            SEARCH_PLACEHOLDER = "Search for a prisoner",
            QUICK_ACTION_TITLE_LABEL = "Prisoner options",
            QUICK_ACTION_DESC = "Are you sure you want to do this?",
            QUICK_ACTION_EDIT_SENTENCE = "Edit Sentence",
            QUICK_ACTION_RELEASE_PLAYER = "Release player",
            QUICK_ACTION_EDIT_NOTE = "Edit Note",
            DIALOG_RADIUS_LABEL_TELEPORT_PLAYER = "Teleport player",
            TABLE_HEADER_PRISONER_NAME = "Name",
            TABLE_HEADER_PRISONER_JAIL_TIME = "Jail time",
            TABLE_HEADER_PRISONER_OFFICER_NAME = "Jailed by",
            TABLE_HEADER_PRISONER_SENTENCE_REASON = "Sentence reason",
            TABLE_HEADER_PRISONER_QUICK_ACTIONS = "Quick actions",
            ERROR_PAGE_TITLE = "Prisoners",
            ERROR_NO_PRISONERS_LABEL = "Sorry we don't have any prisoners for you."
        },
        JAIL_DIALOG = {
            SELECT_PLAYER_PLACEHOLDER = "Select Player",
            SELECT_PLAYER_LABEL = "Players",
            CONFIRM_LABEL = "Confirm",
            CANCEL_LABEL = "Cancel",
            NONE_PLAYERS = "No players found"
        },
        PRISONER_ACCOUNT = {
            TITLE = "Prisoner Account",
            OVERVIEW_TITLE = "Overview",
            OVERVIEW_ID = "Account ID:",
            OVERVIEW_TOTAL_AMOUNT = "Total Amount:",
            COLUMS_ACTION = "Action",
            COLUMS_DESCRIPTION = "Description",
            COLUMS_TIME = "Time",
            SEARCH_PLACEHOLDER = "Search for a transaction",
            TRANSACTIONS = "Transactions",
            TRANSACTIONS_TILE = "Account transactions",
            RECENT_TRANSACTIONS_TITLE = "Recent transactions",
            CREDITS = "Credits",
            NOT_ANY_TRANSACTIONS = "No transactions found"
        },
        PREVIOUS = "Previous",
        NEXT = "Next"
    }
}

FrontendService = {}

local function StartTabletAnimation()
    if isTabletActive then
        isTabletActive = false
    end

    isTabletActive = true

    RequestAnimDict(tabletAnimDict)
    while not HasAnimDictLoaded(tabletAnimDict) do
        Citizen.Wait(100)
    end

    RequestModel(tabletModel)
    while not HasModelLoaded(tabletModel) do
        Citizen.Wait(100)
    end

    local playerPed = PlayerPedId()
    activeTablet = CreateObject(tabletModel, 0.0, 0.0, 0.0, true, true, false)

    local boneIndex = GetPedBoneIndex(playerPed, tabletBone)

    AttachEntityToEntity(
        activeTablet,
        playerPed,
        boneIndex,
        tabletOffsetPos.x,
        tabletOffsetPos.y,
        tabletOffsetPos.z,
        tabletOffsetRot.x,
        tabletOffsetRot.y,
        tabletOffsetRot.z,
        true,
        false,
        false,
        false,
        2,
        true
    )

    SetModelAsNoLongerNeeded(tabletModel)

    CreateThread(function()
        while isTabletActive do
            Wait(0)

            if not IsEntityPlayingAnim(playerPed, tabletAnimDict, tabletAnimName, 3) then
                TaskPlayAnim(playerPed, tabletAnimDict, tabletAnimName, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end

        ClearPedSecondaryTask(playerPed)

        Wait(250)

        if activeTablet and DoesEntityExist(activeTablet) then
            DetachEntity(activeTablet, true, false)
            DeleteEntity(activeTablet)
        end

        activeTablet = nil
    end, "cl-se-nui code name: Phoenix")
end

function FrontendService.AwaitFrontend()
    repeat
        Wait(1000)
    until SH.FrontendLoaded
end

function FrontendService.RegisterFrontendCallback(name, handler)
    assert(type(name) == "string", "Name must be a string")

    RegisterNUICallback(name, function(data, cb)
        if not next(data) then
            return
        end

        handler(data)
        cb("ok")
    end)
end

function FrontendService.SendReactMessage(action, data)
    if data and data.screen then
        SH.screen = data.screen
    end

    SendNUIMessage({
        action = action,
        data = data
    })
end

function FrontendService.HandleFocus(state)
    SetNuiFocus(state, state)
end

function FrontendService.HandleShowState(state)
    SetNuiFocus(state, state)
    FrontendService.SendReactMessage("setVisible", state)
end

function FrontendService.OpenMDW()
    SetNuiFocus(true, true)
    FrontendService.SendReactMessage("loadApp", {
        visible = true,
        screen = "MDW"
    })

    StartTabletAnimation()
end

RegisterNuiCallback("getBoothConfig", function(_, cb)
    cb({
        length = Config.PhoneBooth.Lenght,
        format = Config.PhoneBooth.Format
    })
end)

RegisterNuiCallback("uiLoaded", function(_, cb)
    dbg.bridge("Frontend is loaded!")

    SH.FrontendLoaded = true
    SH.screen = nil

    FrontendService.SendReactMessage("initTimeConfig", Config.Time)
    FrontendService.SendReactMessage("initConfig", Config.UI)

    local translations = FallbackLocales.UI
    local localeData = Locales[Config.Locale]

    if localeData and localeData.UI and next(localeData.UI) then
        translations = localeData.UI
        dbg.debug("UI Load - Loading translations from Locales[%s].UI category, for UI!", Config.Locale)
    else
        dbg.debug("UI Load - Failed to find translations in Locales[%s].UI category, loading fallback!", Config.Locale)
    end

    FrontendService.SendReactMessage("translations", translations)

    local imagePath = Config.ImagePath[Config.Inventories]
    if imagePath then
        dbg.debug("Image path: %s for inventory: %s", imagePath, Config.Inventories)

        FrontendService.SendReactMessage("inventoryImage", {
            path = imagePath,
            inventory = Config.Inventories
        })
    end

    FrontendService.SendReactMessage("setBoothConfig", "test")
    cb("ok")
end)

function HideApp()
    FrontendService.HandleShowState(false)
    DestroyAllMenus()

    if isTabletActive then
        isTabletActive = false
    end

    if Quest.activeCamera then
        SetCamActive(Quest.activeCamera, false)
        DestroyCam(Quest.activeCamera)
        RenderScriptCams(false, false, 0, true, false)
        DisplayRadar(true)
    end

    if IsAtBooth then
        local zoneData = SH.data.interaction[SH.zoneId]
        if zoneData and zoneData.type == INTERACT_TYPES.BOOTH then
            TriggerServerEvent("rcore_prison:server:requestBoothLeave", SH.zoneId)
        end
    end
end

RegisterNuiCallback("hideApp", function(_, cb)
    cb("ok")
    HideApp()
    TriggerLocalClientEvent("onHud", true, "SHOW_HUD", "CLOSE_NUI")
end)

RegisterNuiCallback("tradeItem", function(_, cb)
    cb("ok")
end)

RegisterNuiCallback("EXECUTE_MDW_QUICK_ACTION", function(data, cb)
    TriggerServerEvent("rcore_prison:server:executeMDWQuickAction", data)
    cb("OK")
end)

RegisterNetEvent("rcore_prison:client:updatePrisoner", function(prisonerData)
    SendNUIMessage({
        action = "UPDATE_PRISONERS",
        data = prisonerData
    })
end)
