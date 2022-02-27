local cmp = require("cmp")
local cmp_buffer = require("cmp_buffer")
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

---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
	sources = {
		{ name = "nvim_lsp", max_item_count = 10, priority = 100 },
		{ name = "treesitter", max_item_count = 10 },
		{ name = "nvim_lua" },
		{ name = "luasnip", max_item_count = 3 },
		{ name = "cmp_tabnine" },
		{ name = "path" },
		{ name = "npm", keyword_length = 4 },
	},
	comparators = {
		require("cmp_tabnine.compare"),
		function(...)
			return cmp_buffer:compare_locality(...)
		end,
		cmp.config.compare.offset,
		cmp.config.compare.exact,
		cmp.config.compare.score,
		cmp.config.compare.recently_used,
		cmp.config.compare.kind,
		cmp.config.compare.sort_text,
		cmp.config.compare.length,
		cmp.config.compare.order,
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
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
		["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end,
		["<S-Tab>"] = function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end,
		["<C-l>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				return cmp.complete_common_string()
			end
			fallback()
		end, { "i", "c" }),
		-- ["<Right>"] = cmp.mapping(function(fallback)
		-- 	if cmp.visible() then
		-- 		return cmp.complete_common_string()
		-- 	end
		-- 	fallback()
		-- end, { "i", "c" }),
	},
	preselect = cmp.PreselectMode.None,
	formatting = {
		format = lspkind.cmp_format({
			with_text = true,
			menu = {
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				cmp_tabnine = "[T9]",
				path = "[Path]",
				luasnip = "[LuaSnip]",
				treesitter = "[TS]",
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
