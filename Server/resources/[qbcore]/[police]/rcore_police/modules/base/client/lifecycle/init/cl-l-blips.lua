-- =====================================================
--  rcore_police · modules/base/client/lifecycle/init/cl-l-blips.lua
--  Engineered by Eazy Fxap
--  Original: 321 lines → Cleaned: 107 lines
-- =====================================================

local spritesByState = Config.Blips.SpritesByState or {}
local blipCfg = Config.Blips.Blip or {}

local Blip = {}
Blip.__index = Blip

function Blip.new(id, coords, blipType)
    local self = setmetatable({}, Blip)
    self.id = id
    self.type = blipType or TRACK_TYPE.PED
    self.handle = AddBlipForCoord(coords.x, coords.y, coords.z)
    self.cachedLabel = nil
    self:setStyle()
    return self
end

function Blip:getLabel()
    if self.cachedLabel then return self.cachedLabel end
    
    local label = "Unknown"
    if self.type == TRACK_TYPE.PED then
        local charData = GroupsService.GetCharacterDataByServerId(self.id)
        if charData then
            local fmt = Config.Blips.LabelFormat or "[{grade}] {name}"
            local replacements = {
                ["{grade}"]      = charData.grade_name or "No Grade",
                ["{name}"]       = charData.name       or "No Name",
                ["{department}"] = charData.group       or "No Dept"
            }
            for token, value in pairs(replacements) do
                fmt = fmt:gsub(token, value)
            end
            label = fmt
        end
    end
    
    self.cachedLabel = label
    return label
end

function Blip:setStyle()
    if not self.handle then return end
    
    SetBlipDisplay(self.handle, blipCfg.Display or 2)
    SetBlipCategory(self.handle, blipCfg.Category or 7)
    SetBlipScale(self.handle, blipCfg.Scale or 1.0)
    SetBlipAsShortRange(self.handle, false)
    
    if self.type == TRACK_TYPE.PED then
        local walkState = spritesByState.Walk or {}
        SetBlipSprite(self.handle, walkState.sprite or 60)
        SetBlipColour(self.handle, walkState.color or 0)
        ShowHeadingIndicatorOnBlip(self.handle, true)
    end
    
    local label = self:getLabel()
    local fontCfg = Config.Blips.Font or {}
    
    BeginTextCommandSetBlipName("STRING")
    if fontCfg.Enable and fontCfg.Name then
        AddTextComponentString(string.format("<font face='%s'>%s</font>", fontCfg.Name, label))
    else
        AddTextComponentString(label)
    end
    EndTextCommandSetBlipName(self.handle)
end

function Blip:updateCoords(coords)
    if self.handle then
        SetBlipCoords(self.handle, coords.x, coords.y, coords.z)
    end
end

function Blip:updateLabel()
    self.cachedLabel = nil
    self:setStyle()
end

function Blip:remove()
    if self.handle then
        RemoveBlip(self.handle)
        self.handle = nil
    end
end

local BlipManager = { active = {} }

function BlipManager:updateBatch(blipList)
    for _, entry in ipairs(blipList) do
        local id = entry.id
        local blipType = entry.type
        local coords = entry.coords
        
        if blipType == TRACK_TYPE.PED and id == MyServerId then
            goto continue
        end
        
        if not self.active[id] then
            self.active[id] = Blip.new(id, coords, blipType)
        else
            self.active[id]:updateCoords(coords)
        end
        
        ::continue::
    end
end

function BlipManager:remove(blipId)
    if self.active[blipId] then
        self.active[blipId]:remove()
        self.active[blipId] = nil
    end
end

RegisterNetEvent("rcore_police:client:updateBlipsBatch", function(blipList)
    if source == "" then return end
    BlipManager:updateBatch(blipList)
end)

RegisterNetEvent("rcore_police:client:removeBlip", function(blipId)
    if source == "" then return end
    BlipManager:remove(blipId)
end)
