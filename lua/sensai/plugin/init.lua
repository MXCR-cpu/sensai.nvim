-- local config = require("sensai.config")
local commands = require("sensai.plugin.commands").commands
local operations = require("sensai.plugin.operations")
local api = vim.api
local M = {}

M.setup_commands = function()
	if M.setup then return end
	api.nvim_create_user_command("Sensai", commands.sensai, {})
	api.nvim_create_user_command("SensaiPrompt", commands.sensai_prompt, {range = true})
	operations.setup()
	M.setup = true
end

return M
