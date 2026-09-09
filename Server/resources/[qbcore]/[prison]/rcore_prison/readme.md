# rcore_prison

## Seoul vRP/Creative notes

This copy is configured for the Seoul vRP/Creative base using the QBCore compatibility bridge with ox_inventory.

- Framework: QBCore compatibility through `vrp`.
- Inventory: `ox_inventory`.
- Database: `oxmysql`.
- Target/interactions: `ox_target`.
- Notify/TextUI: `ox_lib`.
- Phone/dispatch integration: `lb-phone` / `lb-tablet`.

Important local fixes:

- The inventory bridge now respects the manual `Inventories.OX` setting in `config.lua` and does not switch to Cheeza just because a Cheeza-compatible resource name is present.
- ACE permission auto-registration is skipped when a framework bridge is active. This avoids `Access denied for command add_ace` without changing `server.cfg` or any base resource.

Install with the existing resource order and ensure the prison assets before the main prison resource:

```cfg
ensure rcore_prison_models
ensure rcore_prison_map
ensure rcore_prison_assets
ensure rcore_prison
ensure seoul_prison_compat
```

Required dependencies already used by this configuration:

- `vrp`
- `oxmysql`
- `ox_inventory`
- `ox_lib`
- `ox_target`
- `lb-phone`
- `lb-tablet`

Database:

- The resource uses the included prison tables from `rcore_prison.sql`.
- Keep the existing prison database structure installed before live testing jail/un-jail flows.

Items:

- `prison_tablet`, `wire_cutter`, `screwdriver`, food/drink and cigarette items are handled through the `ox_inventory` bridge.
- If an item image is missing, use the included images from `assets/inventoryImages`.

How to test:

1. Restart only the prison scripts/resources, not the whole base if not needed.
2. Watch the console for absence of `sv-cheeza_inventory.lua` `RegisterUsableItem` errors.
3. Confirm no repeated `Access denied for command add_ace` appears from `rcore_prison`.
4. In game, test jail, unjail, prison tablet, canteen purchase, and inventory save/restore.

Files adjusted for Seoul:

- `modules/bridge/server/sv-bridge.lua`
- `modules/bridge/client/cl-bridge.lua`
- `modules/base/server/sv-ace.lua`
- `readme.md`

**Follow the installation guide in documentation link below, please!**

## **Documentation**
If you have any questions, please take a look into our rich documentation containing all features, settings and more!

**📚 Documentation https://documentation.rcore.cz/paid-resources/rcore_prison** <br/><br/>

If you still have any questions after reading documentation, feel free to reach out to us on our discord!

📧 https://discord.gg/F28PfsY

***

## **Prison break**

* The dispatch is invoked when players:

1. Prisoner is spotted by guard (being in view range of NPC) and its seen in action cutting hole trough wall.
2. When Guard spotted hole in wall, then dispatch is invoked


## **How to add inventory items and images?**
## **Where to cell doors are defined?**

- You can use our Deployer tool which will do all work for you - read more about it there: [Guide](https://documentation.rcore.cz/paid-resources/rcore_prison/guides/deployer)

## **How to install RCore Prison V2?** 
- If you are moving from V1 version of Prison, dont use any assets from older version and move over guide bellow.
- Read this simple guide https://documentation.rcore.cz/paid-resources/rcore_prison/installation


## Changing minigame for Prison Jobs

Path: modules\base\client\api\cl-jobs.lua

You can change minigame from ox_lib to use own & adjust the keys

## Changing minigame for Cigarette production

Path: modules\base\client\api\cl-minigames.lua

Guide: https://documentation.rcore.cz/paid-resources/rcore_prison/guides/package-cigar-minigame
