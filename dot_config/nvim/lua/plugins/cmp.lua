local cmp = require("cmp")
local compare = cmp.config.compare
local lspkind = require("lspkind")
local luasnip = require("luasnip")

require("cmp-npm").setup({})

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local select_next = function(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end

local select_prev = function(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end

---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
	sources = {
		{ name = "nvim_lsp", max_item_count = 10, priority = 100 },
		{ name = "treesitter", max_item_count = 10 },
		{ name = "copilot" },
		{ name = "nvim_lua" },
		{ name = "luasnip", max_item_count = 3 },
		{ name = "cmp_tabnine" },
		{ name = "path" },
		{ name = "npm", keyword_length = 4 },
	},
	comparators = {
		require("cmp_tabnine.compare"),
		compare.offset,
		compare.exact,
		compare.scopes,
		compare.score,
		compare.recently_used,
		compare.locality,
		compare.kind,
		compare.sort_text,
		compare.length,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	enabled = function()
		local context = require("cmp.config.context")
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end
	end,
	mapping = {
		["<CR>"] = cmp.mapping.confirm(),
		["<C-p>"] = cmp.mapping(select_prev, { "i", "c" }),
		["<C-n>"] = cmp.mapping(select_next, { "i", "c" }),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<Down>"] = cmp.mapping(select_next, { "i", "c" }),
		["<Up>"] = cmp.mapping(select_prev, { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<Tab>"] = select_next,
		["<S-Tab>"] = select_prev,
		["<C-l>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				return cmp.complete_common_string()
			end
			fallback()
		end, { "i", "c" }),
	},
	-- preselect = cmp.PreselectMode.None,
	formatting = {
		format = lspkind.cmp_format({
			with_text = true,
			mode = "symbol_text",
			menu = {
				buffer = "[Buffer]",
				cmp_tabnine = "[TabNine]",
				copilot = "[Copilot]",
				crates = "[Crates]",
				luasnip = "[LuaSnip]",
				npm = "[npm]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				path = "[Path]",
				treesitter = "[TreeSitter]",
			},
			dup = {
				buffer = 0,
				path = 0,
				nvim_lsp = 1,
				cmp_tabnine = 0,
				nvim_lua = 0,
				treesitter = 0,
			},
		}),
	},
	experimental = {
		ghost_text = true,
	},
	documentation = { border = "rounded" },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(":", {
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

vim.cmd([[autocmd FileType toml lua require('cmp').setup.buffer { sources = { { name = 'crates' } } }]])
vim.cmd([[autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }]])
