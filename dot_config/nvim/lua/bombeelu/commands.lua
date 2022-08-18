if pcall(require, "plenary") then
local Job = require("plenary.job")
local chezmoi_apply = function()
  vim.cmd.wall()

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

nvim.create_autocmd("BufRead", {
  group = "bombeelu.autocmd",
  pattern = vim.fs.normalize("~/.local/share/chezmoi/*"),
  callback = function(o)
    nvim.buf_create_user_command(o.buf, "Chezmoi", chezmoi_apply, { nargs = 0, desc = "Runs chezmoi apply" })
  end,
})

  -- selene: allow(unscoped_variables)
  RELOAD = require("plenary.reload").reload_module

  -- selene: allow(unscoped_variables)
  R = function(name)
    RELOAD(name)
    return require(name)
  end

  nvim.create_user_command("Reload", function(opts)
    local fargs = opts.fargs
    RELOAD(fargs[1])
  end, { nargs = 1 })
end
