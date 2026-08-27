-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local activeCooldown = false
CreateThread(function()
    if Config.Clothing == Clothing.IAPPEARANCE and not isResourcePresentProvideless(Clothing.RCORE) then
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
			if not Config.Outfits.UseIncludedOutfitSystem then
				return
			end
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
			UI:CreateMenu(MENU_ID_LIST.JOB_OUTFITS, _U('OUTFITS.MENU_TITLE'), array, true)
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
			if not Framework.object then
				return
			end
			if activeCooldown then
				return dbg.debug('Please wait few seconds, before restoring outfit again!')
			end
			activeCooldown = true
			SetTimeout(5 * 1000, function()
				activeCooldown = false
			end)
            if Config.Framework == Framework.ESX then
                Framework.object.TriggerServerCallback(Config.Events['esx_skin:getPlayerSkin'], function(apperance, skin)
                    repeat
                        Wait(1000)
                    until apperance ~= nil
                    TriggerEvent(Config.Events['skinchanger:loadSkin'], apperance)
                end)
            elseif Config.Framework == Framework.QBCore or Config.Framework == Framework.QBOX then
				TriggerServerEvent("qb-clothes:loadPlayerSkin")
				TriggerServerEvent("qb-clothing:loadPlayerSkin")
				ExecuteCommand('reloadskin')
            end
		end
    end
end)
