local M = {}

function M.add_keymaps(buf, win, callbacks)
	vim.keymap.set("n", "<C-Up>", function()
		callbacks.move_up()
	end, { buffer = buf, desc = "Move Scribble window up" })

	vim.keymap.set("n", "<C-Down>", function()
		callbacks.move_down()
	end, { buffer = buf, desc = "Move Scribble window down" })

	vim.keymap.set("n", "<C-Left>", function()
		callbacks.move_left()
	end, { buffer = buf, desc = "Move Scribble window left" })

	vim.keymap.set("n", "<C-Right>", function()
		callbacks.move_right()
	end, { buffer = buf, desc = "Move Scribble window right" })

	vim.keymap.set("n", "q", function()
		vim.api.nvim_win_close(win, false)
	end, { buffer = buf })

	vim.keymap.set("n", "<ESC>", function()
		vim.api.nvim_win_close(win, false)
	end, { buffer = buf })
end

return M
