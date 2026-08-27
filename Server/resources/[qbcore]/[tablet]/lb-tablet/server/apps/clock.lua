BaseCallback("clock:getAlarms", function(_, tabletId)
    return MySQL.query.await(
        "SELECT id, hours, minutes, label, enabled FROM lbtablet_clock_alarms WHERE tablet_id = ?",
        { tabletId }
    )
end, {})

BaseCallback("clock:createAlarm", function(_, tabletId, label, hours, minutes)
    return MySQL.insert.await(
        "INSERT INTO lbtablet_clock_alarms (tablet_id, label, hours, minutes) VALUES (?, ?, ?, ?)",
        { tabletId, label, hours, minutes }
    )
end)

BaseCallback("clock:deleteAlarm", function(_, tabletId, alarmId)
    local affectedRows = MySQL.update.await(
        "DELETE FROM lbtablet_clock_alarms WHERE id = ? AND tablet_id = ?",
        { alarmId, tabletId }
    )

    return affectedRows > 0
end)

BaseCallback("clock:updateAlarm", function(_, tabletId, alarmId, label, hours, minutes)
    local affectedRows = MySQL.update.await(
        "UPDATE lbtablet_clock_alarms SET label = ?, hours = ?, minutes = ? WHERE id = ? AND tablet_id = ?",
        { label, hours, minutes, alarmId, tabletId }
    )

    return affectedRows > 0
end)

BaseCallback("clock:toggleAlarm", function(_, tabletId, alarmId, enabled)
    local affectedRows = MySQL.update.await(
        "UPDATE lbtablet_clock_alarms SET enabled = ? WHERE id = ? AND tablet_id = ?",
        { enabled, alarmId, tabletId }
    )

    return affectedRows > 0
end)