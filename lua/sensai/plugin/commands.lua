local api = vim.api
local window = require("sensai.window")
local color = require("sensai.colors")
local text = require("sensai.text")
local M = {
	setup = false,
	commands = {},
}

M.commands.sensai = function()
	-- print("starting sensai command")
	-- local tree = text.tree
	window.setup({})
	window.layouts({
		{},
		{
			width = 45,
			height = 6,
			row = 20,
			col = 30,
		},
	})
	color.setup()
	window.set_layers({
		text.tree,
		text.title,
	})
	-- print("endding sensai command")
end

M.commands.sensai_prompt = function()
	print("commands: sensai_prompt")
	local left_position = api.nvim_buf_get_mark(0, "<")
	local right_position = api.nvim_buf_get_mark(0, ">")
	local lines = api.nvim_buf_get_lines(
		0,
		left_position[1] - 1,
		right_position[1],
		true
	)
	print(vim.inspect(lines))
end

return M
