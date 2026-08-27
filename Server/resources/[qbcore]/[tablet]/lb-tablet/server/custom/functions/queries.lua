
function SearchUsers(search, filter, profileJoinTable, page)
    local params = {}
    local join = {}
    local where = {}
    local select = {
        Queries.Users.Select.identifier .. " AS id",
        Queries.Users.Select.name .. " AS `name`",
        Queries.Users.Select.dob .. " AS dob",
        Queries.Users.Select.isMale .. " AS isMale"
    }

    if profileJoinTable then
        select[#select+1] = "profile.avatar"
        join[#join+1] = "LEFT JOIN " .. profileJoinTable .. " profile ON profile.id = {IDENTIFIER} {USERS_COLLATE}"
    end

    if #search > 0 then
        if IsStringOnlyNumbers(search) and Config.LBPhone then
            local phoneConfig = GetPhoneConfig()

            if Config.Framework == "vrp" then
                -- Seoul/vRP: uma busca numérica pode ser tanto Passport quanto telefone.
                -- Antes o LB tratava qualquer número somente como telefone, então buscar "2"
                -- não encontrava o personagem de Passport 2 no seletor de prisão/multa/etc.
                where[#where+1] = [[
                    (
                        CAST({IDENTIFIER} AS CHAR) = ?
                        OR EXISTS (
                            SELECT 1
                            FROM phone_phones phone
                            WHERE (
                                phone.owner_id IN (CONCAT('vrp:', {IDENTIFIER}), CONCAT('pandora:', {IDENTIFIER}), CAST({IDENTIFIER} AS CHAR))
                                OR phone.id IN (CONCAT('vrp:', {IDENTIFIER}), CONCAT('pandora:', {IDENTIFIER}), CAST({IDENTIFIER} AS CHAR))
                            )
                            AND phone.phone_number LIKE ?
                        )
                    )
                ]]
                params[#params+1] = tostring(search)
            elseif phoneConfig?.Item.Unique then
                where[#where+1] = "phone.phone_number LIKE ?"
                join[#join+1] = "LEFT JOIN phone_last_phone phone ON {IDENTIFIER} {USERS_COLLATE} = phone.id"
            else
                where[#where+1] = "phone.phone_number LIKE ?"
                join[#join+1] = "LEFT JOIN phone_phones phone ON {IDENTIFIER} {USERS_COLLATE} = phone.id"
            end

            params[#params+1] = "%" .. search .. "%"
        else
            where[#where+1] = FormatString([[
                (
                    {NAME} LIKE ?
                    OR {DOB} LIKE ?
                    {FINGERPRINT}
                )
            ]], {
                NAME = Queries.Users.Select.name,
                DOB = Queries.Users.Select.dob,
                FINGERPRINT = Queries.Users.Select.fingerprint and "OR " .. Queries.Users.Select.fingerprint .. " LIKE ?" or ""
            })

            if Queries.Users.Select.fingerprint then
                params[#params+1] = "%" .. search .. "%"
            end

            params[#params+1] = "%" .. search .. "%"
            params[#params+1] = "%" .. search .. "%"
        end
    end

    if filter then
        if filter.jobs then
            if Config.Framework == "vrp" and GetIdentifiersWithJob then
                local identifiers = GetIdentifiersWithJob(filter.jobs)

                if identifiers and #identifiers > 0 then
                    where[#where+1] = Queries.Users.Select.identifier .. " IN (?)"
                    params[#params+1] = identifiers
                else
                    where[#where+1] = "1=0"
                end
            else
                where[#where+1] = Queries.Users.Filter.Jobs
                params[#params+1] = filter.jobs
            end
        end

        if filter.tags then
            for i = 1, #filter.tags.tags do
                where[#where+1] = FormatString(
                    "EXISTS (SELECT 1 FROM {TABLE} profile_tag WHERE profile_tag.{ID_COLUMN} = {IDENTIFIER} {USERS_COLLATE} AND profile_tag.tag_id = ?)",
                    {
                        TABLE = filter.tags.tagsTable,
                        ID_COLUMN = filter.tags.tagsColumn,
                        IDENTIFIER = Queries.Users.Select.identifier,
                        USERS_COLLATE = UsersCollate
                    }
                )

                params[#params+1] = filter.tags.tags[i]
            end
        end

        if filter.excludeJailed then
            where[#where+1] = Queries.Users.Filter.ExcludeJailed
        end

        if type(filter.warrant) == "boolean" then
            where[#where+1] = (filter.warrant and "EXISTS " or "NOT EXISTS ") .. "(SELECT 1 FROM lbtablet_police_warrants warrant WHERE warrant.linked_profile_id = " .. Queries.Users.Select.identifier .. " {USERS_COLLATE} AND warrant.linked_profile_type = 'player' AND warrant.warrant_status = 'active')"
        end

        if filter.gender then
            where[#where+1] = Queries.Users.Filter.Gender
            params[#params+1] = filter.gender
        end

        if filter.licenses then
            for i = 1, #filter.licenses do
                where[#where+1] = Queries.Users.Filter.License
                params[#params+1] = filter.licenses[i]
            end
        end
    end

    local searchQuery = "SELECT\n    {SELECT}\nFROM {USERS_TABLE} user\n{JOIN}\n{WHERE}\nLIMIT ?, ?"

    searchQuery = searchQuery
        :gsub("{SELECT}", table.concat(select, ",\n    "))
        :gsub("{USERS_TABLE}", Queries.Users.Table)
        :gsub("{JOIN}", table.concat(join, "\n"))
        :gsub("{WHERE}", #where > 0 and "WHERE " .. table.concat(where, " AND ") or "")
        :gsub("{IDENTIFIER}", Queries.Users.Select.identifier)
        :gsub("{USERS_COLLATE}", UsersCollate)

    params[#params+1] = (page or 0) * 10
    params[#params+1] = 10

    return MySQL.query.await(searchQuery, params)
end


function SearchVehicles(search, filter, profileJoinTable, page)
    local params = {}
    local join = {}
    local where = {}
    local select = {
        Queries.Users.Select.name .. " AS `name`",
    }

    for name, value in pairs(Queries.Vehicles.Select) do
        select[#select+1] = value .. " AS " .. name
    end

    join[#join+1] = FormatString(
        "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER_COLUMN} {USERS_COLLATE} = {OWNER} {VEHICLES_COLLATE}",
        {
            USERS_TABLE = Queries.Users.Table,
            IDENTIFIER_COLUMN = Queries.Users.Select.identifier,
            USERS_COLLATE = UsersCollate,
            OWNER = Queries.Vehicles.Select.owner,
            VEHICLES_COLLATE = VehiclesCollate
        }
    )

    if profileJoinTable then
        select[#select+1] = "profile.avatar AS picture"
        join[#join+1] = "LEFT JOIN " .. profileJoinTable .. " profile ON profile.id = {PLATE} {VEHICLES_COLLATE}"
    end

    if #search > 0 then
        where[#where+1] = "{PLATE} LIKE ?"
        params[#params+1] = "%" .. search .. "%"
    end

    if filter then
        if filter.tags then
            for i = 1, #filter.tags.tags do
                where[#where+1] = FormatString(
                    "EXISTS (SELECT 1 FROM {TABLE} profile_tag WHERE profile_tag.{ID_COLUMN} = {PLATE} {VEHICLES_COLLATE} AND profile_tag.tag_id = ?)",
                    {
                        TABLE = filter.tags.tagsTable,
                        ID_COLUMN = filter.tags.tagsColumn,
                        PLATE = Queries.Vehicles.Select.plate,
                        VEHICLES_COLLATE = VehiclesCollate
                    }
                )

                params[#params+1] = filter.tags.tags[i]
            end
        end

        if type(filter.warrant) == "boolean" then
            where[#where+1] = (filter.warrant and "EXISTS " or "NOT EXISTS ") .. "(SELECT 1 FROM lbtablet_police_warrants warrant WHERE warrant.linked_profile_id = " .. Queries.Vehicles.Select.plate .. " {VEHICLES_COLLATE} AND warrant.linked_profile_type = 'vehicle' AND warrant.warrant_status = 'active')"
        end
    end

    local searchQuery = "SELECT\n    {SELECT}\nFROM {VEHICLES_TABLE} vehicle\n{JOIN}\n{WHERE}\nLIMIT ?, ?"

    searchQuery = searchQuery
        :gsub("{SELECT}", table.concat(select, ",\n    "))
        :gsub("{VEHICLES_TABLE}", Queries.Vehicles.Table)
        :gsub("{JOIN}", table.concat(join, "\n"))
        :gsub("{WHERE}", #where > 0 and "WHERE " .. table.concat(where, " AND ") or "")
        :gsub("{PLATE}", Queries.Vehicles.Select.plate)
        :gsub("{VEHICLES_COLLATE}", VehiclesCollate)

    params[#params+1] = (page or 0) * 10
    params[#params+1] = 10

    return MySQL.query.await(searchQuery, params)
end

function FetchVehicle(plate, profileJoinTable)
    local params = {}
    local join = {}
    local where = {}
    local select = {
        Queries.Users.Select.name .. " AS `name`",
    }

    for name, value in pairs(Queries.Vehicles.Select) do
        select[#select+1] = value .. " AS " .. name
    end

    if profileJoinTable then
        select[#select+1] = "profile.avatar AS picture"
        select[#select+1] = "profile.notes"
        join[#join+1] = "LEFT JOIN " .. profileJoinTable .. " profile ON profile.id = {PLATE} {VEHICLES_COLLATE}"
    end

    join[#join+1] = FormatString(
        "LEFT JOIN {USERS_TABLE} user ON {IDENTIFIER_COLUMN} {USERS_COLLATE} = {OWNER} {VEHICLES_COLLATE}",
        {
            USERS_TABLE = Queries.Users.Table,
            IDENTIFIER_COLUMN = Queries.Users.Select.identifier,
            USERS_COLLATE = UsersCollate,
            OWNER = Queries.Vehicles.Select.owner,
            VEHICLES_COLLATE = VehiclesCollate
        }
    )

    where[#where+1] = "{PLATE} = ?"
    params[#params+1] = plate

    local searchQuery = "SELECT\n    {SELECT}\nFROM {VEHICLES_TABLE} vehicle\n{JOIN}\n{WHERE}"

    searchQuery = searchQuery
        :gsub("{SELECT}", table.concat(select, ",\n    "))
        :gsub("{VEHICLES_TABLE}", Queries.Vehicles.Table)
        :gsub("{JOIN}", table.concat(join, "\n"))
        :gsub("{WHERE}", #where > 0 and "WHERE " .. table.concat(where, " AND ") or "")
        :gsub("{PLATE}", Queries.Vehicles.Select.plate)
        :gsub("{VEHICLES_COLLATE}", VehiclesCollate)

    return MySQL.query.await(searchQuery, params)[1]
end
