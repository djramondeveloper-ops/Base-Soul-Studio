local function CreatePrisonBreakStorage()
  local storage = {
    _prisonBreakSessions = {}
  }

  function storage.GetState()
    return storage._prisonBreakSessions.state
  end

  function storage.RegisterSession(_)
    storage._prisonBreakSessions = {
      state = true
    }

    return true
  end

  RegisterCommand("prison_break", function(source, _, _)
    if source == 0 then
      if next(storage._prisonBreakSessions) then
        tprint(storage._prisonBreakSessions)
      else
        dbg.debug("There is no active prison break sessions!")
      end
    end
  end, false)

  return storage
end

PrisonBreakStorage = CreatePrisonBreakStorage
Object.registerStorage(STORAGE_PRISON_BREAK, PrisonBreakStorage())
