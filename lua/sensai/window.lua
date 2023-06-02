local api = vim.api
local win = {
	opts = {},
	win_opts = {},
}

win.win_setup = function(opts)
	win.opts = vim.tbl_deep_extend("force", {
		style = "minimal",
		border = "single",
		zindex = 50,
	}, opts or {})
	win.win_opts = {
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
	win.win_mount()
end

win.win_mount = function()
	if not win.buf then
		win.buf = api.nvim_create_buf(false, false)
	end
	win.win = api.nvim_open_win(win.buf, true, win.win_opts)
	api.nvim_set_current_win(win.win)
end

win.win_close = function()
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
