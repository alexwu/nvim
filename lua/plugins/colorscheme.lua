return {
  {
    "alexwu/nvim-snazzy",
    dependencies = { "rktjmp/lush.nvim" },
    branch = "lush",
    dev = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("snazzy")
    end,
    enabled = true,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      require("tokyonight").setup({
        style = "default",
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "dark", -- style for sidebars, see below
          floats = "dark", -- style for floating windows
        },
        ---@param colors ColorScheme
        on_colors = function(colors)
          -- colors = {
          --   none = "NONE",
          --   bg_highlight = "#292e42",
          --   terminal_black = "#414868",
          -- fg_gutter = "#3b4261",
          --   dark3 = "#545c7e",
          --   dark5 = "#737aa2",
          --   blue0 = "#3d59a1",
          --   blue1 = "#2ac3de",
          --   blue2 = "#0db9d7",
          --   blue5 = "#89ddff",
          --   blue6 = "#b4f9f8",
          --   blue7 = "#394b70",
          --   green1 = "#73daca",
          --   green2 = "#41a6b5",
          --   red1 = "#db4b4b",
          colors.fg = "#eff0eb"
          colors.fg_dark = "#eff0eb"
          colors.bg = "#282a36"
          colors.bg_dark = "#282a36"
          colors.red = "#ff5c57"
          colors.orange = "#FF9F43"
          colors.yellow = "#f3f99d"
          colors.green = "#8AFF80"
          colors.green1 = "#5af78e"
          colors.green2 = "#ccff88"
          colors.teal = "#19f9d8"
          colors.blue = "#57c7ff"
          colors.purple = "#A39DF9"
          colors.magenta = "#ff6ac1"
          colors.magenta2 = "#ff007c"
          colors.cyan = "#9aedfe"
          colors.git = {
            delete = "#3a0603",
            change = "#434805",
            add = "#00331a",
          }
          colors.gitSigns = {
            add = colors.green1,
            change = colors.yellow,
            delete = colors.red,
          }
          colors.comment = "#606580"

          --           _blue: '#45A9F9'
          -- _light-blue: '#6FC1FF'
          -- _purple: '#B084EB'
          -- _purple-fade: '#B084EB60'
          -- _light-purple: '#BCAAFE'
          -- _green: '#19f9d8'
          -- _light-green: '#6FE7D2'
          -- _green-fade: '#19f9d899'
          --           {
          --     "name" : "Dracula PRO",
          --     "background" : "#22212C",
          --     "black" : "#22212C",
          --     "blue" : "#9580FF",
          --     "brightBlack" : "#504C67",
          --     "brightBlue" : "#AA99FF",
          --     "brightCyan" : "#99FFEE",
          --     "brightGreen" : "#A2FF99",
          --     "brightPurple" : "#FF99CC",
          --     "brightRed" : "#FFAA99",
          --     "brightWhite" : "#FFFFFF",
          --     "brightYellow" : "#FFFF99",
          --     "cyan" : "#80FFEA",
          --     "foreground" : "#F8F8F2",
          --     "green" : "#8AFF80",
          --     "purple" : "#FF80BF",
          --     "red" : "#FF9580",
          --     "white" : "#F8F8F2",
          --     "yellow" : "#FFFF80"
          -- }
        end,
        ---@param hl Highlights
        ---@param c ColorScheme
        on_highlights = function(hl, c)
          local util = require("tokyonight.util")

          hl.FlashBackdrop = {
            sp = "#666666",
            fg = "#666666",
          }

          hl.FlashLabel = {
            fg = c.magenta2,
            bold = true,
          }
          hl.FlashCurrent = { fg = c.fg }
          hl.FlashMatch = { fg = "#ccff88", bold = true }

          -- -- FlashMatch { gui = "bold", fg = "#00dfff" },
        end,
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    dependencies = { "nvim-snazzy" },
    config = function()
      require("transparent").setup({
        groups = {
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          "CursorLineNr",
          "EndOfBuffer",
          "NoiceMini",
        },
        extra_groups = {},
        exclude_groups = {},
      })
    end,
    enabled = false,
  },
  {
    "navarasu/onedark.nvim",
    enabled = false,
    config = function()
      require("onedark").setup({
        colors = {
          green = "#5af78e",
          black = "#282a36",
          bg0 = "#282c34",
          bg1 = "#31353f",
          bg2 = "#393f4a",
          bg3 = "#3b3f4c",
          bg_d = "#21252b",
          bg_blue = "#73b8f1",
          bg_yellow = "#ebd09c",
          fg = "#abb2bf",
          purple = "#c678dd",
          orange = "#d19a66",
          blue = "#61afef",
          yellow = "#e5c07b",
          cyan = "#56b6c2",
          red = "#e86671",
          grey = "#5c6370",
          light_grey = "#848b98",
          dark_cyan = "#2b6f77",
          dark_red = "#993939",
          dark_yellow = "#93691d",
          dark_purple = "#8a3fa0",
          diff_text = "#2c5372",
          diff_delete = "#3a0603",
          diff_change = "#434805",
          diff_add = "#00331a",
        },
      })
      require("onedark").load()
    end,
  },
}
