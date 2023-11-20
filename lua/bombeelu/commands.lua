-- selene: allow(unscoped_variables)
RELOAD = require("plenary.reload").reload_module

-- selene: allow(unscoped_variables)
-- selene: allow(unused_variable)
R = function(name)
  RELOAD(name)
  return require(name)
end

nvim.create_user_command("Reload", function(opts)
  local fargs = opts.fargs
  RELOAD(fargs[1])
end, { nargs = 1 })

nvim.create_user_command("Qa", "qa", {})
nvim.create_user_command("Wq", "wq", {})
nvim.create_user_command("W", "w", {})
