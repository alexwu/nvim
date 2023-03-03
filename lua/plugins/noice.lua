return {
  "folke/noice.nvim",
  event = "VimEnter",
  config = function()
    require("noice").setup({
      popupmenu = {
        enabled = false,
      },
      notify = { enabled = true },
      lsp = {
        progress = {
          enabled = true,
          -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
          -- See the section on formatting for more details on how to customize.
          --- @type NoiceFormat|string
          format = "lsp_progress",
          --- @type NoiceFormat|string
          format_done = "lsp_progress_done",
          throttle = 1000 / 30, -- frequency to update lsp progress message
          view = "mini",
        },
        hover = { enabled = true },
        signature = { enabled = true },
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
