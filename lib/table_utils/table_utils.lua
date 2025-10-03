---@class table_utils
local M = {}

---@class PositionallyInsertable
---@field id_append string
---@field id_prepend string

---Insert all of `to_insert` into `insert_to` with respect to prepends / appends
---@param insert_to table
---@param to_insert PositionallyInsertable[]
function M.positional_insert(insert_to, to_insert)
	for _, inserting in ipairs(to_insert) do
		if inserting.id_append == nil and inserting.id_prepend == nil then
			table.insert(insert_to, inserting)
		else
			for current_index, test in ipairs(insert_to) do
				if test.id == inserting.id_prepend then
					table.insert(insert_to, current_index, inserting)
					break
				elseif test.id == inserting.id_append or current_index == #insert_to then
					table.insert(insert_to, current_index + 1, inserting)
					break
				end
			end
		end
	end
end

return M
