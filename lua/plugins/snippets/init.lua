if true then
  return {
    "L3MON4D3/LuaSnip",
    -- build = (not jit.os:find("Windows"))
    --     and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
    --     or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      { "<tab>",   function() require("luasnip").jump(1) end,  mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  }
end

return {
  -- "L3MON4D3/LuaSnip",
  "dcampos/nvim-snippy",
  dependencies = {
    -- "rafamadriz/friendly-snippets",
    -- {
    --   "dsznajder/vscode-es7-javascript-react-snippets",
    --   build = "yarn install --frozen-lockfile && yarn compile",
    --   cond = function()
    --     return not vim.g.vscode
    --   end,
    -- },
    "honza/vim-snippets",
  },
  enabled = true,
  event = "VeryLazy",
  config = function()
    require("snippy").setup({
      mappings = {
        is = {
          ["<Tab>"] = "expand_or_advance",
          ["<S-Tab>"] = "previous",
        },
        nx = {
          ["<leader>x"] = "cut_text",
        },
      },
    })
    -- local ls = require("luasnip")
    -- local s = ls.snippet
    -- local sn = ls.snippet_node
    -- local isn = ls.indent_snippet_node
    -- local t = ls.text_node
    -- local i = ls.insert_node
    -- local f = ls.function_node
    -- local c = ls.choice_node
    -- local d = ls.dynamic_node
    -- local r = ls.restore_node
    -- local l = require("luasnip.extras").lambda
    -- local rep = require("luasnip.extras").rep
    -- local p = require("luasnip.extras").partial
    -- local m = require("luasnip.extras").match
    -- local n = require("luasnip.extras").nonempty
    -- local dl = require("luasnip.extras").dynamic_lambda
    -- local fmt = require("luasnip.extras.fmt").fmt
    -- local fmta = require("luasnip.extras.fmt").fmta
    -- local types = require("luasnip.util.types")
    -- local conds = require("luasnip.extras.expand_conditions")
    --
    -- ls.config.set_config({
    --   history = true,
    --   updateevents = "TextChanged,TextChangedI",
    --   delete_check_events = "InsertLeave",
    --   region_check_events = "InsertEnter",
    --   ext_opts = {
    --     [types.choiceNode] = {
    --       active = {
    --         virt_text = { { "●", "Comment" } },
    --       },
    --     },
    --     [types.insertNode] = {
    --       active = {
    --         virt_text = { { "●", "" } },
    --       },
    --     },
    --   },
    --   ext_base_prio = 300,
    --   ext_prio_increase = 1,
    --   enable_autosnippets = false,
    --   ft_func = require("luasnip.extras.filetype_functions").from_pos_or_filetype,
    -- })
    --
    -- local describe_snippet = sn([[describe("]], {
    --   t([[describe("]]),
    --   i(0, "test name"),
    --   t([[", () => {]], "", "})"),
    -- })
    --
    -- local it_snippet = sn([[it("]], {
    --   t([[it("]]),
    --   i(0, "test name"),
    --   t([[", () => {]], "", "})"),
    -- })
    --
    -- -- ls.add_snippets("javascript", {
    -- --   s("describetest", {
    -- --     t([[import ]]),
    -- --     dl(1, l.TM_FILENAME),
    -- --     t([[from "./]]),
    -- --     dl(2, l.TM_FILENAME),
    -- --     t([[";]], [[]], [[describe("]]),
    -- --     dl(3, l.TM_FILENAME:gsub("%.", ""), {}),
    -- --     t([[", ]]),
    -- --     i(4, "() => {"),
    -- --     t(""),
    -- --     isn(1, ""),
    -- --     t("})"),
    -- --   }),
    -- -- })
    -- --
    -- ls.filetype_extend("typescriptreact", { "typescript", "javascriptreact", "javascript" })
    -- ls.filetype_extend("typescript", { "javascript" })
    -- ls.filetype_extend("javascriptreact", { "javascript" })
    -- ls.filetype_extend("cpp", { "c" })
    --
    -- require("luasnip.loaders.from_vscode").load({})
  end,
}
