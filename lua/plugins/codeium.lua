if true then
  return {}
end

return {
  {
    "Exafunction/codeium.nvim",
    enabled = false,
    cmd = "Codeium",
    build = ":Codeium Auth",
    opts = {
      enable_chat = true,
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "codeium.nvim", "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "codeium" },
        providers = {
          codeium = {
            name = "codeium",
            module = "blink.compat.source",
          },
        },
      },
    },
  },
}
