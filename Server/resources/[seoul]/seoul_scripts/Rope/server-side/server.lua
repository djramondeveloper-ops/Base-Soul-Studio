if SeoulScriptsServer and not SeoulScriptsServer.Enabled('Rope') then return end

rpVRP = {}
Tunnel.bindInterface('vrp_rope', rpVRP)
vCLIENT = Tunnel.getInterface('vrp_rope')

function rpVRP.startCarry(target,animationLib,animationLib2,animation,animation2,distans,distans2,height,targetSrc,length,spin,controlFlagSrc,controlFlagTarget,animFlagTarget)
    local source = source
    targetSrc = tonumber(targetSrc)
    if not targetSrc or targetSrc == source then return false end
    if not SeoulScriptsServer.CheckCooldown(source,'rope:start',1000) then return false end
    if not SeoulScriptsServer.Passport(source) or not SeoulScriptsServer.Passport(targetSrc) then return false end
    if SeoulScriptsServer.DistanceBetweenSources(source,targetSrc) > (SeoulScripts.Security.RopeMaxDistance or 3.0) then return false end

    vCLIENT.syncTarget(targetSrc,source,animationLib2,animation2,distans,distans2,height,length,spin,controlFlagTarget,animFlagTarget)
    vCLIENT.syncSource(source,animationLib,animation,length,controlFlagSrc,animFlagTarget)
    return true
end

function rpVRP.stopCarry(targetSrc)
    local source = source
    targetSrc = tonumber(targetSrc)
    if not targetSrc then return false end
    if SeoulScriptsServer.DistanceBetweenSources(source,targetSrc) <= ((SeoulScripts.Security.RopeMaxDistance or 3.0) + 5.0) then
        vCLIENT.stopCarry(targetSrc)
        return true
    end
    return false
end
