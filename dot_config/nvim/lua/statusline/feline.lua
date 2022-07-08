local navic = require("nvim-navic")
local vi_mode_utils = require("feline.providers.vi_mode")

local M = {}

function M.setup(opts)
  M.setup_statusline(opts)
  M.setup_winbar(opts)
end

function M.setup_statusline(opts)
  local components = {
    active = {},
    inactive = {},
  }

  table.insert(components.active, {
    {
      provider = "▊ ",
      hl = {
        fg = "skyblue",
      },
    },
    {
      provider = "vi_mode",
      hl = function()
        return {
          name = vi_mode_utils.get_mode_highlight_name(),
          fg = vi_mode_utils.get_mode_color(),
          style = "bold",
        }
      end,
    },
    {
      provider = "file_size",
      right_sep = {
        " ",
        {
          str = "slant_left_2_thin",
          hl = {
            fg = "fg",
            bg = "bg",
          },
        },
      },
    },
    {
      provider = "position",
      left_sep = " ",
      right_sep = {
        " ",
        {
          str = "slant_right_2_thin",
          hl = {
            fg = "fg",
            bg = "bg",
          },
        },
      },
    },
    {
      provider = "diagnostic_errors",
      hl = { fg = "red" },
    },
    {
      provider = "diagnostic_warnings",
      hl = { fg = "yellow" },
    },
    {
      provider = "diagnostic_hints",
      hl = { fg = "cyan" },
    },
    {
      provider = "diagnostic_info",
      hl = { fg = "skyblue" },
    },
  })

  table.insert(components.active, {
    {
      provider = "git_branch",
      hl = {
        fg = "white",
        bg = "black",
        style = "bold",
      },
      right_sep = {
        str = " ",
        hl = {
          fg = "NONE",
          bg = "black",
        },
      },
    },
    {
      provider = "git_diff_added",
      hl = {
        fg = "green",
        bg = "black",
      },
    },
    {
      provider = "git_diff_changed",
      hl = {
        fg = "orange",
        bg = "black",
      },
    },
    {
      provider = "git_diff_removed",
      hl = {
        fg = "red",
        bg = "black",
      },
      right_sep = {
        str = " ",
        hl = {
          fg = "NONE",
          bg = "black",
        },
      },
    },
    {
      provider = "line_percentage",
      hl = {
        style = "bold",
      },
      left_sep = "  ",
      right_sep = " ",
    },
    {
      provider = "scroll_bar",
      hl = {
        fg = "skyblue",
        style = "bold",
      },
    },
  })

  table.insert(components.inactive, {
    {
      provider = "file_type",
      hl = {
        fg = "white",
        bg = "oceanblue",
        style = "bold",
      },
      left_sep = {
        str = " ",
        hl = {
          fg = "NONE",
          bg = "oceanblue",
        },
      },
      right_sep = {
        {
          str = " ",
          hl = {
            fg = "NONE",
            bg = "oceanblue",
          },
        },
        "slant_right",
      },
    },
    {},
  })

  require("feline").setup({ components = components, theme = opts.theme })
end

function M.setup_winbar(opts)
  local components = {
    active = {},
    inactive = {},
  }

  table.insert(components.active, {
    {
      provider = { name = "file_info", opts = { type = "unique" } },
      hl = {
        fg = "skyblue",
        bg = "NONE",
        style = "bold",
      },
    },
  })

  table.insert(components.inactive, {
    {
      provider = { name = "file_info", opts = { type = "unique" } },
      hl = {
        fg = "white",
        bg = "NONE",
        style = "bold",
      },
    },
  })

  table.insert(components.active[1], {
    provider = function()
      return navic.get_location()
    end,
    enabled = function()
      return navic.is_available()
    end,
  })

  require("feline").winbar.setup({ components = components })
end

return M
