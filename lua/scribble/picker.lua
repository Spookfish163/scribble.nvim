local fzf = require("fzf-lua")

local M = {}

-- get all the files
-- https://stackoverflow.com/a/76675386
local files =
	vim.split(vim.fn.glob("/home/ankush/.local/share/nvim/scribble.nvim/" .. "/*"), "\n", { trimempty = true })
local dfiles = {}
local map = {} -- map the decoded filenames to the corresponding full paths

for _, item in ipairs(files) do
	local fname = vim.text.hexdecode(vim.fn.fnamemodify(item, ":t:r"))
	table.insert(dfiles, fname)
	map[fname] = item
end

-- ask the picker to find it
local function run()
	fzf.fzf_exec(dfiles, {
		prompt = "Select a File > ",
		actions = {
			["default"] = function(selected)
				vim.cmd("edit " .. map[selected[1]])
			end,
		},
	})
end

run()

return M
