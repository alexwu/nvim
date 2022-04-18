local actions = require("fzf-lua.actions")
local set = vim.keymap.set

require("fzf-lua").setup({
	global_resume = true, -- enable global `resume`?
	global_resume_query = true, -- include typed query in `resume`?
	-- winopts_fn = function()
	-- 	-- smaller width if neovim win has over 80 columns
	-- 	return { width = vim.o.columns > 80 and 0.65 or 0.85 }
	-- end,
	-- winopts = {
	-- 	height = 0.50, -- window height
	-- 	width = 0.80, -- window width
	-- 	row = 0.35, -- window row position (0=top, 1=bottom)
	-- 	col = 0.55, -- window col position (0=left, 1=right)
	-- 	border = "rounded",
	-- 	fullscreen = false,
	-- 	hl = {
	-- 		normal = "Normal", -- window normal color (fg+bg)
	-- 		border = "Normal", -- border color (try 'FloatBorder')
	-- 		cursor = "Cursor", -- cursor highlight (grep/LSP matches)
	-- 		cursorline = "CursorLine", -- cursor line
	-- 		search = "Search", -- search matches (ctags)
	-- 		-- title       = 'Normal',        -- preview border title (file/buffer)
	-- 		-- scrollbar_f = 'PmenuThumb',    -- scrollbar "full" section highlight
	-- 		-- scrollbar_e = 'PmenuSbar',     -- scrollbar "empty" section highlight
	-- 	},
	-- 	preview = {
	-- 		-- 	border = "border", -- border|noborder, applies only to
	-- 		-- 	wrap = "nowrap", -- wrap|nowrap
	-- 		hidden = "nohidden", -- hidden|nohidden
	-- 		vertical = "up:50%", -- up|down:size
	-- 		layout = "vertical", -- horizontal|vertical|flex
	-- 		-- 	flip_columns = 120, -- #cols to switch to horizontal on flex
	-- 		title = true, -- preview border title (file/buf)?
	-- 		scrollbar = "float", -- `false` or string:'float|border'
	-- 		-- 	-- float:  in-window floating border
	-- 		-- 	-- border: in-border chars (see below)
	-- 		-- 	scrolloff = "-2", -- float scrollbar offset from right
	-- 		-- 	-- applies only when scrollbar = 'float'
	-- 		-- 	scrollchars = { "█", "" }, -- scrollbar chars ({ <full>, <empty> }
	-- 		-- 	-- applies only when scrollbar = 'border'
	-- 		-- 	delay = 100, -- delay(ms) displaying the preview
	-- 		-- 	-- prevents lag on fast scrolling
	-- 		-- 	winopts = { -- builtin previewer window options
	-- 		-- 		number = true,
	-- 		-- 		relativenumber = false,
	-- 		-- 		cursorline = true,
	-- 		-- 		cursorlineopt = "both",
	-- 		-- 		cursorcolumn = false,
	-- 		-- 		signcolumn = "no",
	-- 		-- 		list = false,
	-- 		-- 		foldenable = false,
	-- 		-- 		foldmethod = "manual",
	-- 		-- 	},
	-- 	},
	-- },
	keymap = {
		builtin = {
			["<F1>"] = "toggle-help",
			["<F2>"] = "toggle-fullscreen",
			["<F3>"] = "toggle-preview-wrap",
			["<F4>"] = "toggle-preview",
			["<F5>"] = "toggle-preview-ccw",
			["<F6>"] = "toggle-preview-cw",
			["<S-down>"] = "preview-page-down",
			["<S-up>"] = "preview-page-up",
			["<S-left>"] = "preview-page-reset",
		},
		fzf = {
			["ctrl-z"] = "abort",
			["ctrl-u"] = "unix-line-discard",
			["ctrl-f"] = "half-page-down",
			["ctrl-b"] = "half-page-up",
			["ctrl-a"] = "beginning-of-line",
			["ctrl-e"] = "end-of-line",
			["alt-a"] = "toggle-all",
			["f3"] = "toggle-preview-wrap",
			["f4"] = "toggle-preview",
			["shift-down"] = "preview-page-down",
			["shift-up"] = "preview-page-up",
		},
	},
	actions = {
		files = {
			["default"] = actions.file_edit_or_qf,
			["ctrl-s"] = actions.file_split,
			["ctrl-v"] = actions.file_vsplit,
			["ctrl-t"] = actions.file_tabedit,
			["alt-q"] = actions.file_sel_to_qf,
		},
		buffers = {
			["default"] = actions.buf_edit,
			["ctrl-s"] = actions.buf_split,
			["ctrl-v"] = actions.buf_vsplit,
			["ctrl-t"] = actions.buf_tabedit,
		},
	},
	fzf_opts = {
		["--ansi"] = "",
		["--prompt"] = "> ",
		["--info"] = "inline",
		["--height"] = "100%",
		-- ["--layout"] = false,
	},
	-- fzf '--color=' options (optional)
	--[[ fzf_colors = {
      ["fg"]          = { "fg", "CursorLine" },
      ["bg"]          = { "bg", "Normal" },
      ["hl"]          = { "fg", "Comment" },
      ["fg+"]         = { "fg", "Normal" },
      ["bg+"]         = { "bg", "CursorLine" },
      ["hl+"]         = { "fg", "Statement" },
      ["info"]        = { "fg", "PreProc" },
      ["prompt"]      = { "fg", "Conditional" },
      ["pointer"]     = { "fg", "Exception" },
      ["marker"]      = { "fg", "Keyword" },
      ["spinner"]     = { "fg", "Label" },
      ["header"]      = { "fg", "Comment" },
      ["gutter"]      = { "bg", "Normal" },
  }, ]]
	files = {
		prompt = "❯ ",
		multiprocess = true,
		git_icons = true,
		file_icons = true,
		color_icons = true,
		rg_opts = "--color=never --files --hidden --follow -g '!.git'",
		fd_opts = "--color=never --type f --hidden --follow --exclude .git",
		actions = {
			["default"] = actions.file_edit,
		},
	},
	git = {
		files = {
			prompt = "GitFiles❯ ",
			cmd = "git ls-files --exclude-standard",
			multiprocess = true,
			git_icons = true,
			file_icons = true,
			color_icons = true,
		},
		status = {
			prompt = "GitStatus❯ ",
			cmd = "git status -s",
			previewer = "git_diff",
			file_icons = true,
			git_icons = true,
			color_icons = true,
			actions = {
				["right"] = { actions.git_unstage, actions.resume },
				["left"] = { actions.git_stage, actions.resume },
			},
		},
		commits = {
			prompt = "Commits❯ ",
			cmd = "git log --pretty=oneline --abbrev-commit --color",
			preview = "git show --pretty='%Cred%H%n%Cblue%an%n%Cgreen%s' --color {1}",
			actions = {
				["default"] = actions.git_checkout,
			},
		},
		branches = {
			prompt = "Branches❯ ",
			cmd = "git branch --all --color",
			preview = "git log --graph --pretty=oneline --abbrev-commit --color {1}",
			actions = {
				["default"] = actions.git_switch,
			},
		},
		icons = {
			["M"] = { icon = "M", color = "yellow" },
			["D"] = { icon = "D", color = "red" },
			["A"] = { icon = "A", color = "green" },
			["R"] = { icon = "R", color = "yellow" },
			["C"] = { icon = "C", color = "yellow" },
			["?"] = { icon = "?", color = "magenta" },
		},
	},
	lsp = {
		prompt_postfix = "❯ ", -- will be appended to the LSP label
		-- to override use 'prompt' instead
		cwd_only = false, -- LSP/diagnostics for cwd only?
		async_or_timeout = 5000, -- timeout(ms) or 'true' for async calls
		file_icons = true,
		git_icons = false,
		lsp_icons = true,
		severity = "hint",
		icons = {
			["Error"] = { icon = "", color = "red" }, -- error
			["Warning"] = { icon = "", color = "yellow" }, -- warning
			["Information"] = { icon = "", color = "blue" }, -- info
			["Hint"] = { icon = "", color = "magenta" }, -- hint
		},
	},
	file_icon_padding = " ",
	file_icon_colors = {
		["lua"] = "blue",
		["rb"] = "red",
		["gemfile"] = "red",
		["js"] = "yellow",
		["jsx"] = "cyan",
		["ts"] = "blue",
		["tsx"] = "cyan",
	},
})

set("n", "<C-p>", function()
	require("fzf-lua").files()
end)

vim.api.nvim_create_user_command("Rg", function()
	require("fzf-lua").live_grep()
end, { nargs = 0 })
