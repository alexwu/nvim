local gps = require("nvim-gps")

require("nvim-gps").setup()

local colors = {
  background = "#282a36",
  foreground = "#eff0eb",
  black = "#282a36",
  red = "#ff5c57",
  green = "#5af78e",
  yellow = "#f3f99d",
  blue = "#57c7ff",
  purple = "#ff6ac1",
  cyan = "#9aedfe",
  white = "#f1f1f0",
  lightgray = "#b1b1b1",
  darkgray = "#3a3d4d",
}

local snazzy = function()
  return {
    normal = {
      a = { bg = colors.blue, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    insert = {
      a = { bg = colors.green, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    visual = {
      a = { bg = colors.purple, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    replace = {
      a = { bg = colors.red, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    command = {
      a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    inactive = {
      a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.gray },
      c = { bg = colors.darkgray, fg = colors.darkgray },
    },
  }
end

require("lualine").setup({
  options = {
    theme = snazzy(),
    disabled_filetypes = {
      statusline = {},
      winbar = { "toggleterm" },
    },
    component_separators = "|",
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  extensions = { "fzf", "fugitive", "nvim-tree", "quickfix", "toggleterm" },
  sections = {
    lualine_a = {
      {
        "mode",
        separator = { left = "" },
        right_padding = 2,
      },
      {
        "windows",
        mode = 4,
        windowss_color = {
          active = { bg = colors.purple, fg = colors.black, gui = "bold" },
        },
        on_click = function(count, button, modifiers)
          vim.pretty_print(count)
          vim.pretty_print(button)
          vim.pretty_print(modifiers)
        end,
      },
    },
    lualine_b = {
      { "branch", color = { fg = "#3a3d4d", bg = "#f1f1f0" }, separator = { right = "" } },
    },
    lualine_c = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },

        diagnostics_color = {
          error = "DiagnosticError",
          warn = "DiagnosticWarn",
          info = "DiagnosticInfo",
          hint = "DiagnosticHint",
        },
        symbols = { error = "✘", warn = "", info = "", hint = "" },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      },
      { gps.get_location, cond = gps.is_available },
    },
    lualine_x = { "filetype" },
    lualine_y = {},
    lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  -- winbar = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = {
  --     {
  --       "filename",
  --       path = 0,
  --       color = {
  --         fg = "#3a3d4d",
  --         bg = colors.foreground,
  --       },
  --       separator = { right = "" },
  --     },
  --   },
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = {},
  -- },
  -- inactive_winbar = {
  --   lualine_a = {},
  --   lualine_b = {},
  --   lualine_c = {
  --     {
  --       "filename",
  --       path = 0,
  --       color = {
  --         fg = colors.lightgray,
  --         bg = colors.darkgray,
  --       },
  --       separator = { right = "" },
  --     },
  --   },
  --   lualine_x = {},
  --   lualine_y = {},
  --   lualine_z = {},
  -- },
})
