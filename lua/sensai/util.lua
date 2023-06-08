-- local api = vim.api
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

M.run_cmd = function(cmds)
	local exit_strings = {}
	if type(cmds) == "string" then
		local job_call = fn.jobstart(cmds, {
			on_stdout = function(_, data, _)
				-- print('result: ' .. vim.inspect(data))
				-- print('result: ' .. table.concat(data, ""))
				exit_strings = data
			end,
			-- @params job_id, data, exit_type
			on_stderr = function(_, data, _)
				print('error encountered: ' .. vim.inspect(data))
			end,
			-- @params job_id, exit_code, exit_type
			on_exit = function(_, _, _) end,
		})
		local exit_code_table = fn.jobwait({ job_call })
		exit_strings[1] = 'executing: ' .. cmds .. '; job_call: ' .. cmds .. '; exit_code: ' .. exit_code_table[1]
	elseif type(cmds) == "table" then
		local job_calls = {}
		for _, cmd in ipairs(cmds) do
			job_calls[#job_calls+1] = fn.jobstart(cmd, {
				-- @params job_id, data, exit_type
				on_stdout = function(_, _, _) end,
				-- @params job_id, data, exit_type
				on_stderr = function(_, _, _) end,
				-- @params job_id, exit_code, exit_type
				on_exit = function(_, _, _) end,
			})
		end
		local exit_codes = fn.jobwait(job_calls)
		-- for index, exit_code in ipairs(exit_codes) do
		-- 	exit_strings[#exit_strings+1] = 'executing: ' .. cmds[index] .. '; job_call: ' .. cmds[index] .. '; exit_code: ' .. exit_code
		-- end
	end
	return exit_strings
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
