local M = {}

-- arr array<T>
-- element T
M.tbl_contains = function(arr, element)
	for _, value in ipairs(arr) do
		if value == element then
			return true
		end
	end
	return false
end

return M
