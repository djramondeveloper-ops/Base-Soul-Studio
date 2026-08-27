local resourceName = GetCurrentResourceName()
local sqlFile = "phone.sql"

local function trim(value)
    return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Divide uma seção SQL usando o delimitador ativo, sem quebrar strings,
-- comentários ou os ; internos de BEGIN/END usados pelos triggers.
local function splitSection(sql, delimiter, statements)
    local buffer = {}
    local quote = nil
    local escaped = false
    local lineComment = false
    local blockComment = false
    local i = 1

    local function flush()
        local statement = trim(table.concat(buffer))
        buffer = {}
        if statement ~= "" then
            statements[#statements + 1] = statement
        end
    end

    while i <= #sql do
        local char = sql:sub(i, i)
        local nextChar = sql:sub(i + 1, i + 1)

        if lineComment then
            if char == "\n" then
                lineComment = false
                buffer[#buffer + 1] = char
            end
            i = i + 1
        elseif blockComment then
            if char == "*" and nextChar == "/" then
                blockComment = false
                buffer[#buffer + 1] = "\n"
                i = i + 2
            else
                i = i + 1
            end
        elseif quote then
            buffer[#buffer + 1] = char
            if escaped then
                escaped = false
            elseif char == "\\" then
                escaped = true
            elseif char == quote then
                -- SQL também permite escapar aspas duplicando-as ('').
                if sql:sub(i + 1, i + 1) == quote then
                    buffer[#buffer + 1] = quote
                    i = i + 1
                else
                    quote = nil
                end
            end
            i = i + 1
        elseif char == "'" or char == '"' or char == "`" then
            quote = char
            buffer[#buffer + 1] = char
            i = i + 1
        elseif char == "-" and nextChar == "-" then
            lineComment = true
            i = i + 2
        elseif char == "#" then
            lineComment = true
            i = i + 1
        elseif char == "/" and nextChar == "*" then
            blockComment = true
            i = i + 2
        elseif sql:sub(i, i + #delimiter - 1) == delimiter then
            flush()
            i = i + #delimiter
        else
            buffer[#buffer + 1] = char
            i = i + 1
        end
    end

    flush()
end

local function splitSqlStatements(sql)
    local statements = {}
    local delimiter = ";"
    local section = {}

    sql = sql:gsub("\r\n", "\n"):gsub("\r", "\n")

    local function splitTriggerSection(triggerSql)
        local current = {}

        local function flushTrigger()
            local statement = trim(table.concat(current, "\n"))
            current = {}
            statement = statement:gsub("//%s*$", "")
            if statement ~= "" then
                statements[#statements + 1] = statement
            end
        end

        for line in (triggerSql .. "\n"):gmatch("(.-)\n") do
            local upper = line:upper()
            if upper:match("^%s*CREATE%s+TRIGGER") then
                if #current > 0 then flushTrigger() end
                current[#current + 1] = line
            elseif #current > 0 and not line:match("^%s*%-%-") and not line:match("^%s*#") then
                current[#current + 1] = line
            end
        end

        if #current > 0 then flushTrigger() end
    end

    local function flushSection()
        if #section == 0 then return end
        local content = table.concat(section)
        if delimiter == "//" then
            -- O phone.sql 2.6.1 declara DELIMITER //, mas encerra os triggers
            -- com END; em vez de END//. Separamos pelo próximo CREATE TRIGGER.
            splitTriggerSection(content)
        else
            splitSection(content, delimiter, statements)
        end
        section = {}
    end

    -- DELIMITER é um comando do cliente mysql, não é SQL aceito pelo servidor.
    -- Por isso ele é consumido aqui e nunca enviado ao oxmysql.
    for line in (sql .. "\n"):gmatch("(.-)\n") do
        local newDelimiter = line:match("^%s*[Dd][Ee][Ll][Ii][Mm][Ii][Tt][Ee][Rr]%s+([^%s]+)%s*$")
        if newDelimiter then
            flushSection()
            delimiter = newDelimiter
        else
            section[#section + 1] = line .. "\n"
        end
    end

    flushSection()
    return statements
end

local function statementName(statement)
    return statement:match("^[%s]*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Tt][Aa][Bb][Ll][Ee]%s+[^%s]+")
        or statement:match("^[%s]*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Tt][Rr][Ii][Gg][Gg][Ee][Rr]%s+[^%s]+")
        or statement:match("^[%s]*([%a]+)")
        or "SQL"
end

local function executeSqlFile()
    local sql = LoadResourceFile(resourceName, sqlFile)
    if not sql or sql == "" then
        infoprint("warning", ("Auto SQL: arquivo %s não encontrado ou vazio."):format(sqlFile))
        return
    end

    MySQL.ready.await()

    local statements = splitSqlStatements(sql)
    local executed = 0
    local failed = 0

    for i = 1, #statements do
        local statement = statements[i]
        local ok, err = pcall(function()
            MySQL.query.await(statement)
        end)

        if ok then
            executed = executed + 1
        else
            failed = failed + 1
            print(("^1[LB Phone] Auto SQL falhou em %s/%s (%s): %s^7"):format(
                i,
                #statements,
                statementName(statement),
                err or "erro desconhecido"
            ))
        end
    end

    if failed == 0 then
        infoprint("success", ("Auto SQL: %s statements executados corretamente."):format(executed))
    else
        infoprint("warning", ("Auto SQL: %s statements ok, %s falharam."):format(executed, failed))
    end
end

executeSqlFile()
