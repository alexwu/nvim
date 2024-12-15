return {
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    dependencies = { "saghen/blink.compat" },
    opts = {
      max_lines = 1000,
      max_num_results = 3,
      sort = true,
    },
    config = function(_, opts)
      require("cmp_tabnine.config"):setup(opts)
    end,
  },
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "tzachar/cmp-tabnine", "saghen/blink.compat" },
    opts = {
      sources = {
        default = { "cmp_tabnine" },
        providers = {
          cmp_tabnine = {
            name = "cmp_tabnine",
            module = "blink.compat.source",
          },
        },
      },
    },
  },
}
