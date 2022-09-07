local Palette = require("bombeelu.mini-palette")

local M = {}

function M.setup()
  local dap_breakpoint = {
    breakpoint = {
      text = " ",
      texthl = "DiagnosticSignError",
      linehl = "",
      numhl = "",
    },
    -- stopped = {
    --   text = "",
    --   texthl = "DiagnosticsSignHint",
    --   linehl = "",
    --   numhl = "",
    -- },
    rejected = {
      text = "⭐️",
      texthl = "DiagnosticSignInfo",
      linehl = "DiagnosticUnderlineInfo",
      numhl = "DiagnosticSignInfo",
    },
  }

  vim.fn.sign_define("DapBreakpoint", dap_breakpoint.breakpoint)
  -- vim.fn.sign_define("DapStopped", dap_breakpoint.stopped)
  vim.fn.sign_define("DapBreakpointRejected", dap_breakpoint.rejected)

  require("dapui").setup()
  require("nvim-dap-virtual-text").setup()
  require("dap-vscode-js").setup({
    -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
    -- debugger_path = vim.fs.normalize("~/.local/share/nvim/site/pack/packer/start/nvim-dap-vscode-js"), -- Path to vscode-js-debug installation.
    adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
  })

  vim.keymap.set("n", "gb", function()
    require("dap").toggle_breakpoint()
  end)
end

function M.setup_keymaps()
  -- set("n", "", function()
  --   require("dap").step_back()
  -- end, { desc = "Step Back" })
  --
  -- set("n", "", function()
  --   require("dap").step_out()
  -- end, { desc = "Step Out" })
  --
  -- set("n", "", function()
  --   require("dap").step_out()
  -- end, { desc = "Step Out" })
end
-- R = { "<cmd>lua require'dap'.run_to_cursor()<cr>", "Run to Cursor" },
--     E = { "<cmd>lua require'dapui'.eval(vim.fn.input '[Expression] > ')<cr>", "Evaluate Input" },
--     C = { "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", "Conditional Breakpoint" },
--     U = { "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI" },
--     c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
--     d = { "<cmd>lua require'dap'.disconnect()<cr>", "Disconnect" },
--     e = { "<cmd>lua require'dapui'.eval()<cr>", "Evaluate" },
--     g = { "<cmd>lua require'dap'.session()<cr>", "Get Session" },
--     h = { "<cmd>lua require'dap.ui.widgets'.hover()<cr>", "Hover Variables" },
--     S = { "<cmd>lua require'dap.ui.widgets'.scopes()<cr>", "Scopes" },
--     i = { "<cmd>lua require'dap'.step_into()<cr>", "Step Into" },
--     o = { "<cmd>lua require'dap'.step_over()<cr>", "Step Over" },
--     p = { "<cmd>lua require'dap'.pause.toggle()<cr>", "Pause" },
--     q = { "<cmd>lua require'dap'.close()<cr>", "Quit" },
--     r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Toggle Repl" },
--     s = { "<cmd>lua require'dap'.continue()<cr>", "Start" },
--     t = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Toggle Breakpoint" },
--     x = { "<cmd>lua require'dap'.terminate()<cr>", "Terminate" },
--     u = { "<cmd>lua require'dap'.step_out()<cr>", "Step Out" },

return M
