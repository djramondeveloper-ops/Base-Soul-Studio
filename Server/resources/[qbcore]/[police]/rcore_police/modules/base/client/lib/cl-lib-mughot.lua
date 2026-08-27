-- =====================================================
--  rcore_police · modules/base/client/lib/cl-lib-mughot.lua
--  Engineered by Eazy Fxap
--  Original: 799 lines → Cleaned: 240 lines
-- =====================================================

local Mugshot = {}
Mugshot.__index = Mugshot
local BOARD_MODEL = -1623189257
local OVERLAY_MODEL = -955488312
local ANIM_DICT = "mp_character_creation@lineup@male_a"
local ANIM_NAME = "loop_raised"

function Mugshot.new()
    local self = setmetatable({
        isActive = false,
        boardObj = nil,
        overlayObj = nil,
        camera = nil,
        ped = nil,
        scaleform = 0,
        renderTarget = 0,
        rtName = "ID_Text",
        scaleformName = "mugshot_board_01"
    }, Mugshot)
    return self
end

function Mugshot:loadModel(model)
    if not IsModelInCdimage(model) then return false end
    RequestModel(model)
    local timeout = GetGameTimer() + 5000
    while not HasModelLoaded(model) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

function Mugshot:loadAnimation(dict)
    RequestAnimDict(dict)
    local timeout = GetGameTimer() + 5000
    while not HasAnimDictLoaded(dict) do
        if GetGameTimer() > timeout then return false end
        Wait(10)
    end
    return true
end

function Mugshot:createCamera(ped)
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local rad = math.rad(heading)
    local offset = vector3(-math.sin(rad), math.cos(rad), 0.0) * 2.0
    local camCoords = coords + offset + vector3(0.0, 0.0, 0.4)
    
    self.camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(self.camera, camCoords.x, camCoords.y, camCoords.z)
    PointCamAtEntity(self.camera, ped, 0.0, 0.0, 0.65, true)
    SetCamFov(self.camera, 40.0)
    RenderScriptCams(true, true, 500, true, true)
end

function Mugshot:destroyCamera()
    if self.camera and DoesCamExist(self.camera) then
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(self.camera, false)
    end
    self.camera = nil
end

function Mugshot:playAnimation(ped)
    if self:loadAnimation(ANIM_DICT) then
        TaskPlayAnim(ped, ANIM_DICT, ANIM_NAME, 8.0, 8.0, -1, 49, 0, false, false, false)
    end
end

function Mugshot:clearAnimation(ped)
    StopAnimTask(ped, ANIM_DICT, ANIM_NAME, 1.0)
    RemoveAnimDict(ANIM_DICT)
end

function Mugshot:createRenderTarget(rtName, model)
    local id = 0
    if not IsNamedRendertargetRegistered(rtName) then
        RegisterNamedRendertarget(rtName, 0)
    end
    if not IsNamedRendertargetLinked(model) then
        LinkNamedRendertarget(model)
    end
    if IsNamedRendertargetRegistered(rtName) then
        id = GetNamedRendertargetRenderId(rtName)
    end
    return id
end

function Mugshot:loadScaleform(scaleformName)
    local handle = RequestScaleformMovie(scaleformName)
    if handle ~= 0 then
        while not HasScaleformMovieLoaded(handle) do Wait(0) end
    end
    return handle
end

function Mugshot:callScaleformMethod(handle, method, ...)
    local args = {...}
    BeginScaleformMovieMethod(handle, method)
    for _, arg in ipairs(args) do
        local t = type(arg)
        if t == "string" then
            PushScaleformMovieMethodParameterString(arg)
        elseif t == "number" then
            if tostring(arg):match("%.") then
                PushScaleformMovieFunctionParameterFloat(arg)
            else
                PushScaleformMovieFunctionParameterInt(arg)
            end
        elseif t == "boolean" then
            PushScaleformMovieMethodParameterBool(arg)
        end
    end
    EndScaleformMovieMethod()
end

function Mugshot:renderBoard()
    CreateThread(function()
        while self.isActive do
            if self.scaleform ~= 0 and self.renderTarget ~= 0 then
                HideHudAndRadarThisFrame()
                SetTextRenderId(self.renderTarget)
                Set_2dLayer(4)
                SetScriptGfxDrawBehindPausemenu(1)
                DrawScaleformMovie(self.scaleform, 0.405, 0.37, 0.81, 0.74, 255, 255, 255, 255, 0)
                SetScriptGfxDrawBehindPausemenu(0)
                SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            end
            Wait(0)
        end
    end)
end

function Mugshot:createBoard(ped)
    if not self:loadModel(BOARD_MODEL) or not self:loadModel(OVERLAY_MODEL) then return false end
    
    local coords = GetEntityCoords(ped)
    self.boardObj = CreateObject(BOARD_MODEL, coords.x, coords.y, coords.z + 0.2, true, true, false)
    self.overlayObj = CreateObject(OVERLAY_MODEL, coords.x, coords.y, coords.z + 0.2, true, true, false)
    
    AttachEntityToEntity(self.overlayObj, self.boardObj, -1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    AttachEntityToEntity(self.boardObj, ped, GetPedBoneIndex(ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
    
    SetModelAsNoLongerNeeded(BOARD_MODEL)
    SetModelAsNoLongerNeeded(OVERLAY_MODEL)
    
    SetCurrentPedWeapon(ped, -1569615261, true)
    ClearPedWetness(ped)
    ClearPedBloodDamage(ped)
    
    self.renderTarget = self:createRenderTarget(self.rtName, OVERLAY_MODEL)
    self.scaleform = self:loadScaleform(self.scaleformName)
    
    return self.renderTarget ~= 0
end

function Mugshot:releaseRenderTarget()
    if self.scaleform ~= 0 then
        SetScaleformMovieAsNoLongerNeeded(self.scaleform)
        self.scaleform = 0
    end
    if IsNamedRendertargetRegistered(self.rtName) then
        ReleaseNamedRendertarget(self.rtName)
    end
    self.renderTarget = 0
end

function Mugshot:cleanup()
    if DoesEntityExist(self.overlayObj) then
        DetachEntity(self.overlayObj, true, true)
        DeleteObject(self.overlayObj)
    end
    self.overlayObj = nil
    
    if DoesEntityExist(self.boardObj) then
        DetachEntity(self.boardObj, true, true)
        DeleteObject(self.boardObj)
    end
    self.boardObj = nil
    
    if self.ped then
        self:clearAnimation(self.ped)
    end
    
    self:destroyCamera()
    self:releaseRenderTarget()
    FreezeEntityPosition(self.ped, false)
    self.isActive = false
end

function Mugshot:start(title, footer)
    if self.isActive then return end
    
    self.ped = PlayerPedId()
    ClearPedTasksImmediately(self.ped)
    SetEntityHeading(self.ped, GetEntityHeading(self.ped))
    FreezeEntityPosition(self.ped, true)
    
    if not self:createBoard(self.ped) then
        print("^1Mugshot: failed to spawn board/overlay or init render target.^0")
        return
    end
    
    self:loadAnimation(ANIM_DICT)
    self:playAnimation(self.ped)
    self:createCamera(self.ped)
    self.isActive = true
    
    self:updateText(_U("MUGSHOT.TITLE"), title, _U("MUGSHOT.FOOTER"), footer)
    self:renderBoard()
    self:maintainState()
end

function Mugshot:updateText(boardHeader, playerName, statusText, dateText)
    if not self.isActive or self.scaleform == 0 then return end
    self:callScaleformMethod(self.scaleform, "SET_BOARD", 
        boardHeader or "LOS SANTOS POLICE DEPT.", 
        playerName or "UNKNOWN", 
        statusText or "WANTED", 
        dateText or "10/04/1993", 0)
end

function Mugshot:stop()
    if not self.isActive then return end
    self:cleanup()
end

function Mugshot:maintainState()
    CreateThread(function()
        while self.isActive do
            if self.ped then
                if not IsEntityPlayingAnim(self.ped, ANIM_DICT, ANIM_NAME, 3) then
                    self:playAnimation(self.ped)
                end
                
                if self.boardObj and not IsEntityAttachedToEntity(self.boardObj, self.ped) then
                    AttachEntityToEntity(self.boardObj, self.ped, GetPedBoneIndex(self.ped, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                end
                
                if self.overlayObj and self.boardObj and not IsEntityAttachedToEntity(self.overlayObj, self.boardObj) then
                    AttachEntityToEntity(self.overlayObj, self.boardObj, -1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                end
            end
            Wait(250)
        end
    end)
end

local mugshotInstance = Mugshot.new()

function StartMugshotRegister()
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        mugshotInstance:stop()
    end
end)
