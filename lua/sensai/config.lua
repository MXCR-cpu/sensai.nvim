-- local api = vim.api
-- local cmd = vim.cmd
local fn = vim.fn
local util = require("sensai.util")
local M = {
	sensai_version = "1.0.0",
	supported_models = {},
	installed_models = {},
	options = {},
	data_directory = "",
}
M.check_python_connection = function()
	if M.ran == 1 then
		return
	end
	if not fn.executable("curl") then
		vim.notify("sensai.nvim: curl not found")
		return 0
	end
	if not fn.executable("python3") then
		vim.notify("sensai.nvim: python3 not found")
		return 0
	end
	if not fn.executable("poetry") then
		vim.notify("sensai.nvim: poetry not found")
		return 0
	end
	local jobs = {
		"poetry init",
		"poetry run pip install transformers",
		"poetry run pip install einops",
		"poetry run pip install sentencepiece",
		"poetry run pip install torch",
	}
	local job_calls = {}
	for _, job in ipairs(jobs) do
		job_calls[#job_calls+1] = fn.jobstart(job, {
			on_stdout = function(_, _, _) end,
			on_stderr = function(_, _, _) end,
			-- @params job_id, exit_code, exit_type
			on_exit = function(_, _, _) end,
		})
	end
	local exit_codes = fn.jobwait(job_calls)
	for index, exit_code in ipairs(exit_codes) do
		-- if exit_code ~= 0 then
		-- 	print('executing: ' .. jobs[index] .. '; job_call: ' .. job_calls[index] .. '; exit_code: ' .. exit_code)
		-- end
		print('executing: ' .. jobs[index] .. '; job_call: ' .. job_calls[index] .. '; exit_code: ' .. exit_code)
	end
	M.ran = 1
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


M.setup = function(_)
	M.ran = 0
end

return M
