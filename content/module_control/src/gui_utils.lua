local gui_options = require "lib.gui.gui_options"

---@class module_control.gui_utils
local M = {}

---@param gui gui
---@param id fun(): integer
---@param x number
---@param y number
---@param w number
---@param h number
function M.block_region(gui, id, x, y, w, h)
	local shared_id = id()

	GuiAnimateBegin(gui)
	GuiAnimateAlphaFadeIn(gui, shared_id, 0, 0, true)
	GuiOptionsAddForNextWidget(gui, gui_options.AlwaysClickable)
	GuiBeginScrollContainer(gui, shared_id, x, y, w, h, false, 0, 0)
	GuiAnimateEnd(gui)
	GuiEndScrollContainer(gui)
	GuiIdPop(gui)
end

return M
