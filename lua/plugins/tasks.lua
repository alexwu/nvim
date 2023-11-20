return {
  {
    "stevearc/overseer.nvim",
    opts = {
      strategy = "toggleterm",
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      -- local scripts_template = require("bombeelu.overseer.templates.bin_scripts")
      -- vim.print(scripts_template)
      -- overseer.register_template(scripts_template)
      -- overseer.load_template("bombeelu.overseer.templates.bin_scripts")
    end,
    keys = {
      {
        "<leader>o",
        function()
          require("overseer").run_template()
        end,
        desc = "Run task",
      },
    },
  },
}
