local activeCooldown = false

CreateThread(function()
    if Config.Cloth == Cloth.CODEM then
		ApplyOutfit = function(data)
			local outfitData = GetOutfitByGender(data)
			local plyPed = PlayerPedId()

			if not outfitData then
				return
			end

			ClothingService.ApplyClothing(plyPed, outfitData)
		end

		RestoreCivilOutfit = function()
            if activeCooldown then
                return
            end

            activeCooldown = true

            TriggerEvent("rcore_prison:client:restoreOutfitInit")

            SetTimeout(5 * 1000, function()
				activeCooldown = false
                TriggerEvent("rcore_prison:client:restoreOutfitFinished")
			end)

			dbg.debugClothing('Restoring outfit!')
			
            TriggerEvent("codem-appearance:reloadSkin")
		end
    end
end)

