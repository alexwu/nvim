local cmp = require("cmp")
local types = require("cmp.types")
local mapping = cmp.mapping
local compare = cmp.config.compare
local lspkind = require("lspkind")
local luasnip = require("luasnip")

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
		-- elseif luasnip.expand_or_jumpable() then
		-- 	luasnip.expand_or_jump()
	elseif has_words_before() then
		cmp.complete()
	else
		fallback()
	end
end

local select_prev = function(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
		-- elseif luasnip.jumpable(-1) then
		-- 	luasnip.jump(-1)
	else
		fallback()
	end
end

local preset = function()
	if vim.env.TERM_PROGRAM == "iTerm.app" or vim.g.neovide then
		return "default"
	else
		return "codicons"
	end
end

---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
	sources = cmp.config.sources({
		{ name = "nvim_lsp", max_item_count = 10 },
		{ name = "treesitter", max_item_count = 10 },
		{ name = "copilot" },
		{ name = "luasnip", max_item_count = 3 },
		{ name = "cmp_tabnine" },
		{ name = "path" },
		{ name = "npm", keyword_length = 4 },
	}),
	comparators = {
		compare.locality,
		compare.exact,
		compare.recently_used,
		require("cmp_tabnine.compare"),
		compare.offset,
		compare.scopes,
		compare.score,
		compare.kind,
		compare.sort_text,
		compare.length,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered({ border = "rounded" }),
		documentation = cmp.config.window.bordered({ border = "rounded", winhighlight = "FloatBorder:FloatBorder" }),
	},
	enabled = function()
		local context = require("cmp.config.context")
		if vim.api.nvim_get_mode().mode == "c" then
			return true
		else
			return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
		end
	end,
	mapping = mapping.preset.insert({
		["<CR>"] = mapping.confirm(),
		["<C-n>"] = mapping(mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }), { "i", "c" }),
		["<C-p>"] = mapping(mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }), { "i", "c" }),
		["<C-d>"] = mapping.scroll_docs(-4),
		["<C-f>"] = mapping.scroll_docs(4),
		["<Down>"] = mapping(select_next, { "i", "c" }),
		["<Up>"] = mapping(select_prev, { "i", "c" }),
		["<C-e>"] = mapping({
			i = mapping.abort(),
			c = mapping.close(),
		}),
		["<Tab>"] = mapping(select_next, { "i", "c" }),
		["<S-Tab>"] = mapping(select_prev, { "i", "c" }),
		["<C-l>"] = mapping(function(fallback)
			if cmp.visible() then
				return cmp.complete_common_string()
			end
			fallback()
		end, { "i", "c" }),
	}),
	formatting = {
		format = lspkind.cmp_format({
			preset = preset(),
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
})

cmp.setup.cmdline("/", {
	mapping = mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
		{ name = "path" },
	},
})

cmp.setup.cmdline(":", {
	mapping = mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})

require("cmp-npm").setup({})

vim.cmd([[autocmd FileType toml lua require('cmp').setup.buffer { sources = { { name = 'crates' } } }]])
vim.cmd([[autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }]])
