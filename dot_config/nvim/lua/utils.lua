local fn = vim.fn
local if_nil = vim.F.if_nil
local api = vim.api

local M = {}
--
---@param install_path string
---@return boolean
M.install_packer = function(install_path)
	return fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

---@param install_path string
---@return boolean
M.needs_packer = function(install_path)
	return fn.empty(fn.glob(install_path)) > 0
end

M.packer_bootstrap = function(install_path)
	local packer_bootstrap = nil
	if M.needs_packer(install_path) then
		packer_bootstrap = M.install_packer(install_path)
	end

	return packer_bootstrap
end

M.not_vscode = function()
	if fn.exists("g:vscode") == 0 then
		return true
	else
		return false
	end
end

M.tree_width = function(percentage)
	percentage = percentage or 0.2
	return math.min(40, vim.fn.round(vim.o.columns * percentage))
end

-- NOTE: pos is currently 1 indexed cause lua. Should i handle that outside this function?
M.insert_text = function(text, pos, opts)
	opts = if_nil(opts, {})
	pos = if_nil(pos, api.nvim_win_get_cursor(0))

	local bufnr = if_nil(opts.bufnr, 0)

	api.nvim_buf_set_text(bufnr, pos[1] - 1, pos[2], pos[1] - 1, pos[2], { text })
end

vim.keymap.set({ "n", "i" }, "<C-q>", function()
	M.insert_text("fart")
end)

--- Get a table of lines with start, end columns for a region marked by two points
---
--@param bufnr number of buffer
--@param pos1 (line, column) tuple marking beginning of region
--@param pos2 (line, column) tuple marking end of region
--@param regtype type of selection (:help setreg)
--@param inclusive boolean indicating whether the selection is end-inclusive
--@return region lua table of the form {linenr = {startcol,endcol}}
function M.region(bufnr, pos1, pos2, regtype, inclusive)
	if not vim.api.nvim_buf_is_loaded(bufnr) then
		vim.fn.bufload(bufnr)
	end

	-- in case of block selection, columns need to be adjusted for non-ASCII characters
	-- TODO: handle double-width characters
	local bufline
	if regtype:byte() == 22 then
		bufline = vim.api.nvim_buf_get_lines(bufnr, pos1[1], pos1[1] + 1, true)[1]
		pos1[2] = vim.str_utfindex(bufline, pos1[2])
	end

	local region = {}
	for l = pos1[1], pos2[1] do
		local c1, c2
		if regtype:byte() == 22 then -- block selection: take width from regtype
			c1 = pos1[2]
			c2 = c1 + regtype:sub(2)
			-- and adjust for non-ASCII characters
			bufline = vim.api.nvim_buf_get_lines(bufnr, l, l + 1, true)[1]
			if c1 < #bufline then
				c1 = vim.str_byteindex(bufline, c1)
			end
			if c2 < #bufline then
				c2 = vim.str_byteindex(bufline, c2)
			end
		else
			c1 = (l == pos1[1]) and pos1[2] or 0
			c2 = (l == pos2[1]) and (pos2[2] + (inclusive and 1 or 0)) or -1
		end
		table.insert(region, l, { c1, c2 })
	end
	return region
end

--- Get the region between two marks and the start and end positions for the region
---
--@param mark1 Name of mark starting the region
--@param mark2 Name of mark ending the region
--@param options Table containing the adjustment function, register type and selection mode
--@return region region between the two marks, as returned by |vim.region|
--@return start (row,col) tuple denoting the start of the region
--@return finish (row,col) tuple denoting the end of the region
function M.get_marked_region(mark1, mark2, options)
	options = if_nil(options, {})
	local bufnr = 0
	local adjust = options.adjust or function(pos1, pos2)
		return pos1, pos2
	end
	local regtype = options.regtype or vim.fn.visualmode()
	local selection = options.selection or (vim.o.selection ~= "exclusive")

	local pos1 = vim.fn.getpos(mark1)
	local pos2 = vim.fn.getpos(mark2)
	pos1, pos2 = adjust(pos1, pos2)

	local start = { pos1[2] - 1, pos1[3] - 1 + pos1[4] }
	local finish = { pos2[2] - 1, pos2[3] - 1 + pos2[4] }

	-- Return if start or finish are invalid
	if start[2] < 0 or finish[1] < start[1] then
		return
	end

	local region = M.region(bufnr, start, finish, regtype, selection)
	return region, start, finish
end

--- Get the current visual selection as a string
---
--@return selection string containing the current visual selection
function M.get_visual_selection()
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

	local region, start, finish = M.get_marked_region("v", ".", options)

	-- Compute the number of chars to get from the first line,
	-- because vim.region returns -1 as the ending col if the
	-- end of the line is included in the selection
	local lines = vim.api.nvim_buf_get_lines(bufnr, start[1], finish[1] + 1, false)
	local line1_end
	if region[start[1]][2] - region[start[1]][1] < 0 then
		line1_end = #lines[1] - region[start[1]][1]
	else
		line1_end = region[start[1]][2] - region[start[1]][1]
	end

	lines[1] = vim.fn.strpart(lines[1], region[start[1]][1], line1_end, true)
	if start[1] ~= finish[1] then
		lines[#lines] = vim.fn.strpart(lines[#lines], region[finish[1]][1], region[finish[1]][2] - region[finish[1]][1])
	end
	return table.concat(lines)
end

return M
