return {
  "monaqa/dial.nvim",
  dependencies = { "legendary.nvim" },
  lazy = false,
  config = function()
    local augend = require("dial.augend")
    local set = vim.keymap.set

    require("dial.config").augends:register_group({
      default = {
        augend.integer.alias.decimal,
        augend.integer.alias.decimal_int,
        augend.constant.alias.bool,
        augend.constant.new({
          elements = { "and", "or" },
          word = true,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { "&&", "||" },
          word = false,
          cyclic = true,
        }),
        augend.constant.new({
          elements = { "it", "fit", "xit" },
          word = true,
          cyclic = true,
        }),
      },
      typescript = {
        augend.integer.alias.decimal,
        augend.integer.alias.hex,
        augend.constant.new({ elements = { "let", "const" } }),
      },
    })

    local toolbox = require("legendary.toolbox")
    local keymaps = require("legendary").keymaps
    -- set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
    -- set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
    --
    -- set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
    -- set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })

    keymaps({
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "normal")
        end,
        description = "Increment the current word",
        mode = { "n" },
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "normal")
        end,
        description = "Decrement the current word",
        mode = { "n" },
      },
      {
        "<C-a>",
        function()
          require("dial.map").manipulate("increment", "visual")
        end,
        description = "Increment the current word",
        mode = { "v" },
      },
      {
        "<C-x>",
        function()
          require("dial.map").manipulate("decrement", "visual")
        end,
        description = "Decrement the current word",
        mode = { "v" },
      },
    })

    -- vim.keymap.set("v", "<C-a>", function()
    --   require("dial.map").manipulate("increment", "visual")
    -- end)
    -- vim.keymap.set("v", "<C-x>", function()
    --   require("dial.map").manipulate("decrement", "visual")
    -- end)
    -- vim.keymap.set("v", "g<C-a>", function()
    --   require("dial.map").manipulate("increment", "gvisual")
    -- end)
    -- vim.keymap.set("v", "g<C-x>", function()
    --   require("dial.map").manipulate("decrement", "gvisual")
    -- end)
  end,
}
