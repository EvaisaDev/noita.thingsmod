---@type Module
local M = {
	name = "Shitcode Example",
	description = "Adds shit code",
	authors = { "Username here", "Another username here" },
	OnModPreInit = function() end,
	OnModInit = function() end,
	OnModPostInit = function() end,
	OnPlayerSpawned = function(player_entity) end,
	OnPlayerDied = function(player_entity) end,
	OnWorldInitialized = function() end,
	OnWorldPreUpdate = function() end,
	OnWorldPostUpdate = function() end,
	OnBiomeConfigLoaded = function() end,
	OnMagicNumbersAndWorldSeedInitialized = function() end,
	OnPausedChanged = function(is_paused, is_inventory_pause) end,
	OnModSettingsChanged = function() end,
	OnPausePreUpdate = function() end,
}

return M
