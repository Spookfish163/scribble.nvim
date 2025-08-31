local config = require("scribble.config")
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

M.encode = function(path)
	-- if name contains _ change it to __
	local spaced = string.gsub(path, "_", "__")
	-- if name contains / change it to _
	spaced = string.gsub(spaced, M.path_separator, "_")
	return spaced
end

M.decode = function(path)
	local tmp_text = "riset1209384rsite123"

	-- change "__" to some random text
	local out = string.gsub(path, "__", tmp_text)

	-- change "_" to seperator
	out = string.gsub(out, "_", M.path_separator)

	-- change the random text to "_"
	out = string.gsub(out, tmp_text, "_")
	return out
end

return M
