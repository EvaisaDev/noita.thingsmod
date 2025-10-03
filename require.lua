---@diagnostic disable: lowercase-global
---To use, make sure that your context does
---```lua
---dofile("mods/noita.thingsmod/require.lua")
---```
---at the start.
function require(modname)
	return dofile_once(("mods/noita.thingsmod/%s.lua"):format(modname:gsub("%.", "/")))
end
