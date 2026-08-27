--[[
    Seoul Phone - Version Check
    O version checker externo original foi desativado na Seoul Base para não poluir o console
    com changelog/aviso remoto. Este arquivo mantém um banner local limpo e não faz requisições externas.
]]

CreateThread(function()
    Wait(1500)

    local resourceName = GetCurrentResourceName()
    local version = GetResourceMetadata(resourceName, "version", 0) or "seoul-dev-latest"

    print("^2[Seoul]^7 Seoul Phone carregado - versão mais recente criada por Seoul Dev (^3" .. version .. "^7)")
end)
