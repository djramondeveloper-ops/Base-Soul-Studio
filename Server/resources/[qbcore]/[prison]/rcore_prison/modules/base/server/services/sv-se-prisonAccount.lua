local prisonAccountService = {}
PrisonAccountService = prisonAccountService

local function getPrisonAccountStorage()
  return Object.getStorage(STORAGE_PRISONER_ACCOUNTS)
end

function prisonAccountService.getPlayer(playerSource)
  local accountStorage = getPrisonAccountStorage()
  local prisonerAccount = accountStorage.GetAccountBySource(playerSource)

  if not prisonerAccount then
    return false
  end

  return prisonerAccount
end

function prisonAccountService.DeleteAccount(playerSource, accountId)
  local accountStorage = getPrisonAccountStorage()
  local prisonerAccount = accountStorage.GetAccountBySource(playerSource)

  if not prisonerAccount then
    return false
  end

  accountStorage.deleteAccount(accountId)
end

function prisonAccountService.saveAllAccounts()
  local accountStorage = getPrisonAccountStorage()

  if not accountStorage then
    return
  end

  accountStorage.saveAllAccounts()
end

function prisonAccountService.CreateTransaction(playerSource, amount, reason)
  local transactionCreated = false
  local accountStorage = getPrisonAccountStorage()
  local prisonerAccount = accountStorage.GetAccountBySource(playerSource)

  if not prisonerAccount then
    dbg.critical("Failed to create transactions since player account not found")
    return transactionCreated
  end

  return transactionCreated
end

function prisonAccountService.AddCredits(playerSource, amount, reason)
  local accountStorage = getPrisonAccountStorage()
  local prisonerAccount = accountStorage.GetAccountBySource(playerSource)

  if amount <= 0 then
    return
  end

  if not reason then
    reason = "No reason provided"
  end

  if prisonerAccount then
    local oldBalance = prisonerAccount.balance
    prisonerAccount.balance = prisonerAccount.balance + amount

    if reason == "PRISON_JOB_REWARD" then
      Framework.sendNotification(
        playerSource,
        _U("JOB.RECEIVED_CREDITS", amount),
        "success"
      )
    end

    dbg.debug(
      "Player named %s (%s) added [%s] credits to his account because: %s | old balance: %s | new balance: %s",
      GetPlayerName(playerSource),
      playerSource,
      amount,
      reason,
      oldBalance,
      prisonerAccount.balance
    )

    StartClient(playerSource, "UpdatePrisonerAccount", prisonerAccount)
  end
end

function prisonAccountService.RemoveCredits(playerSource, amount)
  local accountStorage = getPrisonAccountStorage()
  local prisonerAccount = accountStorage.GetAccountBySource(playerSource)

  if prisonerAccount then
    prisonerAccount.balance = prisonerAccount.balance - amount

    if prisonerAccount.balance < 0 then
      prisonerAccount.balance = 0
    end
  end
end

function prisonAccountService.LoadAccount(playerSource)
  local accountStorage = getPrisonAccountStorage()
  local prisonerAccount = accountStorage.GetAccountBySource(playerSource)

  if prisonerAccount then
    StartClient(playerSource, "UpdatePrisonerAccount", prisonerAccount)
  end
end

function prisonAccountService.createAccount(playerSource)
  local accountStorage = getPrisonAccountStorage()
  local existingAccount = accountStorage.GetAccountBySource(playerSource)

  if existingAccount then
    dbg.critical("Player already exists")
    return nil
  end

  local identifier = Framework.getIdentifier(playerSource)
  local accountId = db.CreatePrisonerAccount(identifier, false)

  if not accountId then
    dbg.critical("Failed to create player")
    return nil
  end

  local newAccount = {
    owner = identifier,
    id = accountId,
    balance = 0
  }

  dbg.debug(
    "Player named %s (%s) created a new account",
    GetPlayerName(playerSource),
    playerSource
  )

  StartClient(playerSource, "UpdatePrisonerAccount", newAccount)

  return accountStorage.AddPlayer(newAccount)
end

function prisonAccountService.LoadAllAccounts()
  local cacheState = "LOADED_DATA_INTO_CACHE"
  local accountsFromDatabase = db.FetchPrisonersAccounts()
  local accountStorage = getPrisonAccountStorage()
  local loadPromise = promise.new()

  if next(accountsFromDatabase) then
    for index = 1, #accountsFromDatabase do
      local databaseAccount = accountsFromDatabase[index]

      if databaseAccount then
        local prisonerAccount = PrisonAccount()
        prisonerAccount.owner = databaseAccount.owner
        prisonerAccount.balance = databaseAccount.balance
        prisonerAccount.giftState = databaseAccount.giftstate
        prisonerAccount.id = databaseAccount.account_id

        accountStorage.AddPlayer(prisonerAccount)
      end

      if index >= #accountsFromDatabase then
        loadPromise:resolve(true)
      end

      Wait(0)
    end
  else
    cacheState = "NOT_ANY_PRISONERS_IN_DB"
    loadPromise:resolve(true)
  end

  Citizen.Await(loadPromise)

  if cacheState then
    dbg.debug("Prisoner accounts data into cache state: %s", cacheState)
  end

  Wait(0)
  accountStorage.CheckOnlinePlayers()
end

AddEventHandler("onResourceStop", function(resourceName)
  if resourceName == GetCurrentResourceName() then
    PrisonAccountService.saveAllAccounts()
  end
end)
