local set = vim.keymap.set

local function prettier()
	return {
		exe = "prettier",
		args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
		stdin = true,
	}
end

local function rubocop()
	return {
		exe = "bundle exec rubocop",
		args = {
			"--auto-correct",
			"--stdin",
			"%:p",
			"2>/dev/null",
			"|",
			"awk 'f; /^====================$/{f=1}'",
		},
		stdin = true,
	}
end

local function stylua()
	return {
		exe = "stylua",
		args = {
			"-",
		},
		stdin = true,
	}
end

local function rustfmt()
	return { exe = "rustfmt", args = { "--emit=stdout", "--edition=2021" }, stdin = true }
end

local function gofmt()
	return { exe = "gofmt", args = { "-s" }, stdin = true }
end

local function black()
	return { exe = "black", args = {}, stdin = true }
end

require("formatter").setup({
	logging = false,
	filetype = {
		typescript = { prettier },
		typescriptreact = { prettier },
		javascript = { prettier },
		javascriptreact = { prettier },
		go = { gofmt },
		graphql = { prettier },
		json = { prettier },
		jsonc = { prettier },
		html = { prettier },
		css = { prettier },
		ruby = { prettier },
		rust = { rustfmt },
		lua = { stylua },
		python = { black },
	},
})

-- set({ "n", "v" }, "<F8>", "<CMD>Format<CR>", { silent = true })
set({ "n", "v" }, "<Leader>y", "<CMD>Format<CR>", { silent = true })
set({ "n", "v" }, "gy", "<CMD>Format<CR>", { silent = true })
