
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

function M.check_dir(path)
	local is_git_dir = io.popen("cd " .. path .. " && git rev-parse --is-inside-work-tree")

	local out = is_git_dir:read("*l")

	if not out then
		is_git_dir:close()
		return false
	end

	is_git_dir:close()
	return true
end

function M.get_root(path)
	local is_git_dir = io.popen("cd " .. path .. " && git rev-parse --show-toplevel")

	local out = is_git_dir:read("*l")
	is_git_dir:close()

	return out
end

return M
