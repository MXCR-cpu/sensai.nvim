local api = vim.api
local o = vim.o
local win = {}

win.setup = function(opts)
	win.opts = vim.tbl_deep_extend("force", {
		style = "minimal",
		-- border = "single",
		border = "none",
		zindex = 50,
	}, opts or {})
	win.display_opts = {
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
		height = 50
	}
	win.layout()
	win.mount()
end

win.layout = function()
	win.display_opts.width = math.floor(o.columns / 2)
	win.display_opts.height = math.floor(o.lines / 2)
	win.display_opts.row = math.floor(o.lines / 4)
	win.display_opts.col = math.floor(o.columns / 4)
end

win.mount = function()
	if not win.buf then
		win.buf = api.nvim_create_buf(false, false)
	end
	win.win = api.nvim_open_win(win.buf, true, win.display_opts)
	api.nvim_set_current_win(win.win)
	api.nvim_create_autocmd("VimResized", {
		callback = function()
			if not (win.win and api.nvim_win_is_valid(win.win)) then
				return true
			end
			win.layout()
			local config = {}
			for _, key in ipairs({ "relative", "width", "height", "col", "row" }) do
				config[key] = win.display_opts[key]
			end
			api.nvim_win_set_config(win.win, config)
		end
	})
	api.nvim_create_autocmd("BufLeave", {
		callback = function(args)
			if args.buf == win.buf then
				win.close()
				return true
			end
		end
	})
end

win.set_text = function(lines)
	api.nvim_buf_set_lines(win.buf, 0, #lines-1, false, lines)
end

win.close = function()
	local local_win = win.win
	local local_buf = win.buf
	win.win = nil
	win.buf = nil
	vim.schedule(function()
		if local_win and api.nvim_win_is_valid(local_win) then
			api.nvim_win_close(local_win, true)
		end
		if local_buf and api.nvim_buf_is_valid(local_buf) then
			api.nvim_buf_delete(local_buf, { force = true })
		end
	end)
end

return win
