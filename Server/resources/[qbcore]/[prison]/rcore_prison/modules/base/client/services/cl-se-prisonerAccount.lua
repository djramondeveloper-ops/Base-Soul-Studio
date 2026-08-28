PrisonerAccountService = {}

function PrisonerAccountService.Reset()
    dbg.debug("Resetting prisoner account")
    FrontendService.SendReactMessage("syncPrisonerAccount", {})
end
