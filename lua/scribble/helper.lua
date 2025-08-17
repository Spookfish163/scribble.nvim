local state = require("scribble.state")
local window = require("scribble.window")

local M = {}

function M.open_scribble()
	if not vim.api.nvim_win_is_valid(state.floating.win) then
		state.floating.win = window.open_scribble_window()
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
		state.floating.win = window.open_scribble_window()
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
