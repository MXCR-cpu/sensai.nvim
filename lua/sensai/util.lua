local api = vim.api
local loop = vim.loop
local fn = vim.fn
local M = {}

-- arr array<T>
-- element T
M.tbl_contains = function(arr, element)
	for _, value in ipairs(arr) do
		if value == element then
			return 1
		end
	end
	return 0
end

-- cmd string
M.run_silent_cmd = function(cmd)
	vim.cmd(cmd)
	-- local parse_result = api.nvim_parse_cmd(cmd, {})
	-- parse_result.mods.silent = true
	-- api.nvim_cmd(parse_result, {})
end

M.run_cmd = function(cmd)
	local job = fn.jobstart(cmd, {
		on_stdout = function(val1, val2, val3)
			print('val1: ' .. val1)
			print('val2: ' .. val2)
			print('val3: ' .. val3)
		end,
		on_stderr = function(_, _, _)
			print('error encountered')
		end,
		on_exit = function(val1, val2, val3)
			print('val1: ' .. val1)
			print('val2: ' .. val2)
			print('val3: ' .. val3)
		end,
	})

	local run = io.popen(cmd)
	return run:read('*a')
	-- vim.cmd(cmd)
	-- local parse_result = api.nvim_parse_cmd(cmd, {})
	-- api.nvim_cmd(parse_result, {})
end

M.write_to_file = function(file_path, mode, text)
	-- print(vim.inspect(loop.fs_open(file_path, mode, 438)))
	if type(loop.fs_open(file_path, mode, 438)) == "nil" then
		print("!touch " .. file_path)
		M.run_silent_cmd("!touch " .. file_path)
	end
	local file = loop.fs_open(file_path, mode, 438)
	loop.fs_write(file , text)
	loop.fs_close(file)
end


return M
