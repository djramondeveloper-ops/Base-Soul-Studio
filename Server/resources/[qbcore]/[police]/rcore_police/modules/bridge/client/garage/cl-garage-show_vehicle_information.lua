-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



local TRANSLATION_BY_KEY = {
    ['vehicle_plate'] = _U('VEHICLE_INFO.VEHICLE_PLATE'),
    ['plate'] = _U('VEHICLE_INFO.VEHICLE_PLATE'),
    ['vehicle_owner'] = _U('VEHICLE_INFO.VEHICLE_OWNER_NAME'),
    ['vehicle_name'] = _U('VEHICLE_INFO.VEHICLE_NAME'),
    ['owner_phone_number'] = _U('VEHICLE_INFO.OWNER_PHONE_NUMBER'),
    ['owner_identifier'] = _U('VEHICLE_INFO.OWNER_IDENTIFIER'),
}
local ICONS_BY_KEY = Config.Garage.VehicleInformations and Config.Garage.VehicleInformations.IconsByKey or {
    ['vehicle_plate'] = 'fas fa-map-pin',
    ['plate'] = 'fas fa-map-pin',
    ['vehicle_owner'] = 'moroccan fa-car',
    ['vehicle_name'] = 'far fa-comments',
    ['owner_phone_number'] = 'fas fa-phone',
    ['owner_identifier'] = 'fas fa-question',
}
local cachedInformations = {}
function ShowVehicleInformation(vehicleId, data)
    if not DoesEntityExist(vehicleId) then
        return
    end
    local model = GetEntityModel(vehicleId)
    local displayName = GetDisplayNameFromVehicleModel(model)
    local vehicleLabel = GetLabelText(displayName)
    if not data.vehicle_name then
        data.vehicle_name = vehicleLabel
    end
    if Config.VehicleInfo.UseProgressBar then
        CancellableProgress(
            Config.VehicleInfo.ProgressBarTime * 1000,
            _U('VEHICLE_INFO.PG_LABEL'),
            'missheistdockssetup1clipboard@base',
            'base',
            1,
            function()
                ShowInfo(vehicleId, data)
            end,
            function()
            end,
            {
                props = {
                    {
                        name = 'prop_notepad_01',
                        bone = 18905,
                        coords = { x = 0.1, y = 0.02, z = 0.05 },
                        rotation = { x = 10.0, y = 0.0, z = 0.0 },  
                    },
                    {
                        name = 'prop_pencil_01',
                        bone = 58866,
                        coords = { x = 0.11, y = -0.02, z = 0.001 },
                        rotation = { x = -120.0, y = 0.0, z = 0.0 },
                    }
                },
            }
        )
    else
        ShowInfo(vehicleId, data)
    end
end
function ShowInfo(vehicleId, data)
    local vehicleNetId = VehToNet(vehicleId)
    local menuId = MENU_ID_LIST.SHOW_VEHICLE_INFO
    local menuIdPrefix = nil
    local vehicleInformations = {}
    if data then
        if Config.VehicleInfo.TemporaryPersistentFakeInfo then
            if cachedInformations[vehicleNetId] then
                vehicleInformations = cachedInformations[vehicleNetId]
                menuIdPrefix = ('%s_%s_%s'):format(menuId, 'CACHED', vehicleNetId)
            elseif not cachedInformations[vehicleNetId] then
                vehicleInformations = PrepareVehicleInformations(data)
                cachedInformations[vehicleNetId] = vehicleInformations
                menuIdPrefix = ('%s_%s_%s'):format(menuId, 'INIT', vehicleNetId)
                SetTimeout(Config.VehicleInfo.TemporaryPersistentFakeInfoTime * 60 * 1000, function()
                    if cachedInformations[vehicleNetId] then
                        cachedInformations[vehicleNetId] = nil
                    end
                end)
            end
        elseif not Config.VehicleInfo.TemporaryPersistentFakeInfo then
            vehicleInformations = PrepareVehicleInformations(data)
            menuIdPrefix = ('%s_%s_%s'):format(menuId, 'INIT', vehicleNetId)
        end
    end
    if Config.Menu ~= Menu.OX and not Config.Menu == Menu.QB then
        table.insert(vehicleInformations, {
            header = _U('VEHICLE_INFO.MENU_TITLE'),
            isMenuHeader = true,
        }) 
    elseif Config.Menu == Menu.OX or Config.Menu == Menu.QB then
        table.insert(vehicleInformations, 1, {
            header = _U('VEHICLE_INFO.MENU_TITLE'),
            isMenuHeader = true,
        })
    end
    if menuIdPrefix then
        UI:CreateMenu(menuIdPrefix, _U('VEHICLE_INFO.MENU_TITLE'), vehicleInformations, true)
    end
end
function PrepareVehicleInformations(data)
    local retval = {}
    if data and next(data) then
        for k, v in pairs(data) do
            if v and v ~= '' then
                local translationKey = TRANSLATION_BY_KEY[k] or k
                local iconKey = Config.Menu ~= Menu.RCORE and ICONS_BY_KEY[k] or 'faCopy'
                local label = ('%s : %s'):format(translationKey, v)
                retval[#retval + 1] = {
                    type = 'button',
                    header = label,
                    isCopy = true,
                    value = v,
                    description = '',
                    params = {
                        icon = iconKey,
                    },
                } 
            end
        end
    end
    return retval
end
