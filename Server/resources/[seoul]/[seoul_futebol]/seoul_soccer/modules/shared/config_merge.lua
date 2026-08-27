--[[
  Merges config.lua overrides on top of config_defaults.lua.
  Edit config.lua for server settings; avoid editing config_defaults.lua unless you know why.
]]

local function is_dense_array(t)
    if type(t) ~= "table" then return false end
    local n = #t
    if n == 0 then return false end
    local c = 0
    for _ in pairs(t) do
        c = c + 1
    end
    return c == n
end

local function deep_merge_defaults(base, override)
    if type(base) ~= "table" then
        return override
    end
    if type(override) ~= "table" then
        return override
    end
    if is_dense_array(override) then
        return override
    end
    local out = {}
    for k, v in pairs(base) do
        out[k] = v
    end
    for k, v in pairs(override) do
        local bv = base[k]
        if type(v) == "table" and type(bv) == "table" and not is_dense_array(v) then
            out[k] = deep_merge_defaults(bv, v)
        else
            out[k] = v
        end
    end
    return out
end

function SoccerApplyConfigDefaults()
    local defaults = SoccerConfigDefaults
    if type(defaults) ~= "table" then
        error("[seoul_soccer] SoccerConfigDefaults failed to load (config_defaults.lua missing or invalid).")
    end
    local user = _G.Config or {}
    _G.Config = deep_merge_defaults(defaults, user)
    Config = _G.Config
end
