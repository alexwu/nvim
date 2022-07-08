local reload = require("plenary.reload")
local Job = require("plenary.job")
local chezmoi_apply = function()
  nvim.ex.wall()

  Job:new({
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
  }):start()
end

nvim.create_user_command("Chezmoi", chezmoi_apply, { nargs = 0, desc = "Runs chezmoi apply" })

nvim.create_user_command("Reload", function(opts)
  local fargs = opts.fargs
  reload.reload_module(fargs[1])
end, { nargs = 1 })
