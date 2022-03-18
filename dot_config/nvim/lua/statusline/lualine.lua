local gps = require("nvim-gps")

require("nvim-gps").setup()

local snazzy = function()
	local colors = {
		background = "#3a3d4d",
		foreground = "#eff0eb",
		black = "#282a36",
		red = "#ff5c57",
		green = "#5af78e",
		yellow = "#f3f99d",
		blue = "#57c7ff",
		purple = "#ff6ac1",
		cyan = "#9aedfe",
		white = "#f1f1f0",
		lightgray = "#b1b1b1",
		darkgray = "#3a3d4d",
	}

	return {
		normal = {
			a = { bg = colors.blue, fg = colors.black, gui = "bold" },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.darkgray, fg = colors.lightgray },
		},
		insert = {
			a = { bg = colors.green, fg = colors.black, gui = "bold" },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.darkgray, fg = colors.lightgray },
		},
		visual = {
			a = { bg = colors.purple, fg = colors.black, gui = "bold" },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.darkgray, fg = colors.lightgray },
		},
		replace = {
			a = { bg = colors.red, fg = colors.black, gui = "bold" },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.darkgray, fg = colors.lightgray },
		},
		command = {
			a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
			b = { bg = colors.lightgray, fg = colors.white },
			c = { bg = colors.darkgray, fg = colors.lightgray },
		},
		inactive = {
			a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
			b = { bg = colors.lightgray, fg = colors.gray },
			c = { bg = colors.darkgray, fg = colors.darkgray },
		},
	}
end

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ""
		elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
			return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
		end
		return str
	end
end

-- require'lualine'.setup {
--   lualine_a = {
--     {'mode', fmt=trunc(80, 4, nil, true)},
--     {'filename', fmt=trunc(90, 30, 50)},
--     {function() return require'lsp-status'.status() end, fmt=truc(120, 20, 60)}
--   }
-- }

local function window()
	return vim.api.nvim_win_get_number(0)
end

-- require'lualine'.setup {
--   sections = {
--     lualine_a = { window },
--   }
-- }
--
require("lualine").setup({
	options = {
		theme = snazzy(),
		disabled_filetypes = {},
		component_separators = "|",
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	extensions = { "fzf", "fugitive", "nvim-tree", "quickfix", "toggleterm" },
	sections = {
		lualine_a = {
			{
				"mode",
				separator = { left = "" },
				right_padding = 2,
			},
		},
		lualine_b = {
			{ "branch", color = { fg = "#3a3d4d", bg = "#f1f1f0" }, separator = { right = "" } },
		},
		lualine_c = {
			{ "filename", path = 0, shorting_target = 20 },
			{ gps.get_location, cond = gps.is_available },
		},
		lualine_x = { "filetype" },
		lualine_y = {},
		lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
})
