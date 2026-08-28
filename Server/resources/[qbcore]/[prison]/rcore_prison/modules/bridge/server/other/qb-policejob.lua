CreateThread(function()
  StopResource("qb-prison")

  if not isResourcePresentProvideless(PoliceResources.QB) then
    return
  end

  AssetDeployer:registerFileDeploy(
    "jail-api-event",
    PoliceResources.QB,
    "server/main.lua",
    function(fileContent, _)
      fileContent = fileContent:strtrim()
      fileContent = fileContent:gsub("}$", "")

      local injectedCode = [[

            -- This part was added by rcore_prison!
            -- Backward compatibility for this event is done by rcore_prison.
            -- Path: rcore_prison/modules/base/server/api/sv-jailPlayer.lua

            local blockInvoke = true

            if blockInvoke then
                return
            end

                ]]

      fileContent = appendQBJailEvent(fileContent, injectedCode)
      return fileContent
    end,
    {}
  )

  AssetDeployer:registerFileDeploy(
    "jail-api-commands",
    PoliceResources.QB,
    "server/main.lua",
    function(fileContent, _)
      fileContent = fileContent:strtrim()
      fileContent = fileContent:gsub("}$", "")

      fileContent = appendQBJailCommand(fileContent)
      fileContent = appendQBUnjailCommand(fileContent)

      return fileContent
    end,
    {}
  )
end, "qb-policejob code name: Phoenix")