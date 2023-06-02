local config = require("sensai.config")
local util =  require("sensai.util")
local M = {}

-- model_name string
M.add_model = function(model_name)
	if not util.tbl_contains(config.supported_models, model_name) then
		return
	end
	-- model-processing
	config.installed_models[#config.installed_models+1] = model_name
end

-- model_name string
M.select_model = function(model_name)
	-- todo
end

-- model_name string
M.delete_model = function(model_name)
	-- todo
end

return M
