---@class ModuleUtils
local M = {}

---The current module
---@type string
M.current_module = "example"

---Converts a filepath like `scripts/whatever.lua` to `mods/noita.thingsmod/content/MODULE_ID/scripts/whatever.lua`
---
---To use, make sure that your context sets `module_utils.current_module` if its not an init context
function M.modpath(relative_path)
	return ("mods/noita.thingsmod/content/%s/%s"):format(M.current_module, relative_path)
end

return M
