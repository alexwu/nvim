return {
  "knubie/vim-kitty-navigator",
  build = "cp ./*.py ~/.config/kitty/",
  cond = function()
    return vim.env.TERM == "xterm-kitty" and not vim.g.vscode
  end,
  config = function()
    local Job = require("plenary.job")

    local set = vim.keymap.set
    local if_nil = vim.F.if_nil

    -- vim.g.kitty_navigator_no_mappings = 1

    set("n", "<A-h>", "<cmd>KittyNavigateLeft<cr>")
    set("n", "<A-h>", "<cmd>KittyNavigateLeft<cr>")
    set("n", "<A-l>", "<cmd>KittyNavigateRight<cr>")
    set("n", "<A-j>", "<cmd>KittyNavigateDown<cr>")

    key.map({ "<A-k>", "<C-Up>" }, function()
      vim.cmd.KittyNavigateUp()
    end, { modes = "n" })

    set("n", "<C-Left>", "<cmd>KittyNavigateLeft<cr>")
    set("n", "<C-Right>", "<cmd>KittyNavigateRight<cr>")
    set("n", "<C-Down>", "<cmd>KittyNavigateDown<cr>")

  end,
}
