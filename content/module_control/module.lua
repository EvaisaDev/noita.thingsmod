local button = require "content.module_control.src.button"
local credible_settings = require "lib.credible_settings.credible_settings"
local menu = require "content.module_control.src.menu"
local module_utils = require "lib.module_utils.module_utils"
local gui
local internal_frame = 0
local paused = false

local _id = 2
local function id()
	_id = _id + 1
	return _id
end

---@type Module
local M = {
	name = "Module Control",
	description = "Controls enabling and disabling noita.thingsmod modules",
	authors = { "Nathan" },
	OnPausePreUpdate = function()
		gui = gui or GuiCreate()
		internal_frame = internal_frame + 1
		GuiStartFrame(gui)
		_id = 2

		local menu_open = button.draw(gui, id, internal_frame)
		if menu_open then menu.draw(gui, id, internal_frame) end
	end,
	OnPausedChanged = function(is_paused, is_inventory_pause)
		paused = is_paused
	end,
	OnWorldPreUpdate = function()
		if not paused then GuiStartFrame(gui) end
	end,
	OnThingsCalled = function()
		credible_settings.install_hooks()
		credible_settings.add_menu("Every Things", module_utils.modpath("src/settings.lua"))
	end,
}

return M
