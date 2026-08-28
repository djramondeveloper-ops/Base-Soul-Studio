local restoreOutfit = false

CreateThread(function()
    if Config.Cloth == Cloth.TGIANN then
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

			if doesExportExistInResource("tgiann-clothing", "RefreshSkin") then
				exports["tgiann-clothing"]:RefreshSkin()
				return
			end

			if doesExportExistInResource("tgiann-clothing", "ReloadSkin") then
				exports["tgiann-clothing"]:ReloadSkin()
				return
			end

			if doesExportExistInResource("tgiann-clothing", "ChangeScriptClothe") then
				exports["tgiann-clothing"]:ChangeScriptClothe(false)
			else
				TriggerEvent("tgiann-clothing:changeScriptClothe", false)
			end
		end
    end
end)

