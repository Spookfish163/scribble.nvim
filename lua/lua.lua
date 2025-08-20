---@diagnostic disable: need-check-nil
local handle = io.popen("git --version")

---@diagnostic disable-next-line: unused-local
local output = handle:read("*a")
local status = handle:close()

if status then
	local is_git_dir = io.popen("cd /home/ankush/Coding && git rev-parse --show-toplevel")

	local out = is_git_dir:read("*l")

	if not out then
		print("not a git repo")
	end

	is_git_dir:close()
else
	print(
		"Scribble: For some(one) extra functionality scribble needs git installed. dw if you don't have it. You can just ignore this warning"
	)
end
