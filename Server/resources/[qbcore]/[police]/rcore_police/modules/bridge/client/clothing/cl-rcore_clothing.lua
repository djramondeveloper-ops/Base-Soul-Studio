-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



CreateThread(function()
    if isResourcePresentProvideless(Clothing.RCORE) then
        OpenOutfitMenu = function(zone, owner)
			local zoneOwner = zone and zone.getDepartmentOwner() or owner
			local playerJob = Framework.job
			local hasAccess = false
			local department = nil
			if type(zoneOwner) == "table" then
				for k, v in pairs(zoneOwner) do
					if playerJob and playerJob.name == v then
						hasAccess = true
						department = v
					end
				end
			elseif playerJob and playerJob.name == zoneOwner then
				hasAccess = true
				department = zoneOwner
			end
			if not hasAccess then
				return
			end
			local outfits = GetAvailableOutfitsForGrade(department, playerJob.grade)
			local array = {
				{
					header = _U('OUTFITS.MENU_TITLE'),
					isMenuHeader = true,
				},
			}
			if Config.Outfits.UseIncludedOutfitSystem then
				if outfits and next(outfits) then
					for k, v in pairs(outfits) do
						array[#array + 1] = {
							type = 'button',
							header = v.label or '',
							description = '',
							params = {
								isClient = true,
								event = 'rcore_police:client:handleOutfits',
								args = {
									outfit = v.outfit,
									action = OUTFITS.SET_OUTFIT
								},
								icon = 'fa-solid fa-shirt',
							},
						}
					end				
				end
				if Config.Outfits.EnableRestoreOutfit then
					array[#array + 1] = {
						type = 'button',
						header = _U('OUTFITS.RESTORE_OUTFIT_LABEL'),
						description = '',
						params = {
							isClient = true,
							event = 'rcore_police:client:handleOutfits',
							args = {
								outfit = nil,
								action = OUTFITS.RESTORE_OUTFIT
							},
							icon = 'fa-solid fa-shirt',
						},
					}
				end
				dbg.debug('Loading integrated outfit menu!')
				UI:CreateMenu(MENU_ID_LIST.JOB_OUTFITS, _U('OUTFITS.MENU_TITLE'), array, true)
			else
				dbg.debug('Loading RCore changing room!')
				TriggerEvent('rcore_clothing:openChangingRoom')
			end
        end
		ApplyOutfit = function(data)
			local outfitData = Utils.GetOutfitByGender(data)
			local plyPed = PlayerPedId()
			if not outfitData then
				return
			end
			ClothingService.ApplyClothing(plyPed, outfitData)
		end
		RestoreCivilOutfit = function()
			dbg.debug('Restoring outfit!')
			ExecuteCommand('reloadskin')
		end
    end
end)
