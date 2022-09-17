local sidebar = require("sidebar-nvim")
local lazy = require("bombeelu.utils").lazy
local tree_width = require("utils").tree_width

local symbols = require("sidebar-nvim.builtin.symbols")
symbols.bindings["<CR>"] = require("sidebar-nvim.builtin.symbols").bindings["e"]

local M = {}

function M.setup_mappings()
  vim.keymap.set("n", "<C-m>", lazy(sidebar.toggle))
end

function M.setup()
  sidebar.setup({
    initial_width = tree_width(0.2),
    sections = { "symbols", "git", "diagnostics", "todos" },
    bindings = {
      ["q"] = function()
        sidebar.close()
      end,
    },
  })

  M.setup_mappings()
end

return M
