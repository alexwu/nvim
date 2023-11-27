return {
  {
    "lewis6991/satellite.nvim",
    cond = function()
      return vim.fn.has("nvim-0.10.0") == 1
    end,
    dependencies = { "gitsigns.nvim" },
    config = function()
      require("satellite").setup({
        current_only = true,
      })
    end,
  },
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "danielfalk/smart-open.nvim",
      "stevearc/overseer.nvim",
    },
    enabled = true,
    event = "VimEnter",
    opts = function() end,
    config = function()
      local dash = require("alpha.themes.dashboard")

      dash.section.buttons.val = {
        -- stylua: ignore
        dash.button("<space>", " " .. " Recent files", [[:lua require("telescope").extensions.smart_open.smart_open({ cwd_only = true, match_algorithm = "fzf" })<CR>]]),
        dash.button("f", " " .. " Find file", [[:lua require("nucleo").find()<CR>]]),
        dash.button("/", " " .. " Find text", ":Telescope live_grep <CR>"),
        dash.button("r", " " .. " Run task", [[:lua require("overseer").run_template()<CR>]]),
        dash.button("c", " " .. " Config", [[:lua require("bombeelu.pickers").config_files() <CR>]]),
        dash.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dash.button("q", " " .. " Quit", ":qa<CR>"),
      }
      for _, button in ipairs(dash.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dash.section.header.opts.hl = "AlphaHeader"
      dash.section.buttons.opts.hl = "AlphaButtons"
      dash.section.footer.opts.hl = "AlphaFooter"
      dash.opts.layout[1].val = 8
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dash.opts)
    end,
  },
}
