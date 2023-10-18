local set = vim.keymap.set

local function enter_terminal_normal_mode()
  nvim.feedkeys(nvim.replace_termcodes([[<C-\><C-n>]], true, false, true), "n", false)
end

return {
  "vim-test/vim-test",
  dependencies = {
    "numToStr/FTerm.nvim",
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      opts = {},
    },
  },
  cond = function()
    return not vim.g.vscode
  end,
  cmd = { "TestFile", "TestNearest" },
  config = function()
    _G.fterm_strategy = function(cmd)
      require("FTerm").scratch({
        border = "rounded",
        cmd = cmd,
        dimensions = {
          height = 0.95,
          width = 0.95,
        },
      })
    end

    vim.cmd([[
      function! FTermStrategy(cmd)
        let g:cmd = a:cmd . "\n"
        lua fterm_strategy(vim.g.cmd)
      endfunction

      let g:test#custom_strategies = {'fterm': function('FTermStrategy')}
    ]])

    vim.api.nvim_set_var("test#strategy", "fterm")
    vim.api.nvim_set_var("test#ruby#rspec#executable", "bundle exec rspec")
    vim.api.nvim_set_var("test#ruby#rspec#patterns", "_spec.rb")
    vim.api.nvim_set_var("test#ruby#rspec#options", {
      file = "--format documentation --force-color",
      suite = "--format documentation --force-color",
      nearest = "--format documentation --force-color",
    })
    vim.api.nvim_set_var("test#javascript#jest#options", "--color=always")
    vim.api.nvim_set_var("test#typescript#jest#options", "--color=always")
    -- vim.api.nvim_set_var("test#rust#cargo#options",  'verbose')
    vim.env.DEBUG_PRINT_LIMIT = 20000
    vim.env.RUST_LOG = "trace"
    -- set("n", "<F7>", "<cmd>TestNearest<CR>")
    -- set("n", "<F9>", "<cmd>TestFile<CR>")
    set("n", "<F7>", vim.cmd.TestNearest)
    set("n", "<F9>", vim.cmd.TestFile)

    -- local M = {}
    --
    -- M.terminal = require("FTerm.terminal"):new({
    --   border = "rounded",
    -- })
    --
    -- set({ "n", "t" }, [[<A-Bslash>]], function()
    --   M.terminal:toggle()
    -- end)
  end,
}
