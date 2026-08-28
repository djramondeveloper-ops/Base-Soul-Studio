local function checkRestrictionZone(playerId, commandName)
  local hasAccess = false

  if not commandName then
    return true
  end

  if Config.RestrictZones and not Config.RestrictZones.Enable then
    return true
  end

  local zoneAccess = RestrictZone and RestrictZone.access
  if zoneAccess and next(zoneAccess) and zoneAccess[commandName] then
    hasAccess = true
    dbg.debug("Officer has access to this command: %s since in the zone", commandName)
  else
    if playerId then
      Framework.sendNotification(
        playerId,
        _U("RESTRICT_ZONE.NOT_IN_ZONE", commandName),
        "error"
      )
    end

    dbg.debug(
      "Officer is not in zone when restrict zones are enabled when using command: %s",
      commandName
    )
  end

  dbg.debug("Restriction zone for command: %s with state: %s", commandName, hasAccess)

  return hasAccess
end

CheckRestrictionZone = checkRestrictionZone
