local set = vim.keymap.set
local api = vim.api
local utils = require("utils")

vim.g.mapleader = " "

set("n", "j", "gj")
set("n", "k", "gk")

set({ "x" }, "<C-j>", "5gj")
set({ "x" }, "<C-k>", "5gk")
set({ "x" }, "<C-h>", "5h")
set({ "x" }, "<C-l>", "5l")

set({ "n", "i" }, "<C-j>", "<Down>")
set({ "n", "i" }, "<C-k>", "<Up>")
set({ "n", "i" }, "<C-h>", "<Left>")
set({ "n", "i" }, "<C-l>", "<Right>")

set("n", "<ESC>", "<cmd>noh<CR>")
set("x", "<F2>", '"*y')
set("n", "<A-BS>", "db")
set("i", "<A-BS>", "<C-W>")

set("n", "tt", "<cmd>tabnew<CR>")
set("n", "tq", "<cmd>tabclose<CR>")
set("n", "]t", "gt")
set("n", "[T", "gT")
set("n", "Q", function()
	api.nvim_win_close(0, false)
end)

set("n", "<A-o>", "o<esc>")
set("n", "<A-O>", function()
	local pos = api.nvim_win_get_cursor(0)
	local line = pos[1] - 1
	api.nvim_buf_set_lines(0, line, line, true, { "" })
end)

set("n", "<Leader>l", "<cmd>vsplit %<CR>")
set("n", "<Leader>h", "<cmd>botright vsplit %<CR>")

-- vim.fn.getpos('v')
-- vim.fn.getcurpos()

map({ "v" }, "(", function()
	local bufnr = 0
	local visual_modes = {
		v = true,
		V = true,
		-- [t'<C-v>'] = true, -- Visual block does not seem to be supported by vim.region
	}

	-- Return if not in visual mode
	if visual_modes[vim.api.nvim_get_mode().mode] == nil then
		return
	end

	local options = {}
	options.adjust = function(pos1, pos2)
		if vim.fn.visualmode() == "V" then
			pos1[3] = 1
			pos2[3] = 2 ^ 31 - 1
		end

		if pos1[2] > pos2[2] then
			pos2[3], pos1[3] = pos1[3], pos2[3]
			return pos2, pos1
		elseif pos1[2] == pos2[2] and pos1[3] > pos2[3] then
			return pos2, pos1
		else
			return pos1, pos2
		end
	end

	utils.get_visual_selection()
	local region, start, finish = utils.get_marked_region("v", ".")
	if start == nil or finish == nil then
		vim.notify("now wtf do i do", vim.log.levels.ERROR)
		return
	end

	-- vim.pretty_print("(" .. utils.get_visual_selection() ..")")
	-- vim.pretty_print(region)
	-- vim.pretty_print(start)
	-- vim.pretty_print(finish)

	local start_pair, finish_pair
	if finish[2] < start[2] then
		start_pair = finish
		finish_pair = start
	else
		start_pair = start
		finish_pair = finish
	end

	-- utils.insert_text("fuck", start_pair, { finish_pair[1], -1 })
	utils.insert_text(")", { finish_pair[1] + 1, finish_pair[2] + 1 })
	utils.insert_text("(", { start_pair[1] + 1, start_pair[2] })
end)
-- vim.pretty_print(vim.fn.getcurpos())
-- vim.pretty_print(api.nvim_win_get_cursor(0))

-- set("n", "<A-O>", "O<esc>")

vim.cmd([[autocmd FileType qf nnoremap <buffer> <silent> <ESC> :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> q :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> gd <C-]>]])
