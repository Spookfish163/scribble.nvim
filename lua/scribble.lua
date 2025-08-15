local M = {}

local state = {
	floating = {
		buf = -1,
		win = -1,
	},
}

M.setup = function()
	-- nothing rn
end

local function open_floating_window(opts)
	opts = opts or {}

	local listed = true
	local scratch = false

	if not vim.api.nvim_buf_is_valid(state.floating.buf) then
		state.floating.buf = vim.api.nvim_create_buf(listed, scratch)
		vim.api.nvim_buf_set_option(state.floating.buf, "filetype", "markdown")
	end

	local term_width = vim.o.columns
	local term_height = vim.o.lines

	local width = opts.width or math.floor(term_width * 0.75)
	local height = opts.height or math.floor(term_height / 2)

	local col = opts.col or (term_width - width) / 2
	local row = opts.row or (term_height - height) / 4

	local winopts = {
		relative = "win",
		width = width,
		height = height,
		col = col,
		row = row,
		style = opts.style or "minimal",
		border = opts.border or "rounded",
		title = "Scribble",
		title_pos = "center",
	}

	local focus_the_window = true

	local win = vim.api.nvim_open_win(state.floating.buf, focus_the_window, winopts)

	return win
end

local toggle_scribble = function()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating.win = open_floating_window()
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

vim.api.nvim_create_user_command("Scribble", toggle_scribble, {})
vim.keymap.set("n", "<leader>sc", toggle_scribble)

return M
