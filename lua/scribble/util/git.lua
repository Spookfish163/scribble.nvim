local M = {}

function M.check_availability()
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

local is_windows = vim.loop.os_uname().sysname == "Windows"
local devnull = is_windows and "2>NULL" or "2>/dev/null"

function M.check_dir(path)
	local cmd = "cd " .. path .. " && git rev-parse --is-inside-work-tree " .. devnull

	local is_git_dir = io.popen(cmd, "r")
	if not is_git_dir then
		return false
	end

	local out = is_git_dir:read("*l")
	is_git_dir:close()
	return out == "true"
end

function M.get_root(path)
	local cmd = "cd " .. path .. " && git rev-parse --show-toplevel " .. devnull

	local get_root_dir = io.popen(cmd, "r")
	if not get_root_dir then
		return nil
	end

	local out = get_root_dir:read("*l")
	get_root_dir:close()
	return out
end

return M
