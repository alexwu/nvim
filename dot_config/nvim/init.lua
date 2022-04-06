if vim.fn.has("gui_vimr") == 1 or vim.fn.exists("g:vscode") == 1 then
else
  require("impatient")
  require("plugins")

  require("snazzy").setup("dark")

  require("plugins.treesitter")
end

require("options")
require("mappings")
require("globals")

vim.api.nvim_create_augroup("chezmoi", { clear = true })

-- TODO: What happens if i'm doing :wqa
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = os.getenv("HOME") .. "/.local/share/chezmoi/*",
  group = "chezmoi",
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
