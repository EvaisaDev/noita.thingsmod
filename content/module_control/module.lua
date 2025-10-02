local button = require "content.module_control.src.button"
local menu = require "content.module_control.src.menu"
local gui
local internal_frame = 0

local _id = 2
local function id()
	_id = _id + 1
	return _id
end

---@type Module
local M = {
	name = "Module Control",
	description = "Controls enabling and disabling noita.thingsmod modules",
	authors = "Nathan",
	OnPausePreUpdate = function()
		gui = gui or GuiCreate()
		internal_frame = internal_frame + 1
		GuiStartFrame(gui)
		_id = 2

		local menu_open = button.draw(gui, id, internal_frame)
		if menu_open then menu.draw(gui, id, internal_frame) end
	end,
}

return M
