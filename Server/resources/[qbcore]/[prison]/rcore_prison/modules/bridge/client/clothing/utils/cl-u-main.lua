local ActionTypesList = {
    [HEARTBEAT_EVENTS.PRISONER_LOADED] = PRISON_OUTFITS.PRISONER,
    [HEARTBEAT_EVENTS.PRISONER_NEW] = PRISON_OUTFITS.PRISONER,
    [HEARTBEAT_EVENTS.PRISONER_RELEASED] = PRISON_OUTFITS.CITIZEN,
}

RegisterNetEvent('ZSX_Multicharacter:Listener:SwappedCharacter')
AddEventHandler('ZSX_Multicharacter:Listener:SwappedCharacter', function(characterData, characterId)
    if GetInvokingResource() ~= "ZSX_Multicharacter" then return end
    TriggerServerEvent("rcore_prison:server:requestPlayerLogout")
    TriggerEvent("rcore_prison:client:playerLogout")
end)

NetworkService.EventListener('heartbeat', function(eventType, data)
    local actionType = ActionTypesList[eventType]

    if not actionType then
        return
    end

    if Config.DisableClothing then
        return
    end

    if actionType == PRISON_OUTFITS.CITIZEN then
        if not Config.Outfits.RestorePlayerOutfitOnRelease then
            return
        end

        if isResourcePresentProvideless("pinkFrog_inventoryAddon") then
            TriggerEvent('pinkFrog_syncWithClotheShopAfterBuy')
            return
        end

        RestoreCivilOutfit()
    elseif actionType == PRISON_OUTFITS.PRISONER then
        DestroyAllCams(true)
        ApplyOutfit(Outfits)
    end
end)

local function SafeMode(on)
    local player = PlayerPedId()
    SetEntityInvincible(player, on)
    SetPlayerInvincible(PlayerId(), on)
    SetPedCanRagdoll(player, not on)
end

AddEventHandler("rcore_prison:client:restoreOutfitInit", function()
    if GetInvokingResource() ~= GetCurrentResourceName() then return end

    SafeMode(true)

    if isResourcePresentProvideless("osp_ambulance") then
        TriggerEvent("osp_ambulance:appearanceEnter")
    end

    if isResourcePresentProvideless("wasabi_ambulance") and doesExportExistInResource("wasabi_ambulance", "disableKnockoutLoop") then
        exports.wasabi_ambulance:disableKnockoutLoop(true)
    end
end)

AddEventHandler("rcore_prison:client:restoreOutfitFinished", function()
    if GetInvokingResource() ~= GetCurrentResourceName() then return end

    SafeMode(false)

    if isResourcePresentProvideless("osp_ambulance") then
        TriggerEvent("osp_ambulance:appearanceExit")
    end

   if isResourcePresentProvideless("wasabi_ambulance") and doesExportExistInResource("wasabi_ambulance", "disableKnockoutLoop") then
        exports.wasabi_ambulance:disableKnockoutLoop(false)
    end

   if isResourcePresentProvideless("wasabi_ambulance") and doesExportExistInResource("wasabi_ambulance", "clearPlayerInjury") then
        exports.wasabi_ambulance:clearPlayerInjury(true)
    end
end)

function GetOutfitByGender(data)
    if not data then
        return
    end

    local plyPed = PlayerPedId()
    local model = GetEntityArchetypeName(plyPed)
    local isMale = 'mp_m_freemode_01' == model
    local gender = isMale and 'male' or 'female'

    return data[gender] or nil
end


if Config.Experimental and Config.Experimental.RestoreOutfitWhenDiedInAsPrisoner then
    local wasDead = false

    CreateThread(function()
        while true do
            Wait(400)

            if PrisonService.IsPrisoner() then
                local isDead = IsTargetPlayerDead(MyServerId)

                if isDead and not wasDead then
                    wasDead = true
                    dbg.debug("[rcore_prison] Player died while being a prisoner, restoring his prisoner outfit.")
                    exports['rcore_prison']:RestorePrisonerOutfit()
                elseif not isDead and wasDead then
                    wasDead = false
                end
            end
        end
    end)
end

 function GetPlayerPedFromServerId(playerId)
    if not playerId then
        return nil, false
    end

    local player = GetPlayerFromServerId(playerId)

    if not player then
        return nil, false
    end

    if player == -1 then
        return
    end

    local playerPed = GetPlayerPed(player)

    return playerPed, true
end

function IsTargetPlayerDead(targetPlayerId)
    if not targetPlayerId then
        return false, "Failure: Missing targetPlayerId!"
    end

    local player = Player(targetPlayerId)
    local playerState = player and player.state
    local ped = GetPlayerPedFromServerId(targetPlayerId)
    local playerIndex = ped and NetworkGetPlayerIndexFromPed(ped)
    local name = playerIndex and GetPlayerName(playerIndex) or "Unk name"

    local result = false
    local bestSource = "None"
    local bestWeight = 0

    local function evaluate(condition, source, weight)
        if condition and weight > bestWeight then
            result = true
            bestSource = source
            bestWeight = weight
        end
    end

    if ped and DoesEntityExist(ped) and IsEntityAPed(ped) then
        evaluate(IsEntityDead(ped), "Native: IsEntityDead", 100)
        evaluate(IsPedFatallyInjured(ped), "Native: IsPedFatallyInjured", 95)
        evaluate(GetPedTimeOfDeath(ped) ~= 0 and Config.Framework ~= Framework.QBOX, "Native: GetPedTimeOfDeath", 80)
        evaluate(IsPedRagdoll(ped), "Native: IsPedRagdoll", 50)
        evaluate(IsEntityPlayingAnim(ped, "combat@damage@writhe", "writhe_loop", 3), "Animation: Last stand (qb-ambulance)", 85)
        evaluate(IsEntityPlayingAnim(ped, "dead", "dead_a", 3), "Animation: Dead (qb-ambulance)", 90)
    end

    evaluate(playerState and (playerState.isDead or playerState.down), "Statebag: isDead or down", 85)

    return result, bestSource
end

RegisterCommand("rcore_prison_self_dead", function()
    local retval, deadSource = IsTargetPlayerDead(MyServerId)
    local ambulanceJob = FindTargetResource("ambulance") or "Failed to detect any ambulance"
    local output = ([[
^3============================================================^7
^3[Running dead check]^7
------------------------------------------------------------
 - Dead check result: ^5%s^7
 - Dead check source: ^5%s^7
 - Current ambulance job: ^5%s^7
^3============================================================^7
]]):format(tostring(retval), tostring(deadSource), tostring(ambulanceJob))
    print(output)
end, false)
