-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-menu.lua
--  Engineered by Eazy Fxap
--  Original: 1078 lines → Cleaned: 220 lines
-- =====================================================

Frontend = {
    currentLabel = nil,
    currentName = nil,
    currentLibrary = Config.Menu,
    useLibrary = Config.Menu,
    Menus = {}
}

function UI.ParseData(self, data, cb)
    local formatted = nil
    if Config.Menu == Menu.OX then
        formatted = UI:Ox(data)
    elseif Config.Menu == Menu.ESX_CONTEXT or Config.Menu == Menu.ESX_MENU then
        formatted = UI:Esx(data)
    elseif Config.Menu == Menu.RCORE then
        formatted = UI:Rcore(data)
    elseif Config.Menu == Menu.QB then
        formatted = UI:QBMenu(data)
    end
    
    if cb then cb(formatted) end
end

function UI.CloseMenu(self)
    if Config.Menu == Menu.QB then
        exports[Menu.QB]:closeMenu()
        self.currentName = nil
    elseif Config.Menu == Menu.OX then
        if not lib then return dbg.debug("FE:CloseMenu - failed, ox_lib is not defined in fxmanifest.lua!") end
        lib.hideContext()
        self.currentName = nil
    elseif Config.Menu == Menu.ESX_MENU then
        if not Framework then return dbg.debug("FE:CloseMenu - failed, es_extended is not detected!") end
        Framework.UI.Menu.CloseAll()
    elseif Config.Menu == Menu.ESX_CONTEXT then
        exports[Menu.ESX_CONTEXT]:Close()
        self.currentName = nil
    elseif Config.Menu == Menu.RCORE then
        Menu.CloseMenu(self.currentName)
        self.currentName = nil
    elseif Config.Menu == Menu.NONE or Config.Menu == nil then
        UI:CloseMenuStandalone(self.currentName)
        self.currentName = nil
    end
end

function UI.Rcore(self, data)
    local function parse(item)
        local opt = {}
        opt.title = item.header or item.title or "Untitled"
        opt.isCopy = item.isCopy or false
        opt.value = item.value
        opt.icon = item.params and item.params.icon
        opt.event = item.params and not item.params.isServer and item.params.event
        opt.serverEvent = item.params and item.params.isServer and item.params.event
        opt.args = item.params and item.params.args
        opt.notUnpack = item.params and item.params.notUnpack
        opt.disabled = item.disabled or false
        opt.onHoverId = item.onHoverId
        
        if item.isMenuHeader then
            opt.title = item.header
        elseif item.submenu then
            opt.submenu = UI:Rcore(item.submenu)
        end
        return opt
    end
    
    local options = {}
    for _, v in ipairs(data) do
        table.insert(options, parse(v))
    end
    return options
end

function UI.Esx(self, data)
    local function parse(item)
        local opt = {}
        opt.label = item.header or item.title
        opt.args = item.params and item.params.args
        
        if item.header and item.txt and item.header ~= item.txt then
            opt.title = item.header .. " - " .. item.txt
        elseif item.title and item.description then
            opt.title = item.title .. " - " .. item.description
        elseif item.header then
            opt.title = item.header
        end
        
        if item.params then
            if not item.params.isServer then opt.event = item.params.event
            else opt.serverEvent = item.params.event end
            opt.icon = item.params.icon
            if type(item.params.onClick) == "function" then
                opt.onClick = item.params.onClick
            end
        end
        if item.disabled then opt.disabled = true end
        return opt
    end
    
    local function formatOptions(list, parent)
        for _, item in ipairs(list) do
            local opt = parse(item)
            if item.isMenuHeader then opt.disabled = true end
            if item.submenu then
                opt.submenu = { options = {} }
                formatOptions(item.submenu, opt.submenu)
            end
            table.insert(parent.options, opt)
        end
    end
    
    local result = { options = {} }
    formatOptions(data, result)
    
    if Config.Menu == Menu.ESX_MENU then
        UI:RenderESXMenu(result, self.currentName, self.currentLabel)
    elseif Config.Menu == Menu.ESX_CONTEXT then
        UI:RenderESXContext(result, self.currentName, self.currentLabel)
    end
end

function UI.RemoveHeaderFromArray(self, data)
    if not data then return end
    if type(data) == "table" then
        table.remove(data, 1)
        dbg.debug("Frontend - removed isMenuHeader from array.")
    end
end

function UI.Ox(self, data)
    UI:RemoveHeaderFromArray(data)
    
    local function build(list, id, parentId)
        local ctx = {
            id = id,
            title = _c(self.currentLabel),
            options = {}
        }
        
        if parentId then
            table.insert(ctx.options, {
                title = _U("MENUS.GO_BACK_BUTTON_LABEL"),
                menu = parentId
            })
        end
        
        local p = promise.new()
        for i, item in ipairs(list) do
            local opt = {}
            if item.header then opt.title = item.header end
            if item.description then opt.description = item.description end
            
            if item.params then
                if not item.params.isServer then opt.event = item.params.event
                else 
                    opt.serverEvent = item.params.event
                    opt.args = item.params.args
                end
                opt.icon = item.params.icon
                opt.args = item.params.args
            end
            
            if item.disabled then opt.disabled = true end
            if item.submenu then
                local subId = id .. "_submenu_" .. tostring(i)
                opt.menu = subId
                build(item.submenu, subId, id)
            end
            
            table.insert(ctx.options, opt)
            if i == #list then p:resolve(true) end
        end
        
        Citizen.Await(p)
        lib.registerContext(ctx)
    end
    
    build(data, self.currentName, nil)
    Wait(0)
    return true
end

function UI.QBMenu(self, data)
    local function parse(list, id, parentId)
        local opts = {}
        if Frontend[id] then return exports["qb-menu"]:openMenu(Frontend[id]) end
        
        if parentId then
            table.insert(opts, {
                header = _U("MENUS.GO_BACK_BUTTON_LABEL"),
                params = { event = "qb-go-back" }
            })
            AddEventHandler("qb-go-back", function()
                if #Frontend.Menus > 0 then
                    local parentOpts = table.remove(Frontend.Menus)
                    exports["qb-menu"]:openMenu(parentOpts)
                end
            end)
        end
        
        for i, item in ipairs(list) do
            local opt = {}
            if item.header then opt.header = item.header end
            if item.description then opt.txt = item.description end
            
            if item.params then
                if item.params.isClient then
                    opt.params = { event = item.params.event, args = item.params.args }
                elseif item.params.isServer then
                    opt.params = { event = item.params.event, args = item.params.args, isServer = true }
                end
                if item.params.icon then opt.icon = item.params.icon end
            end
            
            if item.disabled then opt.disabled = true end
            if item.submenu then
                opt.params = opt.params or {}
                local subId = id .. "_submenu_" .. tostring(i)
                opt.params.event = "qb-open-submenu-" .. subId
                opt.params.args = item.submenu
                
                AddEventHandler(opt.params.event, function(submenuArgs)
                    table.insert(Frontend.Menus, opts)
                    if Frontend[subId] then
                        exports["qb-menu"]:openMenu(Frontend[subId])
                    else
                        parse(submenuArgs, subId, true)
                    end
                end)
            end
            table.insert(opts, opt)
        end
        
        Frontend[id] = opts
        exports["qb-menu"]:openMenu(opts)
    end
    
    parse(data, self.currentName, false)
    return true
end

function UI.CreateMenu(self, name, label, data, open)
    open = open or false
    if not name then return error("Frontend - failed to create menu, undefined name.") end
    if not data then return error("Frontend - failed to create menu, undefined menu data.") end
    if not label then return error("Frontend - failed to create menu, undefined menu menuLabel.") end
    if not Config.Menu then return error("Undefined library.") end
    
    if not Frontend.Menus[name] then
        Frontend.Menus[name] = { data = data }
    end
    self.currentName = name
    self.currentLabel = label
    
    dbg.debug("Using frontend library -> [%s]", Config.Menu)
    
    if open then
        if Config.Menu == Menu.QB then
            UI:ParseData(data, function() dbg.debug("Opened menu named [%s]", self.currentName) end)
        elseif Config.Menu == Menu.OX then
            if not lib then return error("Frontend - failed to create menu, ox_lib not hooked") end
            UI:ParseData(data, function()
                dbg.debug("Opened menu named [%s]", self.currentName)
                lib.showContext(self.currentName)
            end)
        elseif Config.Menu == Menu.ESX_MENU or Config.Menu == Menu.ESX_CONTEXT then
            if not Framework then return error("Frontend - failed to create menu, esx_menu_list or esx_context not hooked") end
            UI:ParseData(data, function() dbg.info("Opened menu named [%s]", self.currentName) end)
        elseif Config.Menu == Menu.RCORE then
            UI:ParseData(data, function() dbg.info("Opened menu named [%s]", self.currentName) end)
        elseif Config.Menu == Menu.NONE or Config.Menu == nil then
            UI:CreateMenuStandalone(name, label, data, open)
        end
    end
    
    dbg.debug("Menu finished return state.")
end
