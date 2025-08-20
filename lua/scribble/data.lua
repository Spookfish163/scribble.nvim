local state = require("scribble.state")

local M = {}

-- the path join function is taken from reddit here:
-- https://www.reddit.com/r/neovim/comments/su0em7/pathjoin_for_lua_or_vimscript_do_we_have_anything/
-- by user u/cseickel
-- thank you very much for letting me borrow your code!! <3

M.path_separator = "/"
M.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win32unix") == 1
if M.is_windows == true then
	M.path_separator = "\\"
end

M.split = function(inputString, sep)
	local fields = {}

	local pattern = string.format("([^%s]+)", sep)
	local _ = string.gsub(inputString, pattern, function(c)
		fields[#fields + 1] = c
	end)

	return fields
end

M.path_join = function(...)
	local args = { ... }
	if #args == 0 then
		return ""
	end

	local all_parts = {}
	if type(args[1]) == "string" and args[1]:sub(1, 1) == M.path_separator then
		all_parts[1] = ""
	end

	for _, arg in ipairs(args) do
		local arg_parts = M.split(arg, M.path_separator)
		vim.list_extend(all_parts, arg_parts)
	end
	return table.concat(all_parts, M.path_separator)
end

local function create_dir_if_not_exist(path)
	if vim.fn.isdirectory(path) then
		vim.fn.mkdir(path, "-p")
	end
end

function M.init_data()
	local base_data_dir = M.path_join(vim.fn.stdpath("data"), "scribble.nvim")
	create_dir_if_not_exist(base_data_dir)

	local filename
	local current_dir = vim.fn.getcwd()

	if M.check_git_availability() and M.check_git_dir(current_dir) then
		filename = vim.fn.sha256(M.get_git_root(current_dir))
	else
		filename = vim.fn.sha256(current_dir)
	end

	local full_file_path = M.path_join(base_data_dir, filename)

	-- open the file in the current buffer!!
	vim.api.nvim_buf_call(state.floating.buf, function()
		vim.cmd("edit " .. full_file_path)
	end)
end

function M.check_git_availability()
	---@diagnostic disable: need-check-nil
	local handle = io.popen("git --version")

	---@diagnostic disable-next-line: unused-local
	local output = handle:read("*a")
	local status = handle:close()

	if status then
		return true
	else
		print(
			"Scribble: For some(one) extra functionality scribble needs git installed. dw if you don't have it. You can just ignore this warning"
		)
		return false
	end
end

function M.check_git_dir(path)
	local is_git_dir = io.popen("cd " .. path .. " && git rev-parse --is-inside-work-tree")

	local out = is_git_dir:read("*l")

	if not out then
		is_git_dir:close()
		return false
	end

	is_git_dir:close()
	return true
end

function M.get_git_root(path)
	local is_git_dir = io.popen("cd " .. path .. " && git rev-parse --show-toplevel")

	local out = is_git_dir:read("*l")
	is_git_dir:close()

	return out
end

return M
