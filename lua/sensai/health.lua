local fn = vim.fn
local M = {}

local commands = { "git", "rg", { "fd", "fdfind" } }
local start = vim.health.start or vim.health.report_start
local ok = vim.health.ok or vim.health.report_ok
local warn = vim.health.warn or vim.health.report_warn
local error = vim.health.error or vim.health.report_error

function M.check()
	start("Sensai")
	if vim.fn.has("nvim-0.8.0") == 1 then
		ok("Using Neovim >= 0.8.0")
	else
		error("Neovim >= 0.8.0 is required")
	end

	for _, cmd in ipairs(commands) do
		local name = type(cmd) == "string" and cmd or vim.inspect(cmd)
		local new_cmd = type(cmd) == "string" and { cmd } or cmd
		---@cast new_cmd string[]
		local found = false

		for _, c in ipairs(new_cmd) do
			if fn.executable(c) == 1 then
				name = c
				found = true
			end
		end

		if found then
			ok(("`%s` is installed"):format(name))
		else
			warn(("`%s` is not installed"):format(name))
		end
	end
end

return M
