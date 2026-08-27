-- ============================================
-- More exclusive content you will find here:
-- Cleaned and working - hot scripts and more.
--
-- https://unlocknow.net/releases
-- https://discord.gg/unlocknoww
-- ============================================



SWebhook = ""
ServerConfig = {
    Database = {
        ESX = 'owned_vehicles', -- This is default table when you running es_extended for owned_vehicles, you can change it customized structure.
        QBCORE = 'vehicles', -- This is default table when you running QBCore/QBox for player_vehicles, you can change it customized structure.
    },
    Image = {
        -- Seoul adaptation uses screenshot-basic + the existing Discord_MDT convar for the camera item.
        -- These external rcore upload settings stay disabled and are not required by this build.
        Service = Images.NONE,
        ApiKey = "",
        Settings = {
            encoding = "webp",
            maxWidth = 1920,
            maxHeight = 1080,
            quality = 0.6
        },
        CustomConfig = {
            url = "",
            authType = "header"
        }
    }
}
