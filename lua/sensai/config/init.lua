local fn = vim.fn
local api = vim.api
local M = {}

M.sensai_version = "1.0.0"

local defaults = {}

M.setup = function(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {})
	if fn.argc(-1) == 0 then
	end
end

return M
