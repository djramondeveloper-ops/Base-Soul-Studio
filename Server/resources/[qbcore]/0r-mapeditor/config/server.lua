-- Seoul Base - server configuration for 0r-mapeditor
Config = Config or {}

-- Fallback ACE used only when AdminControl is not running.
-- In Seoul, AdminControl > Prop Editor is the normal entry point and its own
-- permission system is authoritative.
Config.permission = 'command.mapeditor'

-- Maximum number of placed objects per saved/published map.
Config.maxObjects = 5000
Config.maxHiddenProps = 2500
Config.maxLights = 1000

-- Existing directory inside this resource used by the Publish button.
Config.exportPath = 'exports'

Config.logsEnabled = true
