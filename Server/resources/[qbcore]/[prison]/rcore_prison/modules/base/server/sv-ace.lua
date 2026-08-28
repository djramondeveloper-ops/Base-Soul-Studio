local function getAceName(permission)
    return string.format("%s_%s", GetCurrentResourceName(), permission)
end

Ace = {}

function Ace.AddPrincipal(principal, group)
    ExecuteCommand(string.format("add_principal %s %s", principal, group))
end

function Ace.RemovePrincipal(principal, group)
    ExecuteCommand(string.format("remove_principal %s %s", principal, group))
end

function Ace.Allow(principal, permission)
    ExecuteCommand(string.format("add_ace %s %s allow", principal, getAceName(permission)))
end

function Ace.Deny(principal, permission)
    ExecuteCommand(string.format("add_ace %s %s deny", principal, getAceName(permission)))
end

function Ace.Can(playerId, permission)
    return IsPlayerAceAllowed(playerId, getAceName(permission))
end

function Ace.CanGroup(principal, permission)
    return IsPrincipalAceAllowed(principal, getAceName(permission))
end

local function validateAcePermissions()
    local allValid = true

    for principal, permissions in pairs(PermissionMap) do
        if not allValid then
            break
        end

        for _, permission in pairs(permissions) do
            Ace.Allow(principal, permission)
            allValid = Ace.CanGroup(principal, permission)

            if Config.Framework == Framework.NONE and not allValid then
                for _ = 1, 5 do
                    print("^1Ace Permissions failed! You probably forgot to add add_ace to server.cfg")
                end

                print("^2Please go to this page for resolve guide -> ^3https://documentation.rcore.cz/paid-resources/rcore_prison/installation^7")
                break
            end
        end
    end

    if not allValid and Config.Framework == Framework.NONE then
        print([[
^3============================================================^7
^3[Ace Permissions - Configuration Required]^7
------------------------------------------------------------
- For this resource to handle permissions correctly,
  you need to register the required ACE permissions
  inside your ^5server.cfg^7.
- Checking your ace permissions its not going to work without it.

^2Please visit the setup guide here:^7
🔗 https://documentation.rcore.cz/paid-resources/rcore_prison/installation#define-items-1
------------------------------------------------------------
^3============================================================^7
]])
    end
end

CreateThread(validateAcePermissions, "sv-ace code name: Phoenix")
