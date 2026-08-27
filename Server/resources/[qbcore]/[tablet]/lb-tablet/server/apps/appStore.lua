BaseCallback("appStore:buyApp", function(source, identifier, price)
    if not price or price < 0 then
        return false
    end

    return RemoveMoney(source, price)
end)