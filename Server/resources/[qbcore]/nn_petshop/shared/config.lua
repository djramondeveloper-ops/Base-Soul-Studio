--[[
  nn_petshop — shared/config.lua reference
  ----------------------------------------------------------------
  ShopCoords              vector4(x,y,z,heading) — shop world position; feeds PetShopTarget if coords not set elsewhere.
  ShopRadius              Circle zone radius (meters) for the shop target.
  PetShopTarget           Target box zone via interact/ox_target adapter to open the purchase UI.
    · enabled             If false, client skips registering the shop zone (no eye at shop).
    · zoneName            Internal zone id (must be unique on the server).
    · coords              Box center (vector3/vector4; vector4.w = box heading).
    · radius              Half-width of the square footprint (box side length = radius × 2).
    · distance            How close the player must be for the target option to appear.
    · label               Text shown on the target option.
    · icon                Font Awesome class for the target icon.
  SpawnDistanceInFront    Meters in front of the player a new pet is created when buying/spawning.

  SpawnUiCommand          Chat command that requests owned pets from server and opens spawn UI.
  SpawnUiDefaultKey       Default FiveM keyboard binding for that command (rebindable in GTA settings).
  ControlUiCommand        Chat command to open the dog control bar (attack, move, follow, sit, etc.).
  ControlUiDefaultKey     Default keybind for +ControlUiCommand (see client RegisterKeyMapping).

  Dogs[]                  Sell/spawn catalog for dogs. First 6 entries = main UI cards.
    · id                  Unique string stored in DB (purchase/spawn id).
    · model               GTA ped model name (streaming hash).
    · name                Display name in UI.
    · price               Cash cost in shop.
    · icon                Emoji/string for UI (cosmetic).
  Cats[]                  Same as dogs but usually one model + texture variants.
    · texture             Ped component texture index for a_c_cat_01 (0/1/2 = grey/black/ginger).

  Clothing[]              Accessories sold in shop (id must match a key in ClothingProps, except id 'none').
    · id, name, price, icon
  ClothingProps[id]       Visual prop attached to spawned dog when accessory is equipped.
    · model               World prop model name or hash.
    · bone                Ped bone index the prop attaches to (e.g. head).
    · offset / rotation   Default attachment in pet local space.
    · byModel             Optional overrides keyed by pet model name (e.g. a_c_pug) for smaller dogs.

  Messages                Client notification strings (opened, purchased, notEnoughMoney, error).

  SpawnCooldownAfterDeathSeconds   After a dog dies, that dog id cannot be spawned again until this many seconds pass.
  DeathAnimationDurationSeconds    Seconds to wait (death anim) before the corpse is deleted.

  Obedience               Dog-only control UI stat; affects whether commands work.
    · startValue          Obedience when dog spawns (0–100).
    · minToObey           Below this (and at 0) the dog ignores attack/move/follow/sit/bark.
    · decayPerSecond      Subtracted from obedience every second while dog is alive.
    · treatBoost          Legacy single-item boost if you use treatItem (per-treat boosts live in Config.Treats).
    · treatItem           If set, third-eye “give treat” may require this item; set nil to disable.
  Thirst / Hunger         0–100 stats; decay per second; if either hits 0 the dog dies (dogs only).
  Treats[key]             Entries for /treatshop and cash purchase; key is internal id (e.g. small, big).
    · name                Label in treat shop UI.
    · item                Inventory item name (must exist in your inventory; bridge handles framework).
    · price               Cash cost from treat shop.
    · obedienceBoost      Added to obedience when treat is used (capped at 100).
    · hunger / thirst     Added to those stats when treat is used (capped at 100).
]]
Config = {}

-- Shop location (third-eye to open UI)
Config.ShopCoords = vector4(-1821.82,-1143.5,13.75,195.6)
Config.ShopRadius = 2.0

-- Third-eye target to open nn_petshop UI (interact first)
Config.PetShopTarget = {
    enabled = true,              -- false = do not register shop circle zone
    zoneName = 'petshop_main',   -- unique zone name for target resource
    coords = Config.ShopCoords,  -- vector3/vector4 center of circle
    radius = Config.ShopRadius or 2.0,
    distance = 2.5,              -- max distance to show target option
    label = 'Abrir Petshop',     -- option label in target menu
    icon = 'fas fa-paw',         -- Font Awesome icon class
}

-- Third-eye target to open treat shop UI (Community Bridge target)
Config.TreatShopTarget = {
    enabled = true,
    zoneName = 'petshop_treats',
    coords = vector3(-1823.07,-1133.07,14.12),
    radius = 3.0,
    distance = 3.0,
    label = 'Abrir Loja de Petiscos',
    icon = 'fas fa-cookie-bite',
}

-- When buying a pet, spawn it this many units in front of the player
Config.SpawnDistanceInFront = 2.5

-- Spawn UI access (owned pets UI): command + default keybind
Config.SpawnUiCommand = 'dogspawn'
Config.SpawnUiDefaultKey = 'o'

-- Pet control bar (when a dog is spawned): command + default keybind (restart resource after changes)
Config.ControlUiCommand = 'controlldog'
Config.ControlUiDefaultKey = 'n'

-- Notifications toggle (client-side)
-- false = disable all nn_petshop notifications
Config.NotificationsEnabled = true

-- Shortcut toggles (commands / keybinds)
Config.Shortcuts = {
    petshopCommand = true,       -- /petshop (fallback se non hai ox_target)
    spawnCommand = true,         -- /dogspawn or custom SpawnUiCommand
    spawnKeybind = true,        -- keybind for SpawnUiCommand (default O)
    spawnAliasDogspawn = true,  -- keep /dogspawn as alias when SpawnUiCommand is custom
    treatshopCommand = true,     -- /treatshop
    controlCommand = true,      -- /controlldog or custom ControlUiCommand
    controlKeybind = true,      -- keybind for ControlUiCommand (default N)
    controlAliasDefault = true, -- keep /controlldog as alias when ControlUiCommand is custom
}

-- Dogs for sale: first 6 are shown in UI (card 1–6). Model = GTA ped name; some may need DLC/addon.
-- Order: 1 Golden Retriever, 2 German Shepherd, 3 Husky, 4 Bulldog, 5 Poodle, 6 Pug
Config.Dogs = {
    { id = 'retriever',  model = 'a_c_retriever',  name = 'Golden Retriever',   price = 2700, icon = '🦮' },
    { id = 'shepherd',   model = 'a_c_shepherd',   name = 'Pastor Alemao',      price = 2500, icon = '🐕' },
    { id = 'husky',      model = 'a_c_husky',      name = 'Husky',             price = 2800, icon = '🐺' },
    { id = 'bulldog',    model = 'a_c_pug',        name = 'Bulldog',            price = 2200, icon = '🐶' }, -- GTA has no bulldog; using pug model as placeholder
    { id = 'poodle',     model = 'a_c_poodle',     name = 'Poodle',             price = 2400, icon = '🐩' },
    { id = 'pug',        model = 'a_c_pug',        name = 'Pug',                price = 1900, icon = '🐶' },
    { id = 'rottweiler', model = 'a_c_rottweiler', name = 'Rottweiler',         price = 3200, icon = '🦮' },
    { id = 'chop',       model = 'a_c_chop',       name = 'Chop',               price = 1800, icon = '🐶' },
    { id = 'westy',      model = 'a_c_westy',      name = 'West Highland Terrier', price = 1600, icon = '🐕' },
}

Config.Cats = {
    -- Map textures to what you actually see in-game:
    -- texture 0 -> Grey, texture 1 -> Black, texture 2 -> Ginger
    { id = 'cat_grey',   model = 'a_c_cat_01', name = 'Gato Cinza',     price = 1300, icon = '🐾', texture = 0 },
    { id = 'cat_black',  model = 'a_c_cat_01', name = 'Gato Preto',     price = 1200, icon = '🐈', texture = 1 },
    { id = 'cat_ginger', model = 'a_c_cat_01', name = 'Gato Laranja',   price = 1300, icon = '😺', texture = 2 },
}

-- Clothing / accessories. Add more as you have offset/rotation for each.
Config.Clothing = {
    { id = 'white_cap',     name = 'Bone Branco',       price = 250, icon = '🧢' },
    { id = 'adventurer_hat', name = 'Chapeu Aventureiro', price = 280, icon = '🎩' },
    { id = 'cowboy_hat',    name = 'Chapeu Cowboy',      price = 300, icon = '🤠' },
    { id = 'builder_hat',   name = 'Capacete',           price = 220, icon = '⛑️' },
    { id = 'captain_hat',   name = 'Chapeu de Capitao',  price = 290, icon = '⛵' },
    { id = 'safety_glasses', name = 'Oculos de Seguranca', price = 180, icon = '🕶️' },
    { id = 'green_glasses',  name = 'Oculos Verdes',     price = 180, icon = '🕶️' },
    { id = 'none',          name = 'Sem acessorio',      price = 0,   icon = '✨' },
}

-- Props attached to pet. Use 'offset'/'rotation' as default; optional 'byModel' for per-breed.
Config.ClothingProps = {
    white_cap = {
        model = 'prop_cap_01',
        bone = 31086,
        -- Big dogs (Retriever, Shepherd, Husky)
        offset = vector3(0.03, 0.0, 0.09),
        rotation = vector3(-25.0, 0.0, 90.0),
        -- Small dogs (Bulldog, Poodle, Pug)
        byModel = {
            a_c_pug = { offset = vector3(0.030, 0.070, -0.010), rotation = vector3(-5.0, 90.0, 85.0) },
            a_c_poodle = { offset = vector3(0.030, 0.070, -0.010), rotation = vector3(-5.0, 90.0, 85.0) },
        },
    },
    adventurer_hat = {
        model = 1475609539,
        bone = 31086,
        offset = vector3(0.03, 0.0, 0.09),
        rotation = vector3(-25.0, 0.0, 90.0),
        byModel = {
            a_c_pug = { offset = vector3(0.030, 0.070, -0.010), rotation = vector3(-5.0, 90.0, 85.0) },
            a_c_poodle = { offset = vector3(0.030, 0.070, -0.010), rotation = vector3(-5.0, 90.0, 85.0) },
        },
    },
    cowboy_hat = {
        model = 935379997,
        bone = 31086,
        offset = vector3(0.03, 0.0, 0.09),
        rotation = vector3(-25.0, 0.0, 90.0),
        byModel = {
            a_c_retriever = { offset = vector3(0.030, 0.010, 0.040), rotation = vector3(-25.0, 0.0, 90.0) },
            a_c_pug = { offset = vector3(0.030, 0.020, -0.000), rotation = vector3(-5.0, 90.0, 85.0) },
            a_c_poodle = { offset = vector3(0.030, 0.020, -0.000), rotation = vector3(-5.0, 90.0, 85.0) },
        },
    },
    builder_hat = {
        model = 3558579946,
        bone = 31086,
        offset = vector3(0.03, 0.0, 0.09),
        rotation = vector3(-25.0, 0.0, 90.0),
        byModel = {
            a_c_pug = { offset = vector3(0.030, 0.070, -0.010), rotation = vector3(-5.0, 90.0, 85.0) },
            a_c_poodle = { offset = vector3(0.030, 0.070, -0.010), rotation = vector3(-5.0, 90.0, 85.0) },
        },
    },
    captain_hat = {
        model = 3546410618,
        bone = 31086,
        offset = vector3(0.03, 0.0, 0.09),
        rotation = vector3(-25.0, 0.0, 90.0),
        byModel = {
            a_c_retriever = { offset = vector3(0.030, 0.010, 0.040), rotation = vector3(-25.0, 0.0, 90.0) },
            a_c_pug = { offset = vector3(0.030, 0.020, -0.000), rotation = vector3(-5.0, 90.0, 85.0) },
            a_c_poodle = { offset = vector3(0.030, 0.020, -0.000), rotation = vector3(-5.0, 90.0, 85.0) },
        },
    },
    safety_glasses = {
        model = 2283106578,
        bone = 31086,
        offset = vector3(0.03, 0.05, 0.02),
        rotation = vector3(0.0, 90.0, 0.0),
        byModel = {
            a_c_retriever = { offset = vector3(0.100, 0.000, 0.030), rotation = vector3(-30.0, 360.0, 95.0) },
            a_c_shepherd = { offset = vector3(0.100, 0.000, 0.030), rotation = vector3(-30.0, 360.0, 95.0) },
            a_c_husky = { offset = vector3(0.100, 0.000, 0.030), rotation = vector3(-30.0, 360.0, 95.0) },
            a_c_pug = { offset = vector3(0.040, 0.010, -0.000), rotation = vector3(360.0, 90.0, 90.0) },
            a_c_poodle = { offset = vector3(0.040, 0.040, -0.000), rotation = vector3(360.0, 90.0, 90.0) },
        },
    },
    green_glasses = {
        model = 2280866551,
        bone = 31086,
        offset = vector3(0.03, 0.05, 0.02),
        rotation = vector3(0.0, 90.0, 0.0),
        byModel = {
            a_c_retriever = { offset = vector3(0.080, -0.010, -0.050), rotation = vector3(-30.0, 360.0, 95.0) },
            a_c_shepherd = { offset = vector3(0.080, -0.010, -0.050), rotation = vector3(-30.0, 360.0, 95.0) },
            a_c_husky = { offset = vector3(0.080, -0.010, -0.050), rotation = vector3(-30.0, 360.0, 95.0) },
            a_c_pug = { offset = vector3(-0.030, -0.040, -0.000), rotation = vector3(360.0, 90.0, 90.0) },
            a_c_poodle = { offset = vector3(-0.010, -0.010, -0.000), rotation = vector3(360.0, 90.0, 90.0) },
        },
    },
}

-- Client/server notification text (purchase UI, errors, etc.)
Config.Messages = {
    opened = 'Bem-vindo ao Petshop!',
    purchased = 'Voce comprou um pet.',
    notEnoughMoney = 'Voce nao tem dinheiro suficiente.',
    error = 'Algo deu errado.',
}

-- Cooldown (seconds) before the same dog id can be spawned again after it died
Config.SpawnCooldownAfterDeathSeconds = 30
-- Seconds to wait during death before deleting the ped (animation time)
Config.DeathAnimationDurationSeconds = 4

Config.Obedience = {
    startValue = 100,           -- Obedience when dog is first spawned (0–100)
    minToObey = 20,             -- Commands ignored if obedience is below this (or at 0)
    decayPerSecond = 1,      -- Obedience lost per second while dog is alive
    treatBoost = 25,            -- Legacy boost if using treatItem path; Config.Treats overrides per item
    treatItem = 'dog_treat',    -- Item required for third-eye “give treat”; nil = no item check
}

-- Thirst / hunger: control UI bars; at 0 the dog dies
Config.Thirst = {
    startValue = 100,
    decayPerSecond = .01,
}
Config.Hunger = {
    startValue = 100,
    decayPerSecond = .01,
}

-- Treat shop + inventory items: `item` must match Seoul vRP/Creative and ox_inventory item names
Config.Treats = {
    small        = { name = 'Petisco Pequeno', item = 'small_treat',   price = 15,  obedienceBoost = 15,  hunger = 8,   thirst = 5 },
    big          = { name = 'Petisco Grande',  item = 'big_treat',     price = 35,  obedienceBoost = 100, hunger = 25,  thirst = 15 },
    tastymeat    = { name = 'Carne Saborosa',  item = 'tastymeat',     price = 25,  obedienceBoost = 30,  hunger = 20,  thirst = 0 },
    mediumcookie = { name = 'Biscoito Medio',  item = 'medium_cookie', price = 20,  obedienceBoost = 22,  hunger = 12,  thirst = 3 },
    bigcookie    = { name = 'Biscoito Grande', item = 'big_cookie',    price = 28,  obedienceBoost = 38,  hunger = 18,  thirst = 4 },
    fruitslice   = { name = 'Fatia de Fruta',  item = 'fruit_slice',   price = 18,  obedienceBoost = 18,  hunger = 10,  thirst = 22 },
    pupcup       = { name = 'Pup Cup',        item = 'pupcup',        price = 32,  obedienceBoost = 50,  hunger = 5,   thirst = 28 },
    yogurt       = { name = 'Iogurte',        item = 'yogurt',        price = 22,  obedienceBoost = 25,  hunger = 8,   thirst = 20 },
}
