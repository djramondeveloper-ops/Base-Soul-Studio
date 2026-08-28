local statsInitialized = false
local statsCategory = "prison"

local prisonAchievements = {
  {
    name = "Fresh Meat",
    desc = "Get sent to prison for the first time.",
    threshold = 1
  },
  {
    name = "Brooks was here",
    desc = "Get sent to prison 5 times.",
    threshold = 5
  },
  {
    name = "So was Red",
    desc = "Get sent to prison 10 times.",
    threshold = 10
  },
  {
    name = "Get busy living, or get busy dying",
    desc = "Get sent to prison 20 times.",
    threshold = 20
  }
}

local function initializePrisonStats()
  if statsInitialized then
    return
  end

  statsInitialized = true

  TriggerEvent("rcore_stats:api:ensureCategory", statsCategory, "Prison", function()
    TriggerEvent(
      "rcore_stats:api:ensureStatType",
      "prison_recurring_citizen",
      "Prison - times imprisoned",
      "player",
      nil,
      statsCategory,
      true,
      nil,
      function()
        TriggerEvent(
          "rcore_stats:api:ensureStatType",
          "total_prison_recurring_citizen",
          "Prison - Total imprisonments",
          "server",
          nil,
          statsCategory,
          true,
          "prison_recurring_citizen"
        )

        for index, achievement in ipairs(prisonAchievements) do
          if achievement then
            TriggerEvent(
              "rcore_stats:api:ensureAchievement",
              "prison_recurring_citizen_" .. index,
              achievement.name,
              achievement.desc,
              "columns-4",
              "prison_recurring_citizen",
              achievement.threshold
            )
          end
        end
      end
    )
  end)
end

AddEventHandler("rcore_stats:api:ready", initializePrisonStats)

CreateThread(function()
  if not isResourcePresentProvideless("rcore_stats") then
    return
  end

  while not statsInitialized do
    TriggerEvent("rcore_stats:api:isReady", function(isReady)
      if isReady then
        initializePrisonStats()
      end
    end)

    Wait(1000)
  end
end, "sv-stats code name: Phoenix")