local neotest = require("neotest")

local M = {}

function M.setup()
  neotest.setup({
    adapters = {
      require("neotest-plenary"),
      require("neotest-vim-test")({
        ignore_file_types = { "python", "vim", "lua", "ts", "tsx", "rb", "go" },
      }),
      require("neotest-rspec"),
      require("neotest-jest"),
      require("neotest-go"),
    },
  })

  nvim.create_user_command("TestToggle", function()
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
end

return M
