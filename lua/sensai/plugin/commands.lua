local api = vim.api
local window = require("sensai.window")
local M = {
	setup = false,
	commands = {},
}

M.commands.sensai = function()
	print("commands: sensai")
	window.win_setup({})
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
