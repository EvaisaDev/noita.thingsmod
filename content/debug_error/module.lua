---@type Module
local M = {
	name = "Debug Error",
	description = "Throws an error during init, for testing if the error handling systems are working",
	authors = "Nathan",
}

function M.OnThingsCalled(_)
	error("Very bad!")
end

return M
