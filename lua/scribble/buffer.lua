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

		-- auto close the buffer if buffer lost focus
		vim.api.nvim_create_autocmd("BufLeave", {
			buffer = state.floating.buf,
			callback = function()
				if vim.api.nvim_win_is_valid(state.floating.win) then
					vim.api.nvim_win_close(state.floating.win, true)
				end
				vim.api.nvim_buf_call(state.floating.buf, function()
					vim.cmd("write")
				end)
			end,
		})
	end
end

return M
