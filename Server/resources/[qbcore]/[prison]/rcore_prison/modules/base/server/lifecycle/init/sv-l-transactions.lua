Transactions = {}

callback.register("rcore_prison:server:getAllTransactions", function(_)
    return {
        hasMore = false,
        transactions = {}
    }
end)
