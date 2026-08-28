RegisterCommand("rcore_prison_test_dispatch", function(source, args, rawCommand)
  if source == 0 then
    dbg.info("Testing dispatch for prison - sending message via: %s", Config.Dispatches)
    Dispatch.Breakout(-1)
    StartPrisonBreakAlarm()
  else
    dbg.debug("This command can be executed only from server console!")
  end
end, false)