local gui_options = require "lib.gui.gui_options"
local vivid = require "lib.vivid.vivid"
local gui
local internal_frame = 0
local hovered_last = false

local _id = 2
local function id()
	_id = _id + 1
	return _id
end

local function hue_to_interval(deg)
	return (deg / 360) % 1
end

---@type Module
local M = {
	name = "Module Control",
	description = "Controls enabling and disabling noita.thingsmod modules",
	authors = "Nathan",
	OnPausePreUpdate = function()
		gui = gui or GuiCreate()
		GuiStartFrame(gui)

		local message = "Every Things Settings"
		local x = 10
		local y = 10
		local shift = x
		local wiggles = 3

		local hue = internal_frame
		local tallest_char = 0
		internal_frame = internal_frame + 1
		for char in message:gmatch(".") do
			local width, height = GuiGetTextDimensions(gui, char)
			tallest_char = math.max(tallest_char, height)
			hue = hue + width
			local r, g, b = vivid.HSVtoRGB(hue_to_interval(hue), hovered_last and 1 or 0.2, 1)
			GuiColorSetForNextWidget(gui, r, g, b, 1)
			local dy = wiggles * math.sin((width / 2 + shift + internal_frame) / 20)
			GuiText(gui, shift, y + dy, char)
			shift = shift + width
		end

		local box_x, box_y, box_w, box_h = x, y - wiggles, shift, tallest_char + 2 * wiggles
		local cutout_id = id()
		GuiImageNinePiece(
			gui,
			id(),
			box_x,
			box_x,
			box_w,
			box_h,
			1,
			"data/debug/empty.png",
			"data/debug/empty.png"
		)
		local clicked, _, hovered = GuiGetPreviousWidgetInfo(gui)
		hovered_last = hovered
		if clicked then print("click") end
	end,
}

return M
