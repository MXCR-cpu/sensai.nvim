local fn = vim.fn
local loop = vim.loop
local api = vim.api
local config = require("sensai.config")
local util = require("sensai.util")
local M = {}

M.cleared = false

M.selected_model = nil
M.models_list = {}
M.contextss_list = {}

local initialize_repo = function(section)
	local permissions = 438
	local directory_path = config.data_directory .. '/' .. section
	local list_path = config.data_directory .. '/' .. section .. '_list.json'
	if type(loop.fs_open(list_path, 'r', permissions)) == "nil" then
		local list_file = loop.fs_open(list_path, 'w', permissions)
		loop.fs_write(list_file, '{}')
		loop.fs_close(list_file)
		loop.fs_mkdir(directory_path, permissions)
	end
	local list_file = loop.fs_open(list_path, 'r', permissions)
	local list_file_contents = loop.fs_read(list_file, 4096)
	loop.fs_close(list_file)
	return list_file_contents
end

local update_list = function(section, lst)
	local permissions = 438
	local json_string = api.nvim_call_function('json_encode', {lst})
	local list_file = loop.fs_open(config.data_directory .. '/' .. section .. '_list.json', 'w', permissions)
	loop.fs_write(list_file, json_string)
	loop.fs_close(list_file)
end

M.setup = function()
	local permissions = 438
	config.data_directory = fn.stdpath('data') .. '/sensai'
	if config.setup() ~= 0 then
		api.nvim_create_autocmd({ 'VimEnter' }, {
			group = M.sensai_augroup,
			callback = function()
				config.check_python_connection()
			end,
		})
	else
		return
	end
	if loop.fs_scandir(config.data_directory) == nil then
		loop.fs_mkdir(config.data_directory, permissions)
	end
	M.models_list = api.nvim_call_function('json_decode', {initialize_repo('models')})
	M.contexts_list = api.nvim_call_function('json_decode', {initialize_repo('contexts')})

	M.sensai_augroup = api.nvim_create_augroup('Sensai', {
		clear = false
	})
	api.nvim_create_autocmd({ 'VimLeave' }, {
		group = M.sensai_augroup,
		callback = function(_)
			update_list('models', M.models_list)
			update_list('contexts', M.contexts_list)
			return true
		end
	})
end

-- model_name string
M.add_model = function(model_name)
	M.models_list[#M.models_list+1] = model_name
	-- todo
end

M.add_context = function()
	M.contexts_list[#M.contexts_list+1] = ""
end

M.prompt = function()
	local directory = vim.split(fn.expand('%:p'), "sensai.nvim")[1] .. "sensai.nvim"
	local result = util.run_cmd("poetry run python3 " .. directory .. "/lua/sensai/scripts/setup.py ")
	print(result)
end

-- -- model_name string
-- M.select_model = function(model_name)
-- 	-- todo
-- end

-- -- model_name string
-- M.delete_model = function(model_name)
-- 	-- todo
-- end

return M
