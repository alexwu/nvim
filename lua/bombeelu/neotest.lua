local M = {}

function M.setup()
  local neotest = require("neotest")

  local commands = {
    last = {
      display = "Re-run last test",
      callback = function()
        neotest.run.run_last()
      end,
      repeatable = true,
    },
    nearest = {
      display = "Run nearest test",
      callback = function()
        neotest.run.run()
      end,
      repeatable = true,
    },
    debug_nearest = {
      display = "Debug nearest test",
      callback = function()
        neotest.run.run({ vim.fn.expand("%"), strategy = "dap" })
      end,
      repeatable = true,
    },
    file = {
      display = "Run all tests in current file",
      callback = function()
        neotest.run.run(vim.fn.expand("%"))
      end,
    },
    stop = {
      display = "Stop nearest test",
      callback = function()
        neotest.run.stop()
      end,
      repeatable = false,
    },
    summary = {
      display = "Toggle test summary",
      callback = function()
        neotest.summary.toggle()
      end,
      repeatable = true,
    },
    output = {
      display = "Show test output",
      callback = function()
        neotest.output.open({ enter = true })
      end,
    },
    output_panel = {
      display = "Toggle output panel",
      callback = function()
        neotest.output_panel.toggle()
      end,
    },
  }

  local command_names = vim
    .iter(commands)
    :map(function(key)
      return key
    end)
    :totable()

  nvim.create_user_command("Test", function(opts)
    local args = opts.fargs

    local arg = args[1] or "nearest"

    if commands[arg] then
      commands[arg].callback()
    else
      vim.notify("Unknown command: " .. args[1], vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    complete = function()
      return command_names
    end,
  })

  set("n", "[T", function()
    require("neotest").jump.prev()
  end, { desc = "Jump to previous test" })

  set("n", "]T", function()
    require("neotest").jump.next()
  end, { desc = "Jump to next test" })
end

return M
