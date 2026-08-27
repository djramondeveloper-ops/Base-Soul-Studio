--- Fallback target API for Seoul interact/ox_target.
local oxZones = {}
local interactCoords = {}

local function normalizeOptions(arg5, arg6)
    if type(arg6) == 'table' and (arg6[1] or arg6.options or arg6.label) then
        return arg6
    end

    if type(arg5) ~= 'table' then
        return nil
    end

    if arg5.options then
        return arg5.options
    end

    if arg5[1] or arg5.label then
        return arg5
    end

    if arg5.minZ or arg5.maxZ then
        return arg6
    end

    return arg5
end

local function toOxOptions(raw)
    if type(raw) ~= 'table' then
        return nil
    end

    local out = {}
    local n = 0

    local function push(opt, index)
        if type(opt) ~= 'table' or not opt.label or not opt.action then
            return
        end

        n = n + 1
        out[n] = {
            name = opt.name or ('nn_petshop_opt_%s'):format(index or n),
            icon = opt.icon or 'fas fa-circle',
            label = opt.label,
            distance = opt.distance or 2.5,
            canInteract = opt.canInteract,
            onSelect = function(data)
                opt.action(data and data.entity or data)
            end,
        }
    end

    for i, opt in ipairs(raw) do
        push(opt, i)
    end

    if n == 0 then
        for key, opt in pairs(raw) do
            if type(key) == 'number' then
                push(opt, key)
            end
        end
    end

    if n == 0 then
        return nil
    end

    return out
end

local function toInteractOptions(raw)
    if type(raw) ~= 'table' then
        return nil
    end

    local out = {}
    local n = 0

    local function push(opt, index)
        if type(opt) ~= 'table' or not opt.label or not opt.action then
            return
        end

        n = n + 1
        out[n] = {
            name = opt.name or ('nn_petshop_interact_%s'):format(index or n),
            icon = opt.icon or 'fas fa-circle',
            label = opt.label,
            distance = opt.distance or 2.5,
            canInteract = opt.canInteract,
            onSelect = function(data)
                opt.action(data and data.entity or data)
            end,
        }
    end

    for i, opt in ipairs(raw) do
        push(opt, i)
    end

    if n == 0 then
        for key, opt in pairs(raw) do
            if type(key) == 'number' then
                push(opt, key)
            end
        end
    end

    if n == 0 then
        return nil
    end

    return out
end

local interactAdapter = {
    AddBoxZone = function(name, coords, _size, _heading, arg5, arg6)
        if GetResourceState('interact') ~= 'started' then
            return false
        end

        local raw = normalizeOptions(arg5, arg6)
        local options = toInteractOptions(raw)
        if not options then
            print(('^3[nn_petshop]^0 interact: no options for zone %s'):format(tostring(name)))
            return false
        end

        local center = coords
        if type(center) == 'vector4' then
            center = vector3(center.x, center.y, center.z)
        elseif type(center) == 'table' and center.x and center.y and center.z then
            center = vector3(center.x, center.y, center.z)
        end

        local ok, idOrErr = pcall(function()
            return exports.interact:addCoords(center, options)
        end)

        if not ok then
            print(('^1[nn_petshop]^0 interact addCoords failed (%s): %s'):format(tostring(name), idOrErr))
            return false
        end

        interactCoords[name] = idOrErr
        return true
    end,

    AddLocalEntity = function(entity, options)
        if GetResourceState('interact') ~= 'started' then
            return false
        end

        local interactOptions = toInteractOptions(options)
        if not interactOptions then
            return false
        end

        exports.interact:addLocalEntity(entity, interactOptions)
        return true
    end,

    RemoveLocalEntity = function(entity)
        if GetResourceState('interact') == 'started' then
            exports.interact:removeLocalEntity(entity)
        end
    end,

    removeLocalEntity = function(entity)
        if GetResourceState('interact') == 'started' then
            exports.interact:removeLocalEntity(entity)
        end
    end,
}

local oxAdapter = {
    --- Target style: AddBoxZone(name, coords, size, heading, zoneData?, options?)
    --- nn_petshop passes processed options as 5th arg only.
    AddBoxZone = function(name, coords, size, heading, arg5, arg6)
        if GetResourceState('ox_target') ~= 'started' then
            return false
        end

        local raw = normalizeOptions(arg5, arg6)
        local oxOptions = toOxOptions(raw)
        if not oxOptions then
            print(('^3[nn_petshop]^0 ox_target: no options for zone %s'):format(tostring(name)))
            return false
        end

        local ok, err = pcall(function()
            exports.ox_target:addBoxZone({
                name = name,
                coords = coords,
                size = size,
                rotation = heading or 0.0,
                debug = false,
                options = oxOptions,
            })
        end)

        if not ok then
            print(('^1[nn_petshop]^0 ox_target addBoxZone failed (%s): %s'):format(tostring(name), err))
            return false
        end

        oxZones[name] = true
        return true
    end,

    AddLocalEntity = function(entity, options)
        if GetResourceState('ox_target') ~= 'started' then
            return false
        end

        local oxOptions = toOxOptions(options)
        if not oxOptions then
            return false
        end

        exports.ox_target:addLocalEntity(entity, oxOptions)
        return true
    end,

    RemoveLocalEntity = function(entity, _name, _invoker)
        if GetResourceState('ox_target') == 'started' then
            exports.ox_target:removeLocalEntity(entity)
        end
    end,

    removeLocalEntity = function(entity, _name, _invoker)
        if GetResourceState('ox_target') == 'started' then
            exports.ox_target:removeLocalEntity(entity)
        end
    end,
}

local splitAdapter = {
    AddBoxZone = function(...)
        if GetResourceState('interact') == 'started' then
            return interactAdapter.AddBoxZone(...)
        end

        return oxAdapter.AddBoxZone(...)
    end,

    AddLocalEntity = function(...)
        if GetResourceState('ox_target') == 'started' then
            return oxAdapter.AddLocalEntity(...)
        end

        return false
    end,

    RemoveLocalEntity = function(...)
        if GetResourceState('ox_target') == 'started' then
            return oxAdapter.RemoveLocalEntity(...)
        end
    end,

    removeLocalEntity = function(...)
        if GetResourceState('ox_target') == 'started' then
            return oxAdapter.removeLocalEntity(...)
        end
    end,
}

function GetNnPetshopTargetModule()
    local hasInteract = GetResourceState('interact') == 'started'
    local hasOxTarget = GetResourceState('ox_target') == 'started'

    if hasInteract or hasOxTarget then
        print(('^2[nn_petshop]^0 Target: shops=%s pets=%s'):format(hasInteract and 'interact' or 'ox_target', hasOxTarget and 'ox_target' or 'disabled'))
        return splitAdapter
    end

    print('^3[nn_petshop]^0 No target system - use /petshop (Config.Shortcuts.petshopCommand)')
    return nil
end
