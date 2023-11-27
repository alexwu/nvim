return {
  "stevearc/dressing.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    require("dressing").setup({
      input = {
        enabled = true,
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
        get_config = function(opts)
          if opts.kind == "codeaction" then
            -- return {
            --   backend = "builtin",
            --   builtin = {
            --     style = "minimal",
            --     border = "none",
            --     relative = "cursor",
            --     width = 25,
            --     height = 1,
            --     zindex = 200,
            --     row = 1,
            --     col = 0,
            --   },
            -- }
            return {
              backend = "telescope",
              telescope = require("telescope.themes").get_cursor({
                initial_mode = "insert",
                layout_config = { wdith = 0.8 },
              }),
            }
          end
        end,
        telescope = require("telescope.themes").get_dropdown({
          initial_mode = "insert",
        }),

        -- Options for built-in selector
        -- builtin = {
        --   -- These are passed to nvim_open_win
        --   anchor = "NW",
        --   relative = "cursor",
        --   border = "rounded",
        --
        --   -- Window transparency (0-100)
        --   winblend = 10,
        --   -- Change default highlight groups (see :help winhl)
        --   winhighlight = "",
        --
        --   -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        --   width = nil,
        --   max_width = 0.8,
        --   min_width = 40,
        --   height = nil,
        --   max_height = 0.9,
        --   min_height = 10,
        -- },
      },
    })
  end,
}
