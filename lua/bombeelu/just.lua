local Terminal = require("toggleterm.terminal").Terminal
local Job = require("plenary.job")

local function enter_terminal_normal_mode()
  nvim.feedkeys(nvim.replace_termcodes([[<C-\><C-n>]], true, false, true), "n", false)
end

local M = {}

function M.setup()
  M.setup_command()
end

function M.just(args)
  Terminal:new({
    cmd = table.concat(vim.tbl_flatten({ "just", args }), " "),
    hidden = false,
    start_in_insert = false,
    on_open = function()
      enter_terminal_normal_mode()
    end,
  }):toggle()
end

M.completion_list = nil
function M.complete()
  if M.completion_list then
    return M.completion_list
  end

  Job:new({
    command = "just",
    args = { "--summary" },
    on_exit = function(j, code)
      if code == 0 then
        M.completion_list = vim.split(j:result()[1], " ")
      end
    end,
  }):sync()

  if not M.completion_list then
    return {}
  end

  return M.completion_list
end

function M.setup_command()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_create_user_command("Just", function(o)
    M.just(o.fargs)
  end, {
    complete = function()
      return M.complete()
    end,
    nargs = "*",
  })
end

return M
