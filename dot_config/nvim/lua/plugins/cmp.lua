local cmp = require("cmp")
local types = require("cmp.types")
local mapping = cmp.mapping
local compare = cmp.config.compare
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local tabnine = require("cmp_tabnine.config")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local tab_next = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_locally_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    cmp.complete()
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
  elseif has_words_before() then
    cmp.complete()
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
      select = false,
    }),
    ["<C-d>"] = mapping.scroll_docs(-4),
    ["<C-f>"] = mapping.scroll_docs(4),
    ["<Down>"] = mapping(select_next),
    ["<Up>"] = mapping(select_prev),
    ["<C-e>"] = mapping({
      i = mapping.abort(),
      c = mapping.close(),
    }),
    ["<C-n>"] = mapping(tab_next),
    ["<C-p>"] = mapping(tab_prev),
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
    format = function(entry, vim_item)
      if entry.source.name == "copilot" then
        vim_item.kind = "[] Copilot"
        vim_item.kind_hl_group = "CmpItemKindCopilot"
        return vim_item
      end

      return lspkind.cmp_format({
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
      })(entry, vim_item)
    end,
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

tabnine:setup({
  max_lines = 1000,
  max_num_results = 20,
  sort = true,
  run_on_every_keystroke = true,
  snippet_placeholder = "..",
  ignored_file_types = {},
  show_prediction_strength = true,
})

require("cmp-npm").setup({})

nvim.create_augroup("bombeelu.cmp", { clear = true })
nvim.create_autocmd("FileType", {
  pattern = "toml",
  group = "bombeelu.cmp",
  callback = function()
    require("cmp").setup.buffer({ sources = { { name = "crates" } } })
  end,
})

nvim.create_autocmd("FileType", {
  pattern = "TelescopePrompt",
  group = "bombeelu.cmp",
  callback = function()
    require("cmp").setup.buffer({ enabled = false })
  end,
})
