local utils = require("bombeelu.utils")
local set = utils.set
local ex = utils.ex
local reload = require("plenary.reload")
local Job = require("plenary.job")

vim.g.mapleader = " "

set("n", "j", "gj", { desc = "Move down a display line" })
set("n", "k", "gk", { desc = "Move up a display line" })

set({ "x" }, "<C-j>", "5gj", { desc = "Move down 5 display lines" })
set({ "x" }, "<C-k>", "5gk", { desc = "Move up 5 display lines" })
set({ "x" }, "<C-h>", "5h", { desc = "Move left 5 columns" })
set({ "x" }, "<C-l>", "5l", { desc = "Move right 5 columns" })

set({ "n", "i" }, "<C-j>", "<Down>", { desc = "Move down a  line" })
set({ "n", "i" }, "<C-k>", "<Up>", { desc = "Move up a line" })
set({ "n", "i" }, "<C-h>", "<Left>", { desc = "Move left a column" })
set({ "n", "i" }, "<C-l>", "<Right>", { desc = "Move right a column" })

set("n", "<ESC>", ex("noh"))
set("x", "<F2>", '"*y', { desc = "Copy to system clipboard" })
set("n", "<A-BS>", "db")
set("i", "<A-BS>", "<C-W>")

set("n", "tt", ex("tabnew"), { desc = "Create a new tab" })
set("n", "tq", ex("tabclose"), { desc = "Close the current tab" })
set("n", "]t", "gt")
set("n", "[T", "gT")
set("n", "Q", ex("quit"))

set("n", "<A-o>", "o<esc>")
set("n", "<A-O>", "O<esc>")

set("n", "gg", "gg", {
	desc = "Go to first line.",
})

-- vim.fn.getpos('v')
-- vim.fn.getcurpos()

set({ "v" }, "(", function()
	local bufnr = 0
	local visual_modes = {
		v = true,
		V = true,
		-- [t'<C-v>'] = true, -- Visual block does not seem to be supported by vim.region
	}

	-- Return if not in visual mode
	if visual_modes[nvim.get_mode().mode] == nil then
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

local chezmoi_apply = function()
	nvim.ex.wall()

	Job
		:new({
			command = "chezmoi",
			args = { "apply" },
			cwd = vim.loop.cwd(),
			on_stderr = function(_, data)
				vim.notify(data, "error")
			end,
			on_stdout = function(_, return_val)
				vim.notify(return_val)
			end,
			on_exit = function(_, _)
				vim.notify("chezmoi apply: successful")
			end,
		})
		:start()
end

nvim.create_augroup("Bombeelu", { clear = true })
nvim.create_autocmd("FileType", {
	pattern = "qf",
	group = "Bombeelu",
	callback = function()
		set("n", "<CR>", "<CR>" .. ex("cclose"), { buffer = true })
	end,
})

nvim.create_user_command("Chezmoi", chezmoi_apply, { nargs = 0, desc = "Runs chezmoi apply" })

nvim.create_user_command("Reload", function(opts)
	local fargs = opts.fargs
	reload.reload_module(fargs[1])
end, { nargs = 1 })

vim.cmd([[autocmd FileType qf nnoremap <buffer> <silent> <ESC> :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> q :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> gd <C-]>]])
