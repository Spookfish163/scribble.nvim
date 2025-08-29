local state = require("scribble.state")
local config = require("scribble.config")
local fs = require("scribble.util.filesystem")
local git = require("scribble.util.git")

local M = {}

local function create_dir_if_not_exist(path)
	vim.fn.mkdir(vim.fn.fnamemodify(path, ":p"), "p")
end

function M.get_storage_dir()
	return config.options.path or fs.path_join(vim.fn.stdpath("data"), "scribble.nvim")
end

function M.init_data()
	local base_data_dir = M.get_storage_dir()
	create_dir_if_not_exist(base_data_dir)

	local filename
	local current_dir = vim.fn.getcwd()

	if git.check_availability() and git.check_dir(current_dir) then
		filename = vim.text.hexencode(git.get_root(current_dir))
	else
		filename = vim.text.hexencode(current_dir)
	end

	local full_file_path = fs.path_join(base_data_dir, filename)

	-- open the file in the current buffer!!
	vim.api.nvim_buf_call(state.floating.buf, function()
		vim.cmd("edit " .. full_file_path)
	end)
end

return M
