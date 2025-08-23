local M = {}

-- get all the files
-- https://stackoverflow.com/a/76675386
local files =
	vim.split(vim.fn.glob("/home/ankush/.local/share/nvim/scribble.nvim/" .. "/*"), "\n", { trimempty = true })
local dfiles = {}

for i, item in ipairs(files) do
	dfiles[i] =  vim.text.hexdecode(vim.fn.fnamemodify(item, ":t"))
end

local fzf = require("fzf-lua")

local deli = " "

-- ask the picker to find it

-- https://github.com/kawre/leetcode.nvim/blob/master/lua/leetcode/picker/question/fzf.lua#L18-L33
local function run()
	fzf.fzf_exec(dfiles, {
		prompt = "Select a File > ",
		fzf_opts = {
			["--delimiter"] = deli,
			["--nth"] = "3..-3",
		},
		-- actions = {
		-- 	["default"] = function(selected)
		-- 		local slug = Picker.hidden_field(selected[1], deli)
		-- 		local question = problemlist.get_by_title_slug(slug)
		-- 		question_picker.select(question)
		-- 	end,
		-- },
	})
end

run()

return M
