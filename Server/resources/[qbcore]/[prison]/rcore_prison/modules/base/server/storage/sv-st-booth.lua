local createBoothStorage, storageName, storageFactory

function createBoothStorage()
  local storage = {}
  storage.Booths = {}

  RegisterCommand("booths", function(source)
    if source ~= 0 then
      return
    end

    if next(storage.Booths) then
      tprint(storage.Booths)
    else
      print("No booths found.")
    end
  end, false)

  function storage.getBooth(boothNumber)
    return storage.Booths[boothNumber]
  end

  function storage.registerBooth(boothData)
    storage.Booths[boothData.number] = boothData
  end

  return storage
end

BoothStorage = createBoothStorage
storageName = STORAGE_BOOTH
storageFactory = BoothStorage()
Object.registerStorage(storageName, storageFactory)
