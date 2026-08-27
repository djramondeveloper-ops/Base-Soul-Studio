local NewItems = GlobalState["AdminControlItems"] or {}

AddStateBagChangeHandler("AdminControlItems","",function(_,_,value)
    NewItems = value or {}
end)

local editItem

local function itemCount(tbl)
    local count = 0
    for _ in pairs(tbl or {}) do count = count + 1 end
    return count
end

local function yesNo(value)
    return value and "sim" or "não"
end

local function lower(value)
    return string.lower(tostring(value or ""))
end

local function weaponKind(item, data)
    data = data or {}
    local kind = lower(data.weaponKind or data.weapon_kind or data.weaponType or data.weapon_type or data.category or data.Category or data.kind or data.Kind or "")
    local typeLower = lower(data.type or data.Type or "")
    local itemLower = lower(item or "")
    if kind:find("tint", 1, true) or kind:find("tinta", 1, true) or typeLower:find("tinta", 1, true) then return "tint" end
    if kind:find("component", 1, true) or kind:find("attach", 1, true) or kind:find("anexo", 1, true) or typeLower:find("component", 1, true) or typeLower:find("anexo", 1, true) then return "component" end
    if kind:find("ammo", 1, true) or kind:find("muni", 1, true) or typeLower:find("ammo", 1, true) or typeLower:find("muni", 1, true) then return "ammo" end
    if tostring(item or ""):match("^WEAPON_.+_AMMO$") or itemLower:find("^ammo%-") then return "ammo" end
    if tostring(item or ""):match("^WEAPON_") or typeLower:find("arma", 1, true) or typeLower:find("weapon", 1, true) then return "weapon" end
    if itemLower:find("^at_") then return "component" end
    return "common"
end

local function openReportMenu()
    local report = lib.callback.await("AdminControl:getItemsReport", false)
    if not report then return end

    local options = {
        {
            title = "Resumo",
            description = ("Staging: %s | comuns: %s | vRP: %s | OX: %s"):format(report.total or 0, report.normal or 0, report.inVrp or 0, report.inOx or 0),
            icon = "circle-info",
            iconColor = "blue"
        },
        {
            title = "Sincronizar runtime",
            description = "Reenvia os itens comuns do AdminControl para vRP/OX.",
            icon = "rotate",
            iconColor = "green",
            onSelect = function() TriggerServerEvent("AdminControl:syncRuntimeItems") end
        },
        {
            title = "Auditoria avançada",
            description = ("Erros: %s | armas/munições fora desta tela: %s | imagens só no debug"):format(report.errors or 0, report.skipped or 0),
            icon = "bug",
            iconColor = "yellow",
            onSelect = function() TriggerServerEvent("AdminControl:validateItems") end
        }
    }

    for _, item in ipairs(report.items or {}) do
        local desc = ("%s | Peso: %skg | vRP: %s | OX: %s"):format(item.label or item.item, item.weight or 0, yesNo(item.inVrp), yesNo(item.inOx))
        options[#options + 1] = {
            title = item.item,
            description = desc,
            icon = (item.inVrp and item.inOx) and "circle-check" or "triangle-exclamation",
            iconColor = (item.inVrp and item.inOx) and "green" or "orange",
            onSelect = function() editItem(item.item) end
        }
    end

    lib.registerContext({ id = "admin_items_report", title = "Status dos Itens Comuns", menu = "admin_items_control", options = options })
    lib.showContext("admin_items_report")
end

local function openWeaponsReportMenu()
    local report = lib.callback.await("AdminControl:getWeaponsReport", false)
    if not report then return end

    local options = {
        {
            title = "Resumo weapons.lua",
            description = ("Total: %s | Armas: %s | Ammo: %s | Componentes: %s | Tintas: %s"):format(report.total or 0, report.weapons or 0, report.ammo or 0, report.components or 0, report.tints or 0),
            icon = "gun",
            iconColor = "orange"
        },
        {
            title = "Presença vRP/OX",
            description = ("vRP: %s | OX: %s | OX runtime: %s | erros: %s"):format(report.inVrp or 0, report.inOx or 0, report.inOxRuntime or 0, report.errors or 0),
            icon = "circle-info",
            iconColor = "blue"
        },
        {
            title = "Sincronizar runtime weapons",
            description = "Reenvia armas/munições/componentes/tintas para vRP/OX runtime.",
            icon = "rotate",
            iconColor = "green",
            onSelect = function() TriggerServerEvent("AdminControl:syncRuntimeWeapons") end
        },
        {
            title = "Validar weapons.lua",
            description = "Checa campos obrigatórios antes de gerar arquivo.",
            icon = "magnifying-glass",
            iconColor = "yellow",
            onSelect = function() TriggerServerEvent("AdminControl:validateWeapons") end
        }
    }

    for _, item in ipairs(report.items or {}) do
        local desc = ("%s | Tipo: %s | Peso: %skg | vRP: %s | OX: %s"):format(item.label or item.item, item.kind or "?", item.weight or 0, yesNo(item.inVrp), yesNo(item.inOx))
        if item.ammoName and item.ammoName ~= "" then desc = desc .. " | ammo: " .. item.ammoName end
        if item.componentType and item.componentType ~= "" then desc = desc .. " | comp: " .. item.componentType end
        options[#options + 1] = {
            title = item.item,
            description = desc,
            icon = (item.inVrp and item.inOx) and "circle-check" or "triangle-exclamation",
            iconColor = (item.inVrp and item.inOx) and "green" or "orange",
            onSelect = function() editItem(item.item) end
        }
    end

    lib.registerContext({ id = "admin_weapons_report", title = "Status Weapons.lua", menu = "admin_items_control", options = options })
    lib.showContext("admin_weapons_report")
end

local function duplicateItem(item)
    local data = NewItems[item] or {}
    local input = lib.inputDialog("Duplicar item",{
        {type = "input", label = "Novo item", description = "Nome interno do novo item", required = true},
        {type = "input", label = "Nome visual", default = tostring(data.name or data.Name or item) .. " Cópia", required = true}
    })
    if input and input[1] then
        local copy = {}
        for k,v in pairs(data) do copy[k] = v end
        copy.item = input[1]
        copy.name = input[2] or input[1]
        copy.index = input[1]
        TriggerServerEvent("AdminControl:createNewItem", copy)
    end
end

local function createCommonItem()
    local input = lib.inputDialog("Criar item comum",{
        {type = "input", label = "Item", description = "Nome interno. Ex: radio, lb_tablet", required = true},
        {type = "input", label = "Nome do item", required = true},
        {type = "input", label = "Index/imagem", description = "Nome da imagem sem .png. Vazio = nome do item"},
        {type = "select", label = "Tipo", default = "Comum", options = {
            {label = "Comum", value = "Comum"},
            {label = "Consumível", value = "Consumível"},
            {label = "Ferramenta", value = "Ferramenta"},
            {label = "Documento", value = "Documento"}
        }},
        {type = "textarea", label = "Descrição"},
        {type = "number", label = "Peso KG", default = 0.5, min = 0},
        {type = "input", label = "Evento ao usar", description = "Opcional. Ex: lb-tablet:openFromItem"},
        {type = "select", label = "Tipo do evento", default = "Client", options = {
            {label = "Client", value = "Client"},
            {label = "Server", value = "Server"}
        }},
        {type = "checkbox", label = "Stack no OX", checked = true},
        {type = "checkbox", label = "Fechar inventário ao usar", checked = true}
    })
    if input and input[1] then
        TriggerServerEvent("AdminControl:createNewItem",{
            item = input[1], name = input[2] or input[1], index = input[3] ~= "" and input[3] or input[1], type = input[4] or "Comum",
            description = input[5], weight = input[6] or 0.5, event = input[7] ~= "" and input[7] or nil,
            eventType = input[8] or "Client", stack = input[9] == true, close = input[10] == true
        })
    end
end

local function createWeaponItem()
    local input = lib.inputDialog("Criar arma",{
        {type = "input", label = "WEAPON_", description = "Ex: WEAPON_PISTOL ou WEAPON_CUSTOM", required = true},
        {type = "input", label = "Nome visual", required = true},
        {type = "input", label = "Index/imagem", description = "Sem .png. Vazio = nome da arma"},
        {type = "number", label = "Peso KG", default = 1.5, min = 0},
        {type = "input", label = "Munição OX", description = "Ex: ammo-9, ammo-rifle. Vazio para arma branca"},
        {type = "input", label = "Munição vRP", description = "Opcional. Ex: WEAPON_PISTOL_AMMO"},
        {type = "number", label = "Durabilidade OX", default = 0.05, min = 0},
        {type = "number", label = "Durabilidade vRP", default = 240, min = 0},
        {type = "input", label = "Model", description = "Opcional. Vazio = próprio WEAPON_"},
        {type = "checkbox", label = "Throwable/arremessável", checked = false}
    })
    if input and input[1] then
        TriggerServerEvent("AdminControl:createNewItem",{
            item = input[1], name = input[2] or input[1], index = input[3] ~= "" and input[3] or input[1], type = "Arma", weaponKind = "weapon",
            weight = input[4] or 1.5, ammoname = input[5] ~= "" and input[5] or nil, vrpAmmo = input[6] ~= "" and input[6] or nil,
            oxDurability = input[7] or 0.05, vrpDurability = input[8] or 240, model = input[9] ~= "" and input[9] or nil, throwable = input[10] == true
        })
    end
end

local function createAmmoItem()
    local input = lib.inputDialog("Criar munição",{
        {type = "input", label = "Item da munição", description = "Ex: ammo-9 ou WEAPON_PISTOL_AMMO", required = true},
        {type = "input", label = "Nome visual", required = true},
        {type = "input", label = "Index/imagem", description = "Sem .png. Vazio = nome do item"},
        {type = "number", label = "Peso KG", default = 0.01, min = 0},
        {type = "textarea", label = "Descrição"}
    })
    if input and input[1] then
        TriggerServerEvent("AdminControl:createNewItem",{
            item = input[1], name = input[2] or input[1], index = input[3] ~= "" and input[3] or input[1], type = "Munição", weaponKind = "ammo",
            weight = input[4] or 0.01, description = input[5]
        })
    end
end

local function createComponentItem()
    local input = lib.inputDialog("Criar componente/anexo",{
        {type = "input", label = "Item do anexo", description = "Ex: at_flashlight", required = true},
        {type = "input", label = "Nome visual", required = true},
        {type = "input", label = "Tipo do componente", description = "Ex: flashlight, magazine, suppressor, scope, skin", default = "attachment"},
        {type = "input", label = "Hashes COMPONENT_", description = "Separados por vírgula. Ex: COMPONENT_AT_PI_FLSH", required = true},
        {type = "input", label = "Index/imagem", description = "Sem .png. Vazio = item"},
        {type = "number", label = "Peso KG", default = 0.05, min = 0},
        {type = "number", label = "Tempo de uso", default = 2500, min = 0}
    })
    if input and input[1] then
        TriggerServerEvent("AdminControl:createNewItem",{
            item = input[1], name = input[2] or input[1], type = "Componente", weaponKind = "component",
            componentType = input[3] ~= "" and input[3] or "attachment", component = input[4], index = input[5] ~= "" and input[5] or input[1],
            weight = input[6] or 0.05, usetime = input[7] or 2500
        })
    end
end

local function createTintItem()
    local input = lib.inputDialog("Criar tinta",{
        {type = "input", label = "Item da tinta", description = "Ex: tint_gold ou at_tint_gold", required = true},
        {type = "input", label = "Nome visual", required = true},
        {type = "number", label = "Índice da tinta", default = 0, min = 0},
        {type = "input", label = "Index/imagem", description = "Sem .png. Vazio = item"},
        {type = "number", label = "Peso KG", default = 0.05, min = 0}
    })
    if input and input[1] then
        TriggerServerEvent("AdminControl:createNewItem",{
            item = input[1], name = input[2] or input[1], type = "Tinta", weaponKind = "tint", tint = input[3] or 0,
            index = input[4] ~= "" and input[4] or input[1], weight = input[5] or 0.05
        })
    end
end

editItem = function(item)
    local data = NewItems[item] or {}
    local kind = weaponKind(item, data)

    if kind == "weapon" then
        local input = lib.inputDialog("Editar arma",{
            {type = "input", label = "Item", default = item, disabled = true},
            {type = "input", label = "Nome visual", default = data.name or data.Name or item, required = true},
            {type = "input", label = "Index/imagem", default = data.index or data.Index or item},
            {type = "number", label = "Peso KG", default = data.weight or data.Weight or 1.5, min = 0},
            {type = "input", label = "Munição OX", default = data.ammoname or data.ammoName or data.ammo or ""},
            {type = "input", label = "Munição vRP", default = data.vrpAmmo or data.vrp_ammo or ""},
            {type = "number", label = "Durabilidade OX", default = data.oxDurability or data.durability or 0.05, min = 0},
            {type = "number", label = "Durabilidade vRP", default = data.vrpDurability or 240, min = 0},
            {type = "input", label = "Model", default = data.model or ""},
            {type = "checkbox", label = "Throwable/arremessável", checked = data.throwable == true}
        })
        if input then TriggerServerEvent("AdminControl:editNewItem",{ item = item, name = input[2] or item, index = input[3] ~= "" and input[3] or item, type = "Arma", weaponKind = "weapon", weight = input[4] or 1.5, ammoname = input[5] ~= "" and input[5] or nil, vrpAmmo = input[6] ~= "" and input[6] or nil, oxDurability = input[7] or 0.05, vrpDurability = input[8] or 240, model = input[9] ~= "" and input[9] or nil, throwable = input[10] == true }) end
        return
    elseif kind == "ammo" then
        local input = lib.inputDialog("Editar munição",{
            {type = "input", label = "Item", default = item, disabled = true},
            {type = "input", label = "Nome visual", default = data.name or data.Name or item, required = true},
            {type = "input", label = "Index/imagem", default = data.index or data.Index or item},
            {type = "number", label = "Peso KG", default = data.weight or data.Weight or 0.01, min = 0},
            {type = "textarea", label = "Descrição", default = data.description or data.Description or ""}
        })
        if input then TriggerServerEvent("AdminControl:editNewItem",{ item = item, name = input[2] or item, index = input[3] ~= "" and input[3] or item, type = "Munição", weaponKind = "ammo", weight = input[4] or 0.01, description = input[5] }) end
        return
    elseif kind == "component" then
        local input = lib.inputDialog("Editar componente",{
            {type = "input", label = "Item", default = item, disabled = true},
            {type = "input", label = "Nome visual", default = data.name or data.Name or item, required = true},
            {type = "input", label = "Tipo do componente", default = data.componentType or data.component_type or "attachment"},
            {type = "input", label = "Hashes COMPONENT_", default = data.component or data.Component or data.hash or "", required = true},
            {type = "input", label = "Index/imagem", default = data.index or data.Index or item},
            {type = "number", label = "Peso KG", default = data.weight or data.Weight or 0.05, min = 0},
            {type = "number", label = "Tempo de uso", default = data.usetime or data.useTime or 2500, min = 0}
        })
        if input then TriggerServerEvent("AdminControl:editNewItem",{ item = item, name = input[2] or item, type = "Componente", weaponKind = "component", componentType = input[3] ~= "" and input[3] or "attachment", component = input[4], index = input[5] ~= "" and input[5] or item, weight = input[6] or 0.05, usetime = input[7] or 2500 }) end
        return
    elseif kind == "tint" then
        local input = lib.inputDialog("Editar tinta",{
            {type = "input", label = "Item", default = item, disabled = true},
            {type = "input", label = "Nome visual", default = data.name or data.Name or item, required = true},
            {type = "number", label = "Índice da tinta", default = data.tint or data.Tint or 0, min = 0},
            {type = "input", label = "Index/imagem", default = data.index or data.Index or item},
            {type = "number", label = "Peso KG", default = data.weight or data.Weight or 0.05, min = 0}
        })
        if input then TriggerServerEvent("AdminControl:editNewItem",{ item = item, name = input[2] or item, type = "Tinta", weaponKind = "tint", tint = input[3] or 0, index = input[4] ~= "" and input[4] or item, weight = input[5] or 0.05 }) end
        return
    end

    local execute = data.Execute or data.execute or {}
    local event = data.event or data.Event or data.clientEvent or data.serverEvent or execute.Event or execute.event or ""
    local eventType = data.eventType or data.executeType or execute.Type or execute.type or "Client"
    local input = lib.inputDialog("Editar item",{
        {type = "input", label = "Item", default = item, disabled = true},
        {type = "input", label = "Nome do item", default = data.name or data.Name or item, required = true},
        {type = "input", label = "Index/imagem", default = data.index or data.Index or item},
        {type = "select", label = "Tipo", default = data.type or data.Type or "Comum", options = {
            {label = "Comum", value = "Comum"}, {label = "Consumível", value = "Consumível"}, {label = "Ferramenta", value = "Ferramenta"}, {label = "Documento", value = "Documento"}
        }},
        {type = "textarea", label = "Descrição", default = data.description or data.Description},
        {type = "number", label = "Peso KG", default = data.weight or data.Weight or 0.5, min = 0},
        {type = "input", label = "Evento ao usar", default = event},
        {type = "select", label = "Tipo do evento", default = eventType, options = { {label = "Client", value = "Client"}, {label = "Server", value = "Server"} }},
        {type = "checkbox", label = "Stack no OX", checked = data.stack ~= false},
        {type = "checkbox", label = "Fechar inventário ao usar", checked = data.close ~= false}
    })
    if input then
        TriggerServerEvent("AdminControl:editNewItem",{ item = item, name = input[2] or item, index = input[3] ~= "" and input[3] or item, type = input[4] or "Comum", description = input[5], weight = input[6] or 0.5, event = input[7] ~= "" and input[7] or nil, eventType = input[8] or "Client", stack = input[9] == true, close = input[10] == true })
    end
end

local function listItems()
    local options = {}
    if itemCount(NewItems) == 0 then options[#options + 1] = { title = "Nenhum item cadastrado", description = "Crie um item primeiro.", icon = "box-open" } end
    for k,v in pairs(NewItems or {}) do
        local kind = weaponKind(k, v)
        local typeLabel = kind == "weapon" and "Arma" or kind == "ammo" and "Munição" or kind == "component" and "Componente" or kind == "tint" and "Tinta" or tostring(v.type or v.Type or "Comum")
        options[#options + 1] = {
            title = k,
            description = tostring(v.name or v.Name or k).."\nTipo: "..typeLabel.." | Peso: "..tostring(v.weight or v.Weight or 0).."kg",
            icon = kind ~= "common" and "gun" or "box",
            iconColor = kind ~= "common" and "orange" or "blue",
            onSelect = function()
                lib.registerContext({ id = 'admin_items_manage', title = 'Item: '..k, menu = 'admin_items_list', options = {
                    { title = 'Editar item', icon = 'toolbox', iconColor = 'green', onSelect = function() editItem(k) end },
                    { title = 'Duplicar item', icon = 'copy', iconColor = 'blue', onSelect = function() duplicateItem(k) end },
                    { title = 'Remover do AdminControl', icon = 'trash', iconColor = 'red', onSelect = function()
                        local confirm = lib.alertDialog({ header = 'Remover item?', content = 'Remove apenas do AdminControl/data/items.json. Para tirar dos arquivos gerados, rode o gerador correspondente depois.', centered = true, cancel = true })
                        if confirm == 'confirm' then TriggerServerEvent("AdminControl:deleteNewItem",k) end
                    end }
                }})
                lib.showContext('admin_items_manage')
            end
        }
    end
    table.sort(options,function(a,b) return tostring(a.title) < tostring(b.title) end)
    lib.registerContext({ id = 'admin_items_list', title = 'Itens do AdminControl', menu = 'admin_items_control', options = options })
    lib.showContext('admin_items_list')
end

RegisterNetEvent("AdminControl:openItems",function()
    lib.registerContext({
        id = 'admin_items_control',
        title = 'Controle dos Itens',
        options = {
            { title = 'Criar item comum', description = 'Gera vRP Item.lua + OX items.lua', icon = 'plus', iconColor = 'green', onSelect = createCommonItem },
            { title = 'Criar arma', description = 'Gera vRP Item.lua + OX weapons.lua', icon = 'gun', iconColor = 'orange', onSelect = createWeaponItem },
            { title = 'Criar munição', description = 'Ammo do weapons.lua', icon = 'boxes-stacked', iconColor = 'orange', onSelect = createAmmoItem },
            { title = 'Criar componente/anexo', description = 'Componentes do weapons.lua', icon = 'screwdriver-wrench', iconColor = 'orange', onSelect = createComponentItem },
            { title = 'Criar tinta', description = 'Tints do weapons.lua', icon = 'palette', iconColor = 'orange', onSelect = createTintItem },
            { title = 'Listar itens', description = 'Editar/remover qualquer cadastro do AdminControl', icon = 'list', iconColor = 'blue', onSelect = listItems },
            { title = 'Status dos itens comuns', description = 'vRP Item.lua + ox_inventory/data/items.lua', icon = 'chart-simple', iconColor = 'blue', onSelect = openReportMenu },
            { title = 'Status weapons.lua', description = 'Armas, munições, componentes e tintas', icon = 'chart-simple', iconColor = 'orange', onSelect = openWeaponsReportMenu },
            { title = 'Validar itens comuns', description = 'Imagem não bloqueia.', icon = 'magnifying-glass', iconColor = 'yellow', onSelect = function() TriggerServerEvent("AdminControl:validateItems") end },
            { title = 'Validar weapons.lua', description = 'Checa armas/munições/componentes/tintas.', icon = 'magnifying-glass', iconColor = 'yellow', onSelect = function() TriggerServerEvent("AdminControl:validateWeapons") end },
            { title = 'Gerar itens comuns', description = 'Atualiza vRP Item.lua + OX items.lua', icon = 'gears', iconColor = 'green', onSelect = function()
                local confirm = lib.alertDialog({ header = 'Gerar itens comuns?', content = 'Atualiza apenas itens comuns em vRP Item.lua + ox_inventory/data/items.lua. Depois reinicie ox_inventory para reload limpo.', centered = true, cancel = true })
                if confirm == 'confirm' then TriggerServerEvent("AdminControl:generateItems") end
            end },
            { title = 'Gerar weapons.lua', description = 'Atualiza armas/munições/componentes/tintas em vRP + OX weapons.lua', icon = 'gears', iconColor = 'orange', onSelect = function()
                local confirm = lib.alertDialog({ header = 'Gerar weapons.lua?', content = 'Cria backup e atualiza ox_inventory/data/weapons.lua + bloco compat no vRP Item.lua. Depois reinicie ox_inventory.', centered = true, cancel = true })
                if confirm == 'confirm' then TriggerServerEvent("AdminControl:generateWeapons") end
            end }
        }
    })
    lib.showContext('admin_items_control')
end)
