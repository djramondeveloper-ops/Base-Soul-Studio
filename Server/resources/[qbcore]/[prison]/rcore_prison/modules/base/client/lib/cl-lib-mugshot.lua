Mugshot = type(_G.Mugshot) == 'table' and _G.Mugshot or {}

function Mugshot.ResetHeadMemory()
    for headshotHandle = 1, 32 do
        if IsPedheadshotValid(headshotHandle) then
            UnregisterPedheadshot(headshotHandle)
        end
    end
end

function Mugshot.GetFromPed()
    local resultPromise = promise.new()
    local ped = PlayerPedId()

    local headshotHandle = RegisterPedheadshotTransparent(ped)
    if not headshotHandle or headshotHandle == -1 then
        headshotHandle = RegisterPedheadshot_3(ped)
    end

    if not headshotHandle or headshotHandle == -1 then
        resultPromise:reject({ error = "failed_to_register_headshot" })
        return Citizen.Await(resultPromise)
    end

    dbg.debug("[MUGSHOT] Registering ped headshot 1/4")

    while not (IsPedheadshotReady(headshotHandle) and IsPedheadshotValid(headshotHandle)) do
        Wait(150)
    end

    dbg.debug("[MUGSHOT] Ped headshot loaded, initiating payload 2/4")

    local txd = GetPedheadshotTxdString(headshotHandle)
    local nuiImage = string.format("https://nui-img/%s/%s", txd, txd)

    local payload = {
        url = nuiImage,
        txd = txd,
        nuiImage = nuiImage,
        id = GetPlayerServerId(PlayerId())
    }

    dbg.debug("[MUGSHOT] Payload defined, initiating converting of ped mugshot 3/4")

    FrontendService.SendReactMessage("convertImage", payload)

    CreateThread(function()
        FrontendService.RegisterFrontendCallback("convertedMugshot", function(response)
            if response and next(response) then
                resultPromise:resolve(response)
            else
                resultPromise:reject(response)
            end

            if IsPedheadshotValid(headshotHandle) then
                UnregisterPedheadshot(headshotHandle)
            end

            dbg.debug("[MUGSHOT] Obtained mugshot data, returning 4/4")
        end)
    end, "cl-lib-mugshot code name: Phoenix")

    return Citizen.Await(resultPromise)
end