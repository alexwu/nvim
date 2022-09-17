local M = {}

function M.setup()
  require("spectacle").setup({
    runners = {},
    ft = {
      javascript = { "jest" },
      javascriptreact = { "jest" },
      lua = { "vusted" },
      typescript = { "jest" },
      typescriptreact = { "jest" },
      ruby = { "rspec" },
    },
  })
  require("telescope").load_extension("spectacle")
end

return M
