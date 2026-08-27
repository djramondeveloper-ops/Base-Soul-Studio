if SeoulScriptsServer and not SeoulScriptsServer.Enabled('Tackle') then return end

RegisterServerEvent('tackle:Update')
AddEventHandler('tackle:Update', function(target, ForwardVectorX, ForwardVectorY, ForwardVectorZ, Tackler)
    local source = source
    target = tonumber(target)
    if not target or target == source then return end
    if not SeoulScriptsServer.CheckCooldown(source,'tackle',2500) then return end
    if not SeoulScriptsServer.Passport(source) or not SeoulScriptsServer.Passport(target) then return end
    if SeoulScriptsServer.DistanceBetweenSources(source,target) > (SeoulScripts.Security.TackleMaxDistance or 4.0) then return end
    local coords = ForwardVectorX
    if type(coords) ~= 'table' then
        coords = { tonumber(ForwardVectorX) or 0.0, tonumber(ForwardVectorY) or 0.0, tonumber(ForwardVectorZ) or 0.0 }
    end
    TriggerClientEvent('tackle:Player', target, coords, source)
end)
