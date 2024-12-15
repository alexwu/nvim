return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "haydenmeade/neotest-jest",
      "marilari88/neotest-vitest",
    },
    ft = { "typescript", "typescriptreact" },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "yarn test",
          jestConfigFile = "jest.config.js",
          env = { DEBUG_PRINT_LIMIT = 20000 },
          cwd = function(path)
            return vim.fs.dirname(
              vim.fs.find(
                { "jest.config.js", "package.json" },
                { upward = true, stop = vim.loop.os_homedir(), path = path }
              )[1]
            )
          end,
        },
        ["neotest-vitest"] = {},
      },
    },
  },
}
