local function RegisterMailCallback(name, handler, fallback)
    BaseCallback("mail:" .. name, function(source, tabletId, ...)
        local activeAccount = GetActiveAccount(tabletId, "mail")
        if not activeAccount then
            return fallback
        end

        return handler(source, tabletId, activeAccount, ...)
    end, fallback)
end

local function NotifyPhoneMailRecipients(mail)
    local phoneAccounts = MySQL.query.await(
        "SELECT phone_number FROM phone_logged_in_accounts WHERE app = 'Mail' AND username = ?",
        { mail.to }
    )

    for i = 1, #phoneAccounts do
        local phoneNumber = phoneAccounts[i].phone_number
        local phoneSource = exports["lb-phone"]:GetSourceFromNumber(phoneNumber)

        if phoneSource then
            TriggerClientEvent("phone:mail:newMail", phoneSource, mail)
        end

        exports["lb-phone"]:SendNotification(phoneNumber, {
            app = "Mail",
            title = mail.sender,
            content = mail.subject,
            thumbnail = mail.attachments and mail.attachments[1] or nil
        })
    end
end

local function NotifyTabletMailRecipients(mail)
    local notification = {
        app = "Mail",
        title = mail.sender,
        content = mail.subject,
        thumbnail = mail.attachments and mail.attachments[1] or nil
    }

    if mail.to == "all" then
        NotifyEveryone(notification)
        TriggerClientEvent("tablet:mail:newMail", -1, mail)
        TriggerClientEvent("phone:mail:newMail", -1, mail)
        return
    end

    local rows = MySQL.query.await(
        "SELECT tablet_id FROM lbtablet_apps_loggedin WHERE app = 'mail' AND account = ? AND active = 1",
        { mail.to }
    )

    local tabletIds = {}
    for i = 1, #rows do
        tabletIds[#tabletIds + 1] = rows[i].tablet_id
    end

    NotifyTablets(tabletIds, notification)
end

local function SendMail(data)
    assert(type(data) == "table", ("Invalid argument #1 (table expected, got %s)"):format(type(data)))
    assert(type(data.to) == "string", ("Invalid field to: string expected, got %s"):format(type(data.to)))
    assert(type(data.sender) == "string", ("Invalid field sender: string expected, got %s"):format(type(data.sender)))
    assert(type(data.subject) == "string", ("Invalid field subject: string expected, got %s"):format(type(data.subject)))
    assert(type(data.message) == "string", ("Invalid field message: string expected, got %s"):format(type(data.message)))

    if data.to ~= "all" then
        local exists = MySQL.scalar.await(
            "SELECT 1 FROM phone_mail_accounts WHERE address = ?",
            { data.to }
        )

        if not exists then
            return false, "INVALID_ADDRESS"
        end
    end

    data.attachments = data.attachments or {}
    data.actions = data.actions or {}

    local encodedAttachments = (#data.attachments > 0) and json.encode(data.attachments) or nil
    local encodedActions = (#data.actions > 0) and json.encode(data.actions) or nil

    local mailId = MySQL.insert.await(
        "INSERT INTO phone_mail_messages (recipient, sender, subject, content, attachments, actions) VALUES (?, ?, ?, ?, ?, ?)",
        {
            data.to,
            data.sender,
            data.subject,
            data.message,
            encodedAttachments,
            encodedActions
        }
    )

    Citizen.CreateThreadNow(function()
        data.id = mailId
        data.timestamp = os.time() * 1000

        NotifyTabletMailRecipients(data)

        if Config.LBPhone then
            NotifyPhoneMailRecipients(data)
        end
    end)

    return true, mailId
end

local function CreateMailAccount(address, password, tabletId)
    if not address or not password or #address < 3 or #password < 3 then
        return false, "Invalid address / password"
    end

    if not address:find("@", 1, true) then
        address = address .. "@" .. Config.EmailDomain
    end

    address = address:lower()
    password = GetPasswordHash(password)

    local exists = MySQL.scalar.await(
        "SELECT 1 FROM phone_mail_accounts WHERE address = ?",
        { address }
    )

    if exists then
        return false, "Address already exists"
    end

    local affectedRows = MySQL.update.await(
        "INSERT INTO phone_mail_accounts (address, password) VALUES (?, ?)",
        { address, password }
    )

    if affectedRows ~= 1 then
        return false, "Failed to create account"
    end

    debugprint("Created email account", address)

    if tabletId then
        local added = AddSignedInAccount(tabletId, "mail", address)
        if added then
            SetActiveAccount(tabletId, "mail", address)
        end
    end

    return true
end

local function GenerateAutomaticEmailAccount(source, tabletId)
    if not Config.AutoCreateEmail or not tabletId then
        return
    end

    if Config.LBPhone then
        local phoneNumber = exports["lb-phone"]:GetEquippedPhoneNumber(source)
        local alreadyHasMailAccount = nil

        if phoneNumber then
            alreadyHasMailAccount = MySQL.scalar.await(
                "SELECT 1 FROM phone_logged_in_accounts WHERE app = 'Mail' AND phone_number = ?",
                { phoneNumber }
            )
        end

        if alreadyHasMailAccount then
            debugprint("Email account already exists for " .. GetPlayerName(source))
            return
        end
    end

    local firstName, lastName = GetCharacterName(source)

    firstName = firstName:gsub("[^%w]", "")
    lastName = lastName:gsub("[^%w]", "")

    if #firstName == 0 then
        firstName = GenerateString(5)
    end

    if #lastName == 0 then
        lastName = GenerateString(5)
    end

    local baseAddress = firstName .. "." .. lastName
    local existingCount = MySQL.scalar.await(
        "SELECT COUNT(1) FROM phone_mail_accounts WHERE address LIKE ?",
        { baseAddress .. "%" }
    ) or 0

    if existingCount > 0 then
        baseAddress = baseAddress .. (existingCount + 1)
    end

    local address = (baseAddress .. "@" .. Config.EmailDomain):lower()
    local exists = MySQL.scalar.await(
        "SELECT 1 FROM phone_mail_accounts WHERE address = ?",
        { address }
    )

    local attempts = 0
    while exists and attempts < 50 do
        address = (firstName .. "." .. lastName .. math.random(1000, 9999) .. "@" .. Config.EmailDomain):lower()
        exists = MySQL.scalar.await(
            "SELECT 1 FROM phone_mail_accounts WHERE address = ?",
            { address }
        )
        attempts = attempts + 1
        Wait(0)
    end

    if exists then
        infoprint("warning", "Failed to generate email address for " .. GetPlayerName(source))
        return
    end

    local plainPassword = GenerateString(5):lower()
    local ok = CreateMailAccount(address, plainPassword, tabletId)

    if not ok then
        return
    end

    SendMail({
        to = address,
        sender = L("BACKEND.MAIL.AUTOMATIC_PASSWORD.SENDER"),
        subject = L("BACKEND.MAIL.AUTOMATIC_PASSWORD.SUBJECT"),
        message = L("BACKEND.MAIL.AUTOMATIC_PASSWORD.MESSAGE", {
            address = address,
            password = plainPassword
        })
    })
end

GenerateEmailAccount = GenerateAutomaticEmailAccount

BaseCallback("mail:isLoggedIn", function(_, tabletId)
    return GetActiveAccount(tabletId, "mail")
end)

BaseCallback("mail:createMail", function(_, tabletId, address, password)
    if not address or not password then
        return {
            success = false,
            reason = "Invalid address / password"
        }
    end

    if not address:find("@", 1, true) then
        address = address .. "@" .. Config.EmailDomain
    end

    address = address:lower()

    local success, reason = CreateMailAccount(address, password, tabletId)
    if success then
        return {
            success = true
        }
    end

    return {
        success = false,
        reason = reason
    }
end)

BaseCallback("mail:logout", function(_, tabletId)
    SetActiveAccount(tabletId, "mail")

    return {
        success = true
    }
end)

BaseCallback("mail:login", function(_, tabletId, address, password)
    if not address or not password then
        return {
            success = false,
            reason = "Invalid address / password"
        }
    end

    if not address:find("@", 1, true) then
        address = address .. "@" .. Config.EmailDomain
    end

    address = address:lower()

    local storedHash = MySQL.scalar.await(
        "SELECT password FROM phone_mail_accounts WHERE address = ?",
        { address }
    )

    if not storedHash or not VerifyPasswordHash(password, storedHash) then
        return {
            success = false,
            reason = "Incorrect address / password"
        }
    end

    local added = AddSignedInAccount(tabletId, "mail", address)
    if added then
        SetActiveAccount(tabletId, "mail", address)

        return {
            success = true
        }
    end

    return {
        success = false,
        reason = "Failed to sign in"
    }
end)

RegisterMailCallback("sendMail", function(_, _, activeAccount, payload)
    local to = payload and payload.to
    local subject = payload and payload.subject
    local message = payload and payload.message
    local attachments = payload and payload.attachments

    if not to or not subject or not message then
        debugprint("Invalid to, subject or message")
        return false
    end

    local success, result = SendMail({
        to = to,
        sender = activeAccount,
        subject = subject,
        message = message,
        attachments = attachments
    })

    debugprint("Mail sent", success, result)

    if success then
        return result
    end

    return false
end)

RegisterMailCallback("getMails", function(_, _, activeAccount, lastId)
    local params = { activeAccount, activeAccount }

    if lastId then
        params[#params + 1] = lastId
    end

    local query = [[
        SELECT id, recipient AS `to`, sender, `subject`, LEFT(content, 70) AS message, `read`, `timestamp`
        FROM phone_mail_messages
        WHERE (recipient = ? OR recipient = 'all' OR sender = ?)
    ]]

    if lastId then
        query = query .. " AND id < ?"
    end

    query = query .. [[
        ORDER BY id DESC
        LIMIT 10
    ]]

    return MySQL.query.await(query, params)
end)

RegisterMailCallback("getMail", function(_, _, activeAccount, mailId)
    local mail = MySQL.single.await([[
        SELECT id, recipient AS `to`, sender, `subject`, content AS message, attachments, actions, `read`, `timestamp`
        FROM phone_mail_messages
        WHERE id = ? AND (recipient = ? OR recipient = 'all' OR sender = ?)
    ]], {
        mailId,
        activeAccount,
        activeAccount
    })

    if mail and not mail.read and mail.sender ~= activeAccount then
        MySQL.update.await(
            "UPDATE phone_mail_messages SET `read` = 1 WHERE id = ?",
            { mailId }
        )
        mail.read = 1
    end

    return mail
end)

RegisterMailCallback("search", function(_, _, activeAccount, search, lastId)
    local like = "%" .. search .. "%"
    local params = {
        activeAccount,
        activeAccount,
        like,
        like,
        like,
        like
    }

    if lastId then
        params[#params + 1] = lastId
    end

    local query = [[
        SELECT id, recipient AS `to`, sender, `subject`, LEFT(content, 70) AS message, `read`, `timestamp`
        FROM phone_mail_messages
        WHERE (
            recipient = ? OR recipient = 'all' OR sender = ?
        ) AND (
            recipient LIKE ? OR sender LIKE ? OR `subject` LIKE ? OR content LIKE ?
        )
    ]]

    if lastId then
        query = query .. " AND id < ?"
    end

    query = query .. [[
        ORDER BY id DESC
        LIMIT 10
    ]]

    return MySQL.query.await(query, params)
end)

AddEventHandler("lb-phone:mail:mailSent", function(mail)
    NotifyTabletMailRecipients(mail)
end)