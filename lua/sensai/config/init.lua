local fn = vim.fn
local api = vim.api
local os = require("os")
local M = {
	sensai_version = "1.0.0",
	supported_models = {},
	installed_models = {},
	options = {},
}
local defaults = {
	models_directory = os.getenv("HOME") .. "/.config/nvim/models",
}

M.setup = function(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {})
	local models_directory_split = vim.fn.split(options.models_directory, "/")
	if fn.isdirectory(options.models_directory) and
		models_directory_split[#models_directory_split] ~= "models" then
		options.models_directory = options.models_directory .. "/models"
	end
	if not fn.isdirectory(options.models_directory) then
		fn.mkdir(options.models_directory)
	end
	M.options = options
	print(vim.inspect(M.options))
end

return M
