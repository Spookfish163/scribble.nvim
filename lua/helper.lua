local state = require("state")

local M = {}

local function open_floating_window(opts)
	opts = opts or {}

	if not vim.api.nvim_buf_is_valid(state.floating.buf) then
		local listed = true
		local scratch = false
		state.floating.buf = vim.api.nvim_create_buf(listed, scratch)
		vim.api.nvim_set_option_value("filetype", "markdown", { buf = state.floating.buf })
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

	vim.api.nvim_set_option_value("number", true, { win = win })

	-- TODO: add keymaps to move the window around

	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, false)
	end, { buffer = state.floating.buf })

	vim.keymap.set("n", "<ESC>", function()
		vim.api.nvim_win_close(win, false)
	end, { buffer = state.floating.buf })

	return win
end

function M.open_scribble()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating.win = open_floating_window()
	else
		print("Scribble: Scribble window is already open")
	end
end

function M.close_scribble()
	if vim.api.nvim_win_is_valid(state.floating.win) then
		vim.api.nvim_win_hide(state.floating.win)
	else
		print("Scribble: Scribble window not opened")
	end
end

function M.toggle_scribble()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating.win = open_floating_window()
	else
		vim.api.nvim_win_hide(state.floating.win)
	end
end

function M.handle_scribble_args(args)
	if args.args and args.args ~= "" then
		if args.args == "toggle" then
			M.toggle_scribble()
		elseif args.args == "open" then
			M.open_scribble()
		elseif args.args == "close" then
			M.close_scribble()
		else
			print("Scribble: Unrecognised argument")
		end
	end
end

return M
