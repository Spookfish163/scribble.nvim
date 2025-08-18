local state = require("scribble.state")
local data = require("scribble.data")

local M = {}

function M.init_buffer()
	if not vim.api.nvim_buf_is_valid(state.floating.buf) then
		local listed = true
		local scratch = false

		state.floating.buf = vim.api.nvim_create_buf(listed, scratch)

		data.init_data()

		vim.api.nvim_set_option_value("filetype", "markdown", { buf = state.floating.buf })
		vim.api.nvim_set_option_value("buflisted", false, { buf = state.floating.buf })
	end
end

return M
