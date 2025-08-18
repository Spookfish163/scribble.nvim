local state = require("scribble.state")
local buffer = require("scribble.buffer")
local keymap = require("scribble.keymap")
local config = require("scribble.config")
local util = require("scribble.util")

local M = {}

local function reopen_at(pos)
	local pos_str = util.pos_to_str(pos)
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
	reopen_at(state.floating.pos - 1)
end

function M.move_window_down()
	reopen_at(state.floating.pos + 1)
end

function M.move_window_left()
	reopen_at(state.floating.pos - 10)
end

function M.move_window_right()
	reopen_at(state.floating.pos + 10)
end

function M.open_floating_window(opts)
	opts = opts or {}

	buffer.init_buffer()

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

	keymap.add_keymaps(state.floating.buf, win, {
		move_up = M.move_window_up,
		move_down = M.move_window_down,
		move_left = M.move_window_left,
		move_right = M.move_window_right,
	})

	return win
end

-- this function calls the open_floating_window function
function M.open_scribble_window(p_pos)
	local pos = p_pos or state.floating.pos_str or config.options.pos or "center"

	state.floating.pos_str = pos
	state.floating.pos = util.str_to_pos(pos)

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

return M
