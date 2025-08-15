local M = {}

M.setup = function()
	-- nothing rn
end

local open_floating_window = function()
	local buf = vim.api.nvim_create_buf(false, false)

	local width = math.floor(vim.o.columns / 2)
	local height = math.floor(vim.o.lines / 2)

	local opts = {
		relative = "win",
		width = width,
		height = height,
		col = width / 2,
		row = height / 2,
		style = "minimal",
		border = "rounded",
	}

	local win = vim.api.nvim_open_win(buf, true, opts)

	return win
end

open_floating_window()

return M
