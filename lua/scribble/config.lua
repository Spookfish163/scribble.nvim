local M = {}

local defaults = {
	width = -1,
	height = -1,
	pos = "center",
	picker = nil,
}

M.options = vim.deepcopy(defaults)

function M.setup(opts)
	-- this function copies the whole table to another and returns it
	M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

return M
