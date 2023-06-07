local api = vim.api
local window = require("sensai.window")
local color = require("sensai.colors")
local text = require("sensai.text")
local operations = require("sensai.plugin.operations")
local M = {
	setup = false,
	commands = {},
}

M.commands.sensai = function()
	window.setup({})
	window.layouts({
		{},
		{
			width = 45,
			height = 6,
			row = 5,
			col = 5,
		},
		{
			width = 45,
			height = math.max(#operations.contexts_list, 10),
			row = 15,
			col = 5,
			title = "Context (c)"
		},
		{
			width = 45,
			height = math.max(#operations.models_list, 10),
			row = 30,
			col = 5,
			title = "Models (m)"
		},
	})
	window.set_layers({
		text.tree,
		text.title,
		operations.contexts_list,
		operations.models_list,
	},
	{
		2,
		3,
		3,
		3,
	})
	color.setup()
end

M.commands.sensai_prompt = function()
	-- print("commands: sensai_prompt")
	local left_position = api.nvim_buf_get_mark(0, "<")
	local right_position = api.nvim_buf_get_mark(0, ">")
	local lines = api.nvim_buf_get_lines(
		0,
		left_position[1] - 1,
		right_position[1],
		true)
	-- print(vim.inspect(lines))
	operations.prompt()
end

return M
