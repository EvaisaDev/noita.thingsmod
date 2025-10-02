local gui_utils = require "content.module_control.src.gui_utils"

---@class module_control.menu
local M = {}

---@param gui gui
---@param id fun(): integer
---@param internal_frame integer
function M.draw(gui, id, internal_frame)
	GuiZSet(gui, -100000)
	local x, y, w, h = 100, 100, 1000, 1000
	GuiImageNinePiece(gui, id(), x, y, w, h)
	gui_utils.block_region(gui, id, x, y, w, h)
end

return M
