local Palette = require("bombeelu.mini-palette")
local neotest = require("neotest")

local M = {}

function M.setup()
  neotest.setup({
    adapters = {
      require("neotest-rspec"),
      require("neotest-jest")({
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
      }),
      require("neotest-rust"),
    },
    icons = {
      passed = " ✔",
      running = " ",
      failed = " ✖",
      skipped = " ﰸ",
      unknown = " ?",
      non_collapsible = "─",
      collapsed = "─",
      expanded = "╮",
      child_prefix = "├",
      final_child_prefix = "╰",
      child_indent = "│",
      final_child_indent = " ",
    },
    status = { virtual_text = true },
  })

  nvim.create_user_command("TestSummary", function()
    neotest.summary.toggle()
  end, {})

  nvim.create_user_command("TestRun", function()
    neotest.run.run()
  end, {})

  nvim.create_user_command("TestRunFile", function()
    neotest.run.run(vim.fn.expand("%"))
  end, {})

  nvim.create_user_command("TestAttach", function()
    neotest.run.attach()
  end, {})

  nvim.create_user_command("TestStop", function()
    neotest.run.stop()
  end, {})

  nvim.create_user_command("TestDebug", function()
    neotest.run.run({ strategy = "dap" })
  end, {})

  local commands = {
    {
      display = "Run nearest test",
      callback = function()
        neotest.run.run()
      end,
      repeatable = true,
    },
    {
      display = "Run all tests in current file",
      callback = function()
        neotest.run.run(vim.fn.expand("%"))
      end,
    },
    {
      display = "Debug nearest test",
      callback = function()
        neotest.run.run(vim.fn.expand("%"))
      end,
      repeatable = true,
    },
    {
      display = "Toggle test summary",
      callback = function()
        neotest.summary.toggle()
      end,
      repeatable = true,
    },
    {
      display = "Show test output",
      callback = function()
        neotest.output.open({ enter = true })
      end,
    },
  }

  key.map("[t", function()
    require("neotest").jump.prev()
  end, { modes = "n", desc = "Move to previous test" })

  key.map("]t", function()
    require("neotest").jump.next()
  end, { modes = "n", desc = "Move to next test" })

  key.map({ "<C-t>", "<Leader>t" }, function()
    Palette(commands, {
      prompt = "Select a command:",
    }):run()
  end, { modes = "n" })
end

return M
