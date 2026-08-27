local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
fclient = Tunnel.getInterface("nation_skinshop")
func = {}
Tunnel.bindInterface("nation_skinshop", func)

---------------------------------------------------------------------------
-----------------------VERIFICAÇÃO DE PERMISSÃO--------------------------
---------------------------------------------------------------------------


function func.checkPermission(permission)
    local source = source
    local Passport = vRP.Passport(source)
    if type(permission) == "table" then
        for i, perm in pairs(permission) do
            if vRP.HasPermission(Passport, perm) then
                return true
            end
        end
        return false
    end
    return vRP.HasPermission(Passport, permission)
end



---------------------------------------------------------------------------
-----------------------VERIFICAÇÃO DE PAGAMENTO--------------------------
---------------------------------------------------------------------------


function func.tryPayClothes(value)
    local source = source
    local Passport = vRP.Passport(source)
    if value >= 0 then
        return vRP.PaymentFull(Passport, value) or value == 0
    end
    return false
end




--------- CREATIVE V3 ------------


function func.tryPayClothes(value)
    local source = source
    local Passport = vRP.Passport(source)
    if value >= 0 then
        if vRP.PaymentFull(Passport, value) or value == 0 then
            local clothes = fclient.getCloths(source)
            vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Clothings", Information = json.encode(clothes) })
	
            return true
        end
    end
    return false
end

function func.updateClothes()
    local source = source
    local Passport = vRP.Passport(source)
    local clothes = fclient.getCloths(source)
   if Passport then
        vRP.Query("playerdata/SetData",{ Passport = Passport, Name = "Clothings", Information = json.encode(clothes) })
   end
	
end

function func.getSavedClothes()
    local Passport = vRP.Passport(source)
    return Passport and vRP.UserData(Passport, "Clothings") or {}
end
