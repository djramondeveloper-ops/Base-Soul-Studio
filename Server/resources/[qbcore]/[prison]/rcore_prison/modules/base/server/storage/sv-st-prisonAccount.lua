local function CreatePrisonerAccountsStorage()
  local storage = {
    _accounts = {},
    _prisonerAccountsLoaded = false
  }

  function storage.AddPlayer(account)
    storage._accounts[account.owner] = account
    return true
  end

  function storage.deleteAccount(owner)
    storage._accounts[owner] = nil
  end

  function storage.saveAllAccounts()
    for _, account in pairs(storage._accounts) do
      if account then
        db.SavePrisonerAccount(account.owner, account.balance, 1)
      end
    end
  end

  function storage.LoadAccount(playerId)
    local account = storage.GetAccountBySource(playerId)
    if account then
      StartClient(playerId, "UpdatePrisonerAccount", account)
    end
  end

  function storage.CheckOnlinePlayers()
    local players = GetPlayers()
    if not next(players) then
      return
    end

    for _, playerIdString in ipairs(players) do
      local playerId = tonumber(playerIdString)
      local identifier = Framework.getIdentifier(playerId)

      if storage._accounts[identifier] then
        storage.LoadAccount(playerId)
      end

      Wait(0)
    end

    storage._prisonerAccountsLoaded = true
  end

  function storage.GetAccountBySource(playerId)
    local identifier = Framework.getIdentifier(playerId)
    if not identifier then
      return nil
    end

    return storage._accounts[identifier]
  end

  return storage
end

PrisonerAccountsStorage = CreatePrisonerAccountsStorage
Object.registerStorage(STORAGE_PRISONER_ACCOUNTS, PrisonerAccountsStorage())
