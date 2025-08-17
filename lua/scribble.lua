local M = {}

local helper = require("scribble.helper")

function M.setup(opts)
	local config = require("scribble.config")
	config.setup(opts)

	vim.api.nvim_create_user_command("Scribble", helper.handle_scribble_args, { nargs = 1 })
end

M.open              = helper.open_scribble
M.close             = helper.close_scribble
M.toggle            = helper.toggle_scribble
M.move_window_right = helper.toggle_scribble
M.move_window_left  = helper.toggle_scribble
M.move_window_up    = helper.toggle_scribble
M.move_window_down  = helper.toggle_scribble

return M
