local function onStartCigarProduction(success, productionData)
    if not success then
        return
    end

    StartMinigame(productionData, MINIGAME_PLACE_TYPE.CIGAR)
end

NetworkService.RegisterNetEvent("startCigarProduction", onStartCigarProduction)