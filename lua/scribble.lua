local M = {}

local helper = require("helper")

M.setup = function()
	vim.api.nvim_create_user_command("Scribble", helper.handle_scribble_args, { nargs = 1 })
	vim.keymap.set("n", "<leader>sc", helper.toggle_scribble)
end

M.open = helper.open_scribble
M.close = helper.close_scribble
M.toggle = helper.toggle_scribble

return M
