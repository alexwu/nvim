return {
  "echasnovski/mini.comment",
  dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
  version = false,
  opts = {
    options = {
      custom_commentstring = function()
        return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
      end,
    },
  },
  config = function(_, opts)
    require("mini.comment").setup(opts)
    require("which-key").register({
      c = {
        name = "+comment",
      },
    }, { prefix = "g" })
  end,
}
