return {
  {
    "stevearc/overseer.nvim",
    opts = {
      strategy = "toggleterm",
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      local scripts_template = require("bombeelu.overseer.templates.bin_scripts")
      local chezmoi_template = require("bombeelu.overseer.templates.chezmoi")
      -- vim.print(scripts_template)
      overseer.register_template(scripts_template)
      overseer.register_template(chezmoi_template)
      -- overseer.load_template("bombeelu.overseer.templates.bin_scripts")
      vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local overseer = require("overseer")
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end, {})
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
