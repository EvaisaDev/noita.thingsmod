local module_utils = require "lib.module_utils.module_utils"
---@type Module
local M = {
	name = "Perks",
	description = "Adds perks.",
	authors = { "Conga Lyne", "Copi" },
}

function M.OnModInit()
	-- Custom Perk support injection
	ModLuaFileAppend(
		"data/scripts/perks/perk_list.lua",
		module_utils.modpath "scripts/perks/custom_perks.lua"
	)

	--Appending extra modifiers
	ModLuaFileAppend(
		"data/scripts/gun/gun_extra_modifiers.lua",
		module_utils.modpath "scripts/gun/gun_extra_populator.lua"
	)
	-- Inject bountiful hunter power-ups
	ModLuaFileAppend(
		"data/scripts/items/drop_money.lua",
		module_utils.modpath "scripts/drop_booster.lua"
	)
end

function M.OnPlayerFirstSpawned(player_entity)
	EntityAddComponent2(player_entity, "LuaComponent", {
		script_damage_about_to_be_received = "mods/noita.thingsmod/content/simple_perks/scripts/perks/take_damage.lua",
		execute_every_n_frame = -1,
		execute_times = -1,
		remove_after_executed = false,
	})
end

return M
