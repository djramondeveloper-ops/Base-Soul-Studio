-- HaridCore-render configuration

Config = {}

-- Lista de armas que NÃO podem ser usadas para render (nomes/hash)
-- Use nomes de armas GTA (ex.: WEAPON_PISTOL, WEAPON_KNIFE) ou hashes numéricos
Config.DisallowedWeapons = {
  `WEAPON_KNIFE`,
  `WEAPON_BAT`,
}

-- Se true, quando o alvo for um PLAYER ele precisa aceitar na UI; se false, força a rendição sem confirmar
Config.RequirePlayerAccept = true
