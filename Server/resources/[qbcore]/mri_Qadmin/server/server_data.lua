QBCore = SeoulQAdminGetCoreObject()

local function GetServerData()
    local stats = MySQL.single.await([[
        SELECT
            (SELECT COUNT(1) FROM vehicles) as vehicleCount,
            (SELECT COUNT(1) FROM accounts WHERE Banned <> 0 AND (Banned = -1 OR Banned > UNIX_TIMESTAMP())) as bansCount,
            (SELECT COUNT(1) FROM characters WHERE Deleted = 0) as characterCount,
            (SELECT COUNT(DISTINCT License) FROM accounts) as uniquePlayers,
            COALESCE((SELECT SUM(Bank) FROM characters WHERE Deleted = 0), 0) as totalBank
    ]]) or {}

    local onlinePlayers = 0
    local GetPlayers = QBCore.Functions.GetQBPlayers()
    for _ in pairs(GetPlayers or {}) do
        onlinePlayers = onlinePlayers + 1
    end

    return {
        -- Dinheiro em mãos fica dentro do ox_inventory como item dollar; não somamos aqui para não varrer JSON pesado no start.
        totalCash = 0,
        totalBank = tonumber(stats.totalBank) or 0,
        totalCrypto = 0,
        uniquePlayers = tonumber(stats.uniquePlayers) or 0,
        onlinePlayers = onlinePlayers,
        vehicleCount = tonumber(stats.vehicleCount) or 0,
        bansCount = tonumber(stats.bansCount) or 0,
        characterCount = tonumber(stats.characterCount) or 0
    }
end
_G.GetServerData = GetServerData

lib.callback.register(
    "mri_Qadmin:callback:GetServerInfo",
    function(source)
        if not CheckPerms(source, 'qadmin.open') then return nil end
        local data = GetServerData()
        if not HasPerms(source, 'qadmin.action.info_admin') then
            data.totalCash = nil
            data.totalBank = nil
            data.totalCrypto = nil
        end
        return data
    end
)
