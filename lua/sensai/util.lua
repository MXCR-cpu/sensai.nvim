local api = vim.api
local M = {}

-- arr array<T>
-- element T
M.tbl_contains = function(arr, element)
	for _, value in ipairs(arr) do
		if value == element then
			return true
		end
	end
	return false
end

-- cmd string
M.run_silent_cmd = function(cmd)
	local parse_result = api.nvim_parse_cmd(cmd, {})
	parse_result.mods.silent = true
	api.nvim_cmd(parse_result, {})
end

return M
