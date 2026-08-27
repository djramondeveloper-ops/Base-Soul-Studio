-- =====================================================
--  rcore_police · modules/base/server/lifecycle/init/sv-l-preset_creator.lua
--  Engineered by Eazy Fxap
--  Original: 272 lines → Cleaned: 65 lines
-- =====================================================

RegisterNetEvent("rcore_police:server:requestPresetCreation", function(presetName, data)
    local src = source
    if not Framework.isAdmin(src) then return end
    
    saveLuaTableToFile(("%s.lua"):format(presetName), data, presetName)
end)

function tableToLuaCode(tbl, indentLevel)
    if not indentLevel then indentLevel = 0 end
    local lines = {}
    local indent = string.rep(" ", indentLevel)
    table.insert(lines, "{")
    
    local isArray = true
    local arrayIndex = 1
    for k, _ in pairs(tbl) do
        if k ~= arrayIndex then
            isArray = false
            break
        end
        arrayIndex = arrayIndex + 1
    end
    
    for k, v in pairs(tbl) do
        local keyStr = ""
        if not isArray then
            if type(k) == "string" then
                if k:match("^[a-zA-Z_][a-zA-Z0-9_]*$") then
                    keyStr = k .. " = "
                else
                    keyStr = string.format("[%q] = ", tostring(k))
                end
            else
                keyStr = string.format("[%q] = ", tostring(k))
            end
        end
        
        local valStr = ""
        if type(v) == "table" then
            valStr = tableToLuaCode(v, indentLevel + 4)
        elseif type(v) == "string" then
            if not v:match("^vec3%b()$") and not v:match("^vector3%b()$") and not v:match("^_U%b()$") then
                if keyStr:find("label") and v:match("^ZONES_LABELS%.[A-Z_]+$") then
                    valStr = "_U(\"" .. v .. "\")"
                elseif keyStr:find("type") and v:match("^[A-Z_]+$") then
                    valStr = "ZONE_TYPE." .. v
                else
                    valStr = string.format("%q", v)
                end
            else
                valStr = v
            end
        elseif type(v) == "boolean" then
            valStr = v and "true" or "false"
        else
            valStr = tostring(v)
        end
        
        table.insert(lines, string.format("%s    %s%s,", indent, keyStr, valStr))
    end
    
    table.insert(lines, indent .. "}")
    return table.concat(lines, "\n")
end

function generateLuaCodeForMap(mapName, mapData)
    local lines = {}
    table.insert(lines, "CreateThread(function())")
    table.insert(lines, string.format("    Maps[%q] = %s", mapName, tableToLuaCode(mapData, 4)))
    table.insert(lines, "end)")
    return table.concat(lines, "\n")
end

function saveLuaTableToFile(fileName, tableData, mapName)
    local code = generateLuaCodeForMap(mapName, tableData)
    SaveResourceFile(GetCurrentResourceName(), string.format("data/maps/%s", fileName), code, -1)
end
