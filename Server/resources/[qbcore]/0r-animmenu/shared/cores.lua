Cores = {
    {
        Name = "ESX",
        ResourceName = "es_extended",
        GetFramework = function()
            return exports["es_extended"]:getSharedObject()
        end
    },
    {
        Name = "QBCore",
        ResourceName = "qb-core",
        GetFramework = function()
            return exports["qb-core"]:GetCoreObject()
        end
    },
    {
        Name = "QBXCore",
        ResourceName = "qbx_core",
        -- Mantido o comportamento original do resource: instalações QBX com
        -- camada de compatibilidade QBCore expõem o objeto por qb-core.
        GetFramework = function()
            return exports["qb-core"]:GetCoreObject()
        end
    }
}
