local fn = vim.fn
local api = vim.api

local create_directory = function(directory)
end

local M = {
	sensai_version = "1.0.0"
}

-- defaults string?
local defaults = {
	directory = nil,
}

M.setup = function(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {})
	if fn.argc(-1) == 0 then
	end
end

return M
