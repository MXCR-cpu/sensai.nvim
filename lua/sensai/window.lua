local api = vim.api
local o = vim.o
local bit = require("bit")
local win = {}

win.ran = 0

win.setup = function(opts)
	if win.ran == 1 then
		return 1
	end
	win.opts = vim.tbl_deep_extend("force", {
		style = "minimal",
		border = "single",
	}, opts or {})
	win.default_opts = {
		relative = "editor",
		style = win.opts.style ~= "" and win.opts.style or nil,
		border = win.opts.border,
		zindex = win.opts.zindex,
		noautocmd = true,
		title = win.opts.title,
		title_pos = win.opts.title and win.opts.title_pos or nil,
		row = 3,
		col = 3,
		width = 50,
		height = 50,
		zindex = 100,
	}
	win.display_opts = {}
	M.ran = 1
	return 0
end

win.layout = function(index, dimensions)
	if index ~= 1 then
		dimensions.row = win.display_opts[1].row + dimensions.row
		dimensions.col = win.display_opts[1].col + dimensions.col
	end
	if next(dimensions) ~= nil then
		dimensions.zindex = 100 + index
		win.display_opts[#win.display_opts + 1] = vim.tbl_extend(
			"force",
			win.default_opts,
			dimensions)
		return
	end
	-- range = [0, 1/2)
	local horizontal_gap = 1 / 8
	local vertical_gap = 1 / 8
	win.display_opts[#win.display_opts + 1] = vim.tbl_extend(
		"force",
		win.default_opts,
		{
			width = math.floor(o.columns * (1 - (2 * horizontal_gap))),
			height = math.floor(o.lines * (1 - (2 * vertical_gap))),
			row = math.floor(o.lines * vertical_gap),
			col = math.floor(o.columns * horizontal_gap),
			zindex = 100 + index,
		})
end

win.layouts = function(dimensions_array)
	for index, dimensions in ipairs(dimensions_array) do
		win.layout(index, dimensions)
	end
	win.mount()
	win.set_keymaps()
end

win.mount = function()
	if type(win.bufs) == "nil" then
		win.bufs = {}
		for _, _ in ipairs(win.display_opts) do
			win.bufs[#win.bufs + 1] = api.nvim_create_buf(false, true)
		end
	elseif #win.bufs ~= #win.display_opts then
		for i = #win.bufs + 1, #win.display_opts do
			win.bufs[i] = api.nvim_create_buf(false, true)
		end
	end
	win.frames = {}
	for index, display_opt in ipairs(win.display_opts) do
		win.frames[index] = api.nvim_open_win(win.bufs[index], true, display_opt)
		api.nvim_set_current_buf(win.bufs[index])
		api.nvim_set_current_win(win.frames[index])
	end
	-- TODO: this needs to corrected
	win.sensai_win_augroup = api.nvim_create_augroup('Sensai Window', {
		clear = false,
	})
	api.nvim_create_autocmd("VimResized", {
		group = win.sensai_win_augroup,
		callback = function(args)
			if not (win.frames and api.nvim_win_is_valid(win.frames[1])) then
				return true
			end
			win.layout(nil)
			local config = {}
			for index, _ in ipairs(win.display_opts) do
				for _, key in ipairs({ "relative", "width", "height", "col", "row" }) do
					config[key] = win.display_opts[index][key]
				end
				for index, _ in ipairs(win.display_opts) do
					api.nvim_win_set_config(win.frames[index], config)
				end
			end
		end
	})
	api.nvim_create_autocmd("BufEnter", {
		group = win.sensai_win_augroup,
		callback = function(args)
			if type(win.bufs) == "nil" then
				return true
			end
			for _, buf in ipairs(win.bufs) do
				if buf == args.buf then
					return false
				end
			end
			win.close()
			return true
		end
	})
	api.nvim_create_autocmd("WinClosed", {
		group = win.sensai_win_augroup,
		callback = function(args)
			if type(win.bufs) == "nil" then
				return true
			end
			for _, buf in ipairs(win.bufs) do
				if buf == args.buf then
					win.close()
					return true
				end
			end
			return false
		end
	})
end

win.set_layers = function(text_array, alignment_array)
	local width = function(text)
		local width = 0
		for _, line in ipairs(text) do
			if width < #line then
				width = #line
			end
		end
		return width
	end
	for index, text in ipairs(text_array) do
		if index > #win.bufs then
			return
		end
		local horizonal_text_offset = 0
		if bit.band(alignment_array[index], 2) == 0 then
			horizonal_text_offset =  math.max(win.display_opts[index].width - width(text), 0)
		end
		local new_text = {}
		if bit.band(alignment_array[index], 1) == 0 then
			local vertical_text_offset = math.max(win.display_opts[index].height - #text, 1)
			for _ = 1, vertical_text_offset do
				new_text[#new_text+1] = ""
			end
		end
		for _, line in ipairs(text) do
			new_text[#new_text+1] = string.rep(' ', horizonal_text_offset) .. line
		end
		api.nvim_buf_set_option(win.bufs[index], 'modifiable', true)
		api.nvim_buf_set_lines(win.bufs[index], 0, #new_text - 1, false, new_text)
		api.nvim_buf_set_option(win.bufs[index], 'modifiable', false)
	end
end

win.set_keymaps = function()
	for index = 3, #win.bufs do
		vim.keymap.set('n', 'c', '<cmd>lua vim.api.nvim_set_current_win(' .. win.frames[3] .. ')<CR>', {
			silent = true,
			buffer = win.bufs[index]
		})
		vim.keymap.set('n', 'm', '<cmd>lua vim.api.nvim_set_current_win(' .. win.frames[4] .. ')<CR>', {
			silent = true,
			buffer = win.bufs[index]
		})
		vim.keymap.set('n', 'i', '<cmd>lua vim.api.nvim_set_current_win(' .. win.frames[5] .. ')<CR>', {
			silent = true,
			buffer = win.bufs[index]
		})
	end
end

win.close = function()
	local frames = win.frames
	local bufs = win.bufs
	win.frames = nil
	win.bufs = nil
	vim.schedule(function()
		if bufs and api.nvim_buf_is_valid(bufs[1]) then
			for _, buf in ipairs(bufs) do
				api.nvim_buf_delete(buf, { force = true })
			end
		end
		if frames and api.nvim_win_is_valid(frames[1]) then
			api.nvim_win_close(frames[1], true)
		end
	end)
end

return win
