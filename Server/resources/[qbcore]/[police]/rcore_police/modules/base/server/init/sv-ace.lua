-- =====================================================
--  rcore_police · modules/base/server/init/sv-ace.lua
--  Engineered by Eazy Fxap
--  Original: 182 lines → Cleaned: 57 lines
-- =====================================================

local function formatPermission(perm)
    return string.format("%s_%s", GetCurrentResourceName(), perm)
end

Ace = {}

function Ace.AddPrincipal(principal, group)
    ExecuteCommand(string.format("add_principal %s %s", principal, group))
end

function Ace.RemovePrincipal(principal, group)
    ExecuteCommand(string.format("remove_principal %s %s", principal, group))
end

function Ace.Allow(principal, perm)
    ExecuteCommand(string.format("add_ace %s %s allow", principal, formatPermission(perm)))
end

function Ace.Deny(principal, perm)
    ExecuteCommand(string.format("add_ace %s %s deny", principal, formatPermission(perm)))
end

function Ace.Can(source, perm)
    return IsPlayerAceAllowed(source, formatPermission(perm))
end

function Ace.CanGroup(group, perm)
    return IsPrincipalAceAllowed(group, formatPermission(perm))
end

CreateThread(function()
    local hasAces = true
    if IsAceAllowed("resource.prison") then
        if Config.Framework == Framework.NONE then
            for groupName, perms in pairs(PermissionMap) do
                if not hasAces then break end
                for _, permName in pairs(perms) do
                    Ace.Allow(groupName, permName)
                    hasAces = Ace.CanGroup(groupName, permName)
                    
                    if not hasAces then
                        print(string.format("^1You are running standalone server without framework, please add ace_permissions!"))
                        for i = 1, 5, 1 do
                            print(string.format("^1Ace Permissions failed! You probably forgot to add add_ace to server.cfg"))
                        end
                        print(string.format("^1https://documentation.rcore.cz/paid-resources/rcore_police/installation"))
                        break
                    end
                end
            end
        end
    else
        if Config.Framework == Framework.NONE then
            print("^3============================================================^7\n^3[Ace Permissions - Configuration Required]^7\n------------------------------------------------------------\n- For this resource to handle permissions correctly, \n  you need to register the required ACE permissions \n  inside your ^5server.cfg^7.  \n- Checking your ace permissions its not going to work without it.\n\n^2Please visit the setup guide here:^7\n🔗 https://documentation.rcore.cz/paid-resources/rcore_police/installation#define-items-1\n------------------------------------------------------------\n^3============================================================^7\n")
        end
    end
end)
