---@class module_control.button
local M = {}
local gui_options = require "lib.gui.gui_options"
local vivid = require "lib.vivid.vivid"
local hovered_last = false
local menu_open = false

local function hue_to_interval(deg)
	return (deg / 360) % 1
end

---@param gui gui
---@param id fun(): integer
---@param internal_frame integer
---@return boolean menu_open
function M.draw(gui, id, internal_frame)
	local message = "Every Things Settings"
	local x = 10
	local y = 10
	local shift = x
	local wiggles = 3

	local hue = internal_frame
	local tallest_char = 0
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
	GuiOptionsAdd(gui, gui_options.AlwaysClickable)
	GuiOptionsAdd(gui, gui_options.ForceFocusable)
	GuiImageNinePiece(
		gui,
		id(),
		box_x,
		box_y,
		box_w,
		box_h,
		1,
		"data/debug/empty.png",
		"data/debug/empty.png"
	)
	local clicked, _, hovered = GuiGetPreviousWidgetInfo(gui)
	GuiOptionsClear(gui)
	hovered_last = hovered
	if clicked then menu_open = not menu_open end

	return menu_open
end

return M
