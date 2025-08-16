local state = require("scribble.state")
local config = require("scribble.config")

local M = {}

function M.str_to_pos(str)
	if str == "center" or str == "center" then
		return 11
	elseif str == "N" then
		return 10
	elseif str == "NW" then
		return 00
	elseif str == "NE" then
		return 20
	elseif str == "S" then
		return 12
	elseif str == "SW" then
		return 02
	elseif str == "SE" then
		return 22
	elseif str == "W" then
		return 01
	elseif str == "E" then
		return 21
	else
		return nil
	end
end

function M.pos_to_str(pos)
	if pos == 11 then
		return "center"
	elseif pos == 10 then
		return "N"
	elseif pos == 00 then
		return "NW"
	elseif pos == 20 then
		return "NE"
	elseif pos == 12 then
		return "S"
	elseif pos == 02 then
		return "SW"
	elseif pos == 22 then
		return "SE"
	elseif pos == 01 then
		return "W"
	elseif pos == 21 then
		return "E"
	else
		return nil
	end
end

function M.open_floating_window(opts)
	opts = opts or {}

	if not vim.api.nvim_buf_is_valid(state.floating.buf) then
		local listed = true
		local scratch = false

		state.floating.buf = vim.api.nvim_create_buf(listed, scratch)

		vim.api.nvim_set_option_value("filetype", "markdown", { buf = state.floating.buf })
		vim.api.nvim_buf_set_name(state.floating.buf, "Scribble")
	end

	local term_width = vim.o.columns
	local term_height = vim.o.lines

	local width = opts.width or math.floor(term_width * 0.75)
	local height = opts.height or math.floor(term_height / 2)

	local col = opts.col or (term_width - width) / 2
	local row = opts.row or (term_height - height) / 2

	local winopts = {
		relative = "editor",
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

	M.add_keymaps()

	return win
end

function M.add_keymaps()
	vim.keymap.set("n", "<C-Up>", function()
		M.move_window_up()
	end, { buffer = state.floating.buf, desc = "Move Scribble window up" })

	vim.keymap.set("n", "<C-Down>", function()
		M.move_window_down()
	end, { buffer = state.floating.buf, desc = "Move Scribble window down" })

	vim.keymap.set("n", "<C-Left>", function()
		M.move_window_left()
	end, { buffer = state.floating.buf, desc = "Move Scribble window left" })

	vim.keymap.set("n", "<C-Right>", function()
		M.move_window_right()
	end, { buffer = state.floating.buf, desc = "Move Scribble window right" })

	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(state.floating.win, false)
	end, { buffer = state.floating.buf })

	vim.keymap.set("n", "<ESC>", function()
		vim.api.nvim_win_close(state.floating.win, false)
	end, { buffer = state.floating.buf })
end

local function reopen_at(pos)
	local pos_str = M.pos_to_str(pos)
	if not pos_str then
		return
	end
	if vim.api.nvim_win_is_valid(state.floating.win) then
		vim.api.nvim_win_close(state.floating.win, true)
	end
	state.floating.pos = pos
	state.floating.pos_str = pos_str
	state.floating.win = M.open_scribble_window(pos_str)
end

function M.move_window_up()
	local pos = M.str_to_pos(state.floating.pos_str)
	pos = pos - 1

	reopen_at(pos)
end

function M.move_window_down()
	local pos = M.str_to_pos(state.floating.pos_str)
	pos = pos + 1

	reopen_at(pos)
end

function M.move_window_left()
	local pos = M.str_to_pos(state.floating.pos_str)
	pos = pos - 10

	reopen_at(pos)
end

function M.move_window_right()
	local pos = M.str_to_pos(state.floating.pos_str)
	pos = pos + 10

	reopen_at(pos)
end

function M.open_scribble_window(p_pos)
	local pos = p_pos or state.floating.pos_str or config.options.pos or "center"

	state.floating.pos_str = pos

	local term_width = vim.o.columns
	local term_height = vim.o.lines

	local width = (config.options.width and config.options.width > 0) and config.options.width
		or math.floor(term_width * 0.75)

	local height = (config.options.height and config.options.height > 0) and config.options.height
		or math.floor(term_height / 2)

	local col, row

	if pos == "center" then
		col = (term_width - width) / 2
		row = (term_height - height) / 2
	elseif pos == "N" then
		col = (term_width - width) / 2
		row = 1
	elseif pos == "NW" then
		col = 1
		row = 1
	elseif pos == "NE" then
		col = math.max(1, term_width - width)
		row = 1
	elseif pos == "S" then
		col = (term_width - width) / 2
		row = math.max(1, term_height - height)
	elseif pos == "SW" then
		col = 1
		row = math.max(1, term_height - height)
	elseif pos == "SE" then
		col = math.max(1, term_width - width)
		row = math.max(1, term_height - height)
	elseif pos == "W" then
		col = 1
		row = (term_height - height) / 2
	elseif pos == "E" then
		col = math.max(1, term_width - width)
		row = (term_height - height) / 2
	else
		error("Scribble: Unrecognised window positio, possible values are (center, N, S, E, W, NW,NE, SW, SE)")
	end

	return M.open_floating_window({
		width = width,
		height = height,
		col = col,
		row = row,
	})
end

function M.open_scribble()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating.win = M.open_scribble_window()
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
		state.floating.win = M.open_scribble_window()
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
