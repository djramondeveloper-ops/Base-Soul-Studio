-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Alc = {}
Tunnel.bindInterface("alc-spawn",Alc)
vSERVER = Tunnel.getInterface("alc-spawn")

local function resolveGroundZ(x, y, z)
  local groundZ = tonumber(z) or 0.0
  local heights = { groundZ + 80.0, groundZ + 40.0, groundZ + 20.0, groundZ + 10.0, groundZ + 5.0, 1000.0, 900.0, 800.0, 700.0, 600.0, 500.0, 400.0, 300.0, 200.0, 100.0, 50.0 }

  for _, height in ipairs(heights) do
    RequestCollisionAtCoord(x, y, height)
    local found, foundZ = GetGroundZFor_3dCoord(x, y, height, false)
    if found then
      return foundZ + 0.05
    end
    Wait(0)
  end

  return groundZ + 0.05
end

local function teleportToGround(x, y, z, heading)
  local ped = PlayerPedId()
  x, y, z = tonumber(x), tonumber(y), tonumber(z)
  heading = tonumber(heading) or GetEntityHeading(ped)
  if not x or not y or not z then return end

  DoScreenFadeOut(300)
  Wait(350)

  FreezeEntityPosition(ped, true)
  SetEntityCollision(ped, true, true)
  SetEntityVisible(ped, true, false)
  RequestCollisionAtCoord(x, y, z)
  SetEntityCoordsNoOffset(ped, x, y, z + 1.0, false, false, false)
  SetEntityHeading(ped, heading)

  local deadline = GetGameTimer() + 5000
  while not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < deadline do
    RequestCollisionAtCoord(x, y, z)
    Wait(50)
  end

  local groundZ = resolveGroundZ(x, y, z)
  SetEntityCoordsNoOffset(ped, x, y, groundZ, false, false, false)
  SetEntityHeading(ped, heading)
  ClearPedTasksImmediately(ped)

  Wait(250)
  FreezeEntityPosition(ped, false)
  SetEntityCollision(ped, true, true)
  DoScreenFadeIn(500)
end


----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN
----------------------------------------------------------------------------------------------------------------------------------------
function Controller:Init()
  local user_id = vSERVER.GetUserId()
  TriggerServerEvent("alc-spawn:checkPassed")
end
RegisterNetEvent("alc-spawn:receivePassed")
AddEventHandler("alc-spawn:receivePassed", function(hasPassed)
  if not hasPassed then
      SetNuiFocus(true, true)
      SendNUIMessage({ action = 'Opened', data = {
          spawns = Controller.locations
      } })
      Controller.firstSpawnDone = true
      TriggerServerEvent("alc-spawn:markPassed")
  else
      local fixedCoords = vSERVER.GetUserId()
      if fixedCoords and fixedCoords.x and fixedCoords.y and fixedCoords.z then
        teleportToCoords(fixedCoords.x, fixedCoords.y, fixedCoords.z)
      end
  end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Controller:Close()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'Opened', data = false })
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('Spawn', function(data, cb)
  local spawnName = data.spawn
  local location = Controller.locations[spawnName]
  if location and location.coords then
    teleportToGround(location.coords[1], location.coords[2], location.coords[3], location.coords[4])
  end
  Controller:Close()
  cb(true)
  -- TriggerEvent("hud:Active2", true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNLAST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('Last', function(data, cb)
  local ped = PlayerPedId()
    DoScreenFadeOut(300)
    Wait(500)

    -- TriggerEvent("hud:Active2", true)
    SetNuiFocus(false, false)

    LocalPlayer["state"]["Invisible"] = false
    RenderScriptCams(false, false, 0, true, true)

    if DoesCamExist(characterCamera) then
        SetCamActive(characterCamera, false)
        DestroyCam(characterCamera, true)
    end

    SetEntityVisible(ped, true, false)
    characterCamera = nil
    brokenCamera = false

    local fixedCoords = vSERVER.GetUserId()

    if fixedCoords and fixedCoords.x and fixedCoords.y and fixedCoords.z then
        teleportToCoords(fixedCoords.x, fixedCoords.y, fixedCoords.z)
    end

    Citizen.Wait(500)
    DoScreenFadeIn(300)
  cb(true)
end)


function teleportToCoords(x, y, z, heading)
  teleportToGround(x, y, z, heading)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- EVENTO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('hookSelector')
AddEventHandler('hookSelector', function()
  Controller:Init()
  firstSpawnDone = false
end)

RegisterNetEvent("spawn:Increment")
AddEventHandler("spawn:Increment", function(locations)
  for index, coords in ipairs(locations or {}) do
    local x, y, z, heading
    local coordsType = type(coords)

    if coordsType == "vector3" then
      x, y, z, heading = coords.x, coords.y, coords.z, 0.0
    elseif coordsType == "vector4" then
      x, y, z, heading = coords.x, coords.y, coords.z, coords.w
    elseif coordsType == "table" then
      x = coords.x or coords[1]
      y = coords.y or coords[2]
      z = coords.z or coords[3]
      heading = coords.w or coords[4] or 0.0
    end

    if x and y and z then
    Controller.locations["Propriedade " .. index] = {
      coords = { x, y, z, heading },
      image = "prefeitura.png"
    }
    end
  end
end)


