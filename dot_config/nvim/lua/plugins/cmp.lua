local cmp = require("cmp")
local types = require("cmp.types")
local mapping = cmp.mapping
local compare = cmp.config.compare
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local tabnine = require("cmp_tabnine.config")

tabnine:setup({
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = "..",
  ignored_file_types = {},
  show_prediction_strength = true,
})

local tab_next = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  else
    fallback()
  end
end

local tab_prev = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

local select_next = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  else
    fallback()
  end
end

local select_prev = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
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
    require("cmp_tabnine.compare"),
    compare.locality,
    compare.exact,
    compare.recently_used,
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
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<C-n>"] = mapping(mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert })),
    ["<C-p>"] = mapping(mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert })),
    ["<C-d>"] = mapping.scroll_docs(-4),
    ["<C-f>"] = mapping.scroll_docs(4),
    ["<Down>"] = mapping(select_next),
    ["<Up>"] = mapping(select_prev),
    ["<C-e>"] = mapping({
      i = mapping.abort(),
      c = mapping.close(),
    }),
    ["<Tab>"] = mapping(tab_next),
    ["<S-Tab>"] = mapping(tab_prev),
    ["<C-l>"] = mapping(function(fallback)
      if cmp.visible() then
        return cmp.complete_common_string()
      end
      fallback()
    end),
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
        path = "[Path]",
        treesitter = "[TreeSitter]",
      },
      dup = {
        buffer = 0,
        path = 0,
        nvim_lsp = 1,
        cmp_tabnine = 0,
        treesitter = 0,
      },
    }),
  },
  experimental = {
    ghost_text = { highlight = "CmpGhostText" },
  },
})

cmp.setup.cmdline("/", {
  mapping = mapping.preset.cmdline({}),
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
