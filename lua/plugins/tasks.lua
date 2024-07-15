return {
  {
    "stevearc/overseer.nvim",
    opts = {
      strategy = {
        "toggleterm",
        open_on_start = false,
      },
    },
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
    },
    config = function(_, opts)
      local overseer = require("overseer")
      overseer.setup(opts)

      local scripts_template = require("bombeelu.overseer.templates.bin_scripts")
      -- TODO: Make more of these chezmoi actions
      local chezmoi_template = require("bombeelu.overseer.templates.chezmoi")
      overseer.register_template(scripts_template)
      overseer.register_template(chezmoi_template)
      -- overseer.load_template("bombeelu.overseer.templates.bin_scripts")
      vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
          vim.notify("No tasks found", vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], "restart")
        end
      end, {})

      -- Automatically preload templates for the current directory
      vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
        group = bu.nvim.augroup("bombeelu.overseer"),
        callback = function()
          local cwd = vim.uv.cwd()
          require("overseer").preload_task_cache({ dir = cwd })
        end,
      })
    end,
    -- keys = {
    --   {
    --     "<leader>o",
    --     function()
    --       require("overseer").run_template()
    --     end,
    --     desc = "Run task",
    --   },
    -- },
    keys = {
      { "<leader>ow", "<cmd>OverseerToggle<cr>", desc = "Task list" },
      { "<leader>oo", "<cmd>OverseerRun<cr>", desc = "Run task" },
      { "<leader>oq", "<cmd>OverseerQuickAction<cr>", desc = "Action recent task" },
      { "<leader>oi", "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>", desc = "Task builder" },
      { "<leader>ot", "<cmd>OverseerTaskAction<cr>", desc = "Task action" },
      { "<leader>oc", "<cmd>OverseerClearCache<cr>", desc = "Clear cache" },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    opts = function(_, opts)
      opts = opts or {}
      opts.consumers = opts.consumers or {}
      opts.consumers.overseer = require("neotest.consumers.overseer")
    end,
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      require("overseer").enable_dap()
    end,
  },
}
