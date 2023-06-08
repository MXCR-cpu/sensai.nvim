local api = vim.api
local window = require("sensai.window")
local color = require("sensai.colors")
local text = require("sensai.text")
local config = require("sensai.config")
local operations = require("sensai.plugin.operations")
local M = {
	setup = false,
	commands = {},
}

M.commands.sensai = function()
	local exit_strings = { "Placeholder text" }
	local co = coroutine.create(function()
		print("Entered coroutine")
		_, exit_strings = config.check_python_connection()
	end)
	local gap = 3
	if window.setup({}) == 0 then
		window.layouts({
			{},
			{
				width = 45,
				height = 6,
				row = 5,
				col = 5,
			},
			{
				width = 75,
				height = 10,
				row = 15,
				col = 5,
				title = "Context (c)"
			},
			{
				width = 75,
				height = 10,
				row = 25 + gap,
				col = 5,
				title = "Models (m)"
			},
			{
				width = 75,
				height = 10,
				row = 35 + (2 * gap),
				col = 5,
				title = "Info (i)"
			},
		})
	end
	window.set_layers({
		text.tree,
		text.title,
		{ "Loading... " },
		{ "Loading... " },
		{ "Loading... " },
	},
	{
		0,
		3,
		3,
		3,
		3,
	})
	color.setup()
	vim.schedule(function()
		local status = coroutine.resume(co)
		print(status)
		if type(status) == "nil" then
			print("Error ")
		end
		window.set_layers({
			text.tree,
			text.title,
			operations.contexts_list,
			operations.models_list,
			exit_strings,
		},
		{
			0,
			3,
			3,
			3,
			3,
		})
	end)
end

M.commands.sensai_prompt = function()
	local left_position = api.nvim_buf_get_mark(0, "<")
	local right_position = api.nvim_buf_get_mark(0, ">")
	local lines = api.nvim_buf_get_lines(
		0,
		left_position[1] - 1,
		right_position[1],
		true)
	local exit_strings = operations.prompt()
	print('exit_strings: ' .. vim.inspect(exit_strings))
end

return M
