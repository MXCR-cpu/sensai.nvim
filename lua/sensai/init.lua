local M = {}

M.setup = function(opts)
	-- print "starting sensai..."
	require("sensai.config").setup(opts)
end

return M
