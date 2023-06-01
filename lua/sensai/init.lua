local M = {}

M.setup = function(opts)
	-- print "starting sensai..."
	require("sensai.config").setup(opts)
	require("sensai.plugin").setup_commands()
end

return M
