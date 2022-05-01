require("globals")

local ok, tealmaker = pcall(require, "tealmaker")
if ok then
  tealmaker.build_all()
end

if vim.fn.has("gui_vimr") == 1 or vim.fn.exists("g:vscode") == 1 then
  require("snazzy").setup({ theme = "dark", transparent = false })
else
  require("impatient")
  require("plugins")

  local transparent = vim.env.TERM_PROGRAM == "WezTerm" or vim.env.TERM_PROGRAM == "iTerm.app"
  require("snazzy").setup({ theme = "dark", transparent = transparent })

  require("plugins.treesitter")
end

if vim.g.neovide then
  require("neovide")
end

require("options")
require("mappings")

local chezmoi_apply = function()
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
    :start()
end

vim.api.nvim_create_user_command("Chezmoi", chezmoi_apply, { nargs = 0, desc = "Runs chezmoi apply" })
