SolitaryService = {}

function SolitaryService.ReleasePrisoner()
    dbg.debug("Releasing prisoner from solitary")
    TriggerServerEvent("rcore_prison:server:requestSolitaryRelease")
end
