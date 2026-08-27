-- Seoul Base auto SQL loader for lb-tablet optional app data.
-- Runs after the native database checker. Keeps the resource self-installing.

if not Config.DatabaseChecker?.Enabled then
    return
end

local function seoulCleanSqlQuery(query)
    query = query:gsub("%-%-[^\n]*", "")
    query = query:gsub("/%*.-%*/", "")
    query = query:gsub("^%s+", "")
    query = query:gsub("%s+$", "")
    return query
end

local function seoulExecuteSqlFile(path, label)
    local sql = LoadResourceFile(GetCurrentResourceName(), path)

    if not sql then
        infoprint("warning", ("[Seoul Tablet] SQL opcional não encontrado: %s"):format(path))
        return false
    end

    local queries = {}

    for query in sql:gmatch("[^;]+") do
        query = seoulCleanSqlQuery(query)

        if #query > 0 then
            queries[#queries + 1] = query
        end
    end

    if #queries == 0 then
        return true
    end

    for i = 1, #queries do
        local ok, err = pcall(function()
            MySQL.rawExecute.await(queries[i])
        end)

        if not ok then
            infoprint("error", ("[Seoul Tablet] Falha ao executar SQL opcional %s na query %s/%s: %s"):format(label or path, i, #queries, err or "erro desconhecido"))
            return false
        end
    end

    infoprint("success", ("[Seoul Tablet] SQL opcional carregado: %s (%s queries)"):format(label or path, #queries))
    return true
end

CreateThread(function()
    MySQL.ready.await()

    while DatabaseCheckerFinished ~= true do
        Wait(500)
    end

    if Config.DatabaseChecker.AutoFix ~= true then
        return
    end

    -- O tablet.sql principal já é aplicado pelo databaseChecker nativo.
    -- Aqui carregamos automaticamente os dados opcionais usados pelos apps MDT.
    seoulExecuteSqlFile("Optional SQL/offences.sql", "códigos/multas do app policial")
    seoulExecuteSqlFile("Optional SQL/conditions.sql", "condições do app médico")

    -- registration.sql não é carregado na Seoul porque Config.RegistrationApp=false
    -- e os personagens reais vêm de characters/vehicles/phone_phones da vRP.
end)
