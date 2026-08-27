if Config.Framework ~= "vrp" then return end

UsersCollate = ""
VehiclesCollate = ""
Queries = { Users = {}, Vehicles = {} }

Queries.Users.Table = "characters"
Queries.Users.Select = {
    identifier = "user.id",
    name = "CONCAT(user.Name, ' ', user.Lastname)",
    dob = "CONCAT(user.age, ' anos')",
    isMale = "(user.Sex = 'M')"
}

Queries.Users.Filter = {
    Jobs = "1=1", -- tratado de forma especial em server/custom/functions/queries.lua para vRP
    Gender = "(CASE WHEN user.Sex = 'M' THEN 'm' ELSE 'f' END) = ?",
    License = "EXISTS (SELECT 1 FROM lbtablet_registration_licenses license WHERE license.character_id = user.id AND license.license = ?)",
    ExcludeJailed = "user.Prison <= 0"
}

Queries.Users.FetchProfile = [[
    SELECT
        user.id AS id,
        CONCAT(user.Name, ' ', user.Lastname) AS name,
        CONCAT(user.age, ' anos') AS dob,
        NULL AS height,
        (user.Sex = 'M') AS isMale,
        (
            SELECT phone.phone_number
            FROM phone_phones phone
            WHERE phone.owner_id IN (CONCAT('vrp:', user.id), CONCAT('pandora:', user.id), CAST(user.id AS CHAR))
               OR phone.id IN (CONCAT('vrp:', user.id), CONCAT('pandora:', user.id), CAST(user.id AS CHAR))
            ORDER BY CASE WHEN phone.owner_id = CONCAT('vrp:', user.id) OR phone.id = CONCAT('vrp:', user.id) THEN 0 ELSE 1 END, phone.last_seen DESC
            LIMIT 1
        ) AS phoneNumber,
        profile.avatar,
        profile.notes,
        0 AS jobGrade,
        '' AS job
    FROM characters user
    LEFT JOIN {PROFILE_JOIN} profile ON profile.id = user.id
    WHERE user.id = ?
]]

Queries.Vehicles.Table = "vehicles"
Queries.Vehicles.Select = {
    plate = "vehicle.Plate",
    owner = "vehicle.Passport",
    model = "vehicle.Vehicle",
    color = "NULL"
}
Queries.Vehicles.BasicFetch = "SELECT Vehicle AS model, NULL AS color FROM vehicles WHERE Plate = ? LIMIT 1"
