local graphql = {}

function graphql.setup(opts)
  vim.lsp.config("graphql", {
    root_markers = { "graphql.config.ts" },
  })
  vim.lsp.enable("graphql")
end

return graphql
