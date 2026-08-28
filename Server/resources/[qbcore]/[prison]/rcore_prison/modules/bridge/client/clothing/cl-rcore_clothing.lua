CreateThread(function()
	local restoreOutfit = false

    if Config.Cloth == Cloth.RCORE then
		ApplyOutfit = function(data)
			local outfitData = GetOutfitByGender(data)
			local plyPed = PlayerPedId()

			if not outfitData then
				return
			end

			ClothingService.ApplyClothing(plyPed, outfitData)
		end

		RestoreCivilOutfit = function()
            if restoreOutfit then
                return
            end

            restoreOutfit = true

            TriggerEvent("rcore_prison:client:restoreOutfitInit")

            SetTimeout(5 * 1000, function()
				restoreOutfit = false
                TriggerEvent("rcore_prison:client:restoreOutfitFinished")
			end)

			TriggerServerEvent('rcore_clothing:reloadSkin')
		end
    end
end)

