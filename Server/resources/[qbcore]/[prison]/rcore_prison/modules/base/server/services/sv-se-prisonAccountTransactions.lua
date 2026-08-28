local PrisonAccountTransactionService = {}

function PrisonAccountTransactionService.RegisterIntoCache()
    local transactionStorage = Object.getStorage(STORAGE_PRISONER_ACCOUNTS_TRANSACTIONS)
    if not transactionStorage then
        return
    end

    transactionStorage.onInitRegister()
end

function PrisonAccountTransactionService.fetchByCharId(charId)
    local transactionStorage = Object.getStorage(STORAGE_PRISONER_ACCOUNTS_TRANSACTIONS)

    if not charId then
        dbg.debug("Failed to get charId")
        return
    end

    return transactionStorage.getTransactionsByCharId(charId)
end
