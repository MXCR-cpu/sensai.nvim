-- local api = vim.api
-- local cmd = vim.cmd
local fn = vim.fn
local log = vim.log
local util = require("sensai.util")
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
	if not fn.executable("python3") then
		vim.notify("sensai.nvim: python3 not found")
		return 0
	end
	if not fn.executable("poetry") then
		vim.notify("sensai.nvim: poetry not found")
		return 0
	end
	if not fn.executable("curl") then
		vim.notify("sensai.nvim: curl not found")
		return 0
	end
	return 1
end

-- M.setup_models_directory = function()
-- 	local models_directory_split = fn.split(Options.models_directory, "/")
-- 	if not fn.isdirectory(Options.models_directory) then
-- 		vim.notify(
-- 			"sensai.nvim: setup: models_directory is not a valid directory",
-- 			log.levels.ERROR,
-- 			{ title = "sensai.nvim" }
-- 		)
-- 		return
-- 	end
-- 	if fn.isdirectory(Options.models_directory) and
-- 	    models_directory_split[#models_directory_split] ~= "models" then
-- 		Options.models_directory = Options.models_directory .. "/models"
-- 	end
-- 	if not fn.isdirectory(Options.models_directory) then
-- 		fn.mkdir(Options.models_directory)
-- 	end
-- 	M.options = Options
-- end

M.setup_poetry = function()
	util.run_silent_cmd("!cd " .. defaults.models_directory)
	-- cmd("!cd " .. defaults.models_directory)
	-- if not vim.fn.exists(defaults.models_directory ) then 
	-- 	local parse_result = api.nvim_parse_cmd([[!poetry init]], {})
	-- 	api.nvim_cmd(parse_result, {})
	-- end
end

M.setup = function(opts)
	Options = vim.tbl_deep_extend("force", defaults, opts or {})
	if not M.check_python_connection() then
		return
	end
	-- M.setup_models_directory()
	M.setup_poetry()
end

return M
