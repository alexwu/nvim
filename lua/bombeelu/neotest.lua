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
    status = { virtual_text = false },
  })

  nvim.create_user_command("TestSummary", function()
    neotest.summary.toggle()
  end, {})

  -- nvim.create_user_command("TestAttach", function()
  --   neotest.run.attach()
  -- end, {})

  nvim.create_user_command("TestStop", function()
    neotest.run.stop()
  end, {})

  local commands = {
    -- {
    --   display = "Run last run test",
    --   callback = function()
    --     neotest.run.run_last()
    --   end,
    --   repeatable = true,
    -- },
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
        -- neotest.run.run({ strategy = "dap" })
        neotest.run.run({ vim.fn.expand("%"), strategy = "dap" })
      end,
      repeatable = true,
    },
    {
      display = "Stop nearest test",
      callback = function()
        neotest.run.stop()
      end,
      repeatable = false,
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

  -- nvim.create_user_command("TestDebug", function()
  --   neotest.run.run({ strategy = "dap" })
  -- end, {})

  nvim.create_user_command("Test", function(opts)
    local args = opts.fargs

    if vim.tbl_isempty(args) then
      Palette(commands, {
        prompt = "Select a command:",
      }):run()
    elseif args[1] == "summary" then
      neotest.summary.toggle()
    elseif args[1] == "nearest" then
      neotest.run.run()
    elseif args[1] == "file" then
      neotest.run.run(vim.fn.expand("%"))
    elseif args[1] == "last" then
      neotest.run.run_last()
    else
      vim.notify("Unknown command: " .. args[1], vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    complete = function()
      return { "nearest", "file", "summry", "last" }
    end,
  })

  key.map("[t", function()
    require("neotest").jump.prev()
  end, { modes = "n", desc = "Move to previous test" })

  key.map("]t", function()
    require("neotest").jump.next()
  end, { modes = "n", desc = "Move to next test" })

  key.map({ "<Leader>t" }, function()
    Palette(commands, {
      prompt = "Select a command:",
    }):run()
  end, { modes = "n" })
end

return M
