require("impatient")
require("options")
require("mappings")
require("globals")
require("plugins")

require("snazzy").setup("dark")

require("plugins.treesitter")

-- TODO: Create autocmd group for chezmoi apply
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = os.getenv("HOME") .. "/.local/share/chezmoi/*",
  callback = function()
    vim.schedule(function()
      local Job = require("plenary.job")

      Job
        :new({
          command = "chezmoi",
          args = { "apply" },
          cwd = vim.loop.cwd(),
          on_stderr = function(_, data)
            vim.notify(data, "error")
          end,
          on_stdout = function(_, return_val)
            vim.notify(return_val)
          end,
          on_exit = function(_, _)
            vim.notify("chezmoi apply: successful")
          end,
        })
        :sync()
    end)
  end,
})
