local api = vim.api
local color = {}

color.scheme = {
	H1 = 'IncSearch',
	H2 = 'Bold',
	Normal = 'NormalFloat',
}

color.did_setup = false

color.add = function()
	for hl_group, link in pairs(color.scheme) do
		api.nvim_set_hl(0, "Sensai" .. hl_group, {
			link = link,
			default = true,
		})
	end
end

color.setup = function()
	if color.did_setup then
		return
	end
	color.add()
	api.nvim_create_autocmd("ColorScheme", {
		callback = function()
			color.add()
		end
	})
	color.did_setup = true
end

return M
