local M = {}

M.setup = function(opts)
	require("sensai.config").setup(opts)
	require("sensai.plugin").setup_commands()
end

return M
