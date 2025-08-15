local M = {}

M.setup = function()
	-- nothing rn
end

local helper = require("lua.helper")

vim.api.nvim_create_user_command("Scribble", helper.handle_scribble_args, { nargs = 1 })

vim.keymap.set("n", "<leader>sc", helper.toggle_scribble)

return M
