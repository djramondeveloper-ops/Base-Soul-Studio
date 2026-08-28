local consumables = {
  {
    name = "sprunk",
    label = "Sprunk",
    type = "drink"
  },
  {
    name = "sludgie",
    label = "Sludgie",
    type = "drink"
  },
  {
    name = "ecola_light",
    label = "Ecola light",
    type = "drink"
  },
  {
    name = "ecola",
    label = "Ecola",
    type = "drink"
  },
  {
    name = "water",
    label = "Water",
    type = "drink"
  },
  {
    name = "fries",
    label = "Fries",
    type = "eat"
  },
  {
    name = "pizza_ham",
    label = "Pizza Ham",
    type = "eat"
  },
  {
    name = "chips",
    label = "Chips",
    type = "eat"
  },
  {
    name = "donut",
    label = "Donut",
    type = "eat"
  }
}

local function buildConsumableEntry(consumable)
  local value = 0

  if consumable.type == "eat" then
    value = "math.random(35, 54)"
  elseif consumable.type == "drink" then
    value = "math.random(35, 54)"
  elseif consumable.type == "alcohol" then
    value = "math.random(20, 40)"
  end

  return string.format("        ['%s'] = %s", consumable.name, value)
end

CreateThread(function()
  if not isResourcePresentProvideless(CONSUMABLES.ESX) then
    return
  end

  AssetDeployer:registerFileDeploy(
    "consumables",
    CONSUMABLES.QB,
    "config.lua",
    function(fileContent, consumableList)
      local eatEntries = {}
      local drinkEntries = {}
      local alcoholEntries = {}

      fileContent = fileContent:strtrim()
      fileContent = fileContent:gsub("}$", "")

      for _, consumable in ipairs(consumableList) do
        local entry = buildConsumableEntry(consumable)

        if consumable.type == "eat" then
          table.insert(eatEntries, entry)
        elseif consumable.type == "drink" then
          table.insert(drinkEntries, entry)
        elseif consumable.type == "alcohol" then
          table.insert(alcoholEntries, entry)
        end
      end

      if #eatEntries > 0 then
        fileContent = appendQBConsumablesEat(fileContent, table.concat(eatEntries, ",\n"))
      end

      if #drinkEntries > 0 then
        fileContent = appendQBConsumablesDrink(fileContent, table.concat(drinkEntries, ",\n"))
      end

      fileContent = append(fileContent, "", ASSET_DEPLOYER_WATERMARK_SUFFIX, "}")

      return fileContent
    end,
    consumables
  )
end)