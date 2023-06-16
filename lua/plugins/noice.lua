return {
  "folke/noice.nvim",
  event = "VimEnter",
  config = function()
    require("noice").setup({
      popupmenu = {
        enabled = false,
      },
      notify = {
        enabled = true,
        view = "notify",
      },
      lsp = {
        progress = {
          enabled = false,
          -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
          -- See the section on formatting for more details on how to customize.
          --- @type NoiceFormat|string
          format = "lsp_progress",
          --- @type NoiceFormat|string
          format_done = "lsp_progress_done",
          throttle = 1000 / 30, -- frequency to update lsp progress message
          view = "mini",
        },
        hover = {
          enabled = true,
          silent = false, -- set to true to not show a message if hover is not available
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
            luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
            throttle = 50, -- Debounce lsp signature help request by 50ms
          },
          view = nil, -- when nil, use defaults from documentation
          ---@type NoiceViewOptions
          opts = {}, -- merged with defaults from documentation
        },
        documentation = {
          enabled = true,
          view = "hover",
        },
      },
      presets = {
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    })

    require("telescope").load_extension("noice")
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
}
