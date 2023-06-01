local fn = vim.fn
local log = vim.log
local cmd = vim.cmd
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

M.check_python_connection = function()
	local check_python = cmd[[!python --version]]
	local check_poetry = cmd[[!poetry --version]]
	print(check_python)
	print(check_poetry)
end

M.setup_models_directory = function()
	local models_directory_split = fn.split(options.models_directory, "/")
	if not fn.isdirectory(options.models_directory) then
		vim.notify(
			"sensai.nvim: setup: models_directory is not a valid directory",
			log.levels.ERROR,
			{ title = "sensai.nvim" }
		)
		return
	end
	if fn.isdirectory(options.models_directory) and
	    models_directory_split[#models_directory_split] ~= "models" then
		options.models_directory = options.models_directory .. "/models"
	end
	if not fn.isdirectory(options.models_directory) then
		fn.mkdir(options.models_directory)
	end
	M.options = options
end

M.check_installed_models = function()
end

M.setup = function(opts)
	options = vim.tbl_deep_extend("force", defaults, opts or {})
	M.check_python_connection()
	M.setup_models_directory()
	M.check_installed_models()
end

return M
