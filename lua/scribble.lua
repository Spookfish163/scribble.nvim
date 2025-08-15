local M = {}

M.setup = function()
	-- nothing rn
end

local function open_floating_window(opts)
	opts = opts or {}

	local listed = false
	local scratch = false

	local buf = vim.api.nvim_create_buf(listed, scratch)

	local width = opts.width or math.floor(vim.o.columns / 2)
	local height = opts.height or math.floor(vim.o.lines / 2)

	local col = opts.col or math.floor(vim.o.columns / 4)
	local row = opts.row or math.floor(vim.o.lines / 4)

	local winopts = {
		relative = "win",
		width = width,
		height = height,
		col = col,
		row = row,
		style = opts.style or "minimal",
		border = opts.border or "rounded",
		title = "Scribble",
		title_pos = "left"
	}

	local focus_the_window = true
	local win = vim.api.nvim_open_win(buf, focus_the_window, winopts)

	return win
end

open_floating_window()

return M
