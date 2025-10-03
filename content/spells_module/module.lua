local module_utils = require "lib.module_utils.module_utils"

---@type Module
local M = {
	name = "Spells Module",
	description = "Adds new spells to the game.",
	authors = { "Conga Lyne", "Nathan" },
}

function M.OnModInit()
	--Ensure this flag is never enabled
	RemoveFlagPersistent("this_should_never_spawn")

	ModLuaFileAppend(
		"data/scripts/gun/gun_actions.lua",
		module_utils.modpath "scripts/gun/actions.lua"
	)
	ModLuaFileAppend("data/scripts/gun/gun.lua", module_utils.modpath "scripts/gun/gun.lua")
end

return M
