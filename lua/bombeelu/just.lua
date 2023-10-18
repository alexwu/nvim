-- local Terminal = require("toggleterm.terminal").Terminal
-- local Job = require("plenary.job")
--
-- local function enter_terminal_normal_mode()
--   nvim.feedkeys(nvim.replace_termcodes([[<C-\><C-n>]], true, false, true), "n", false)
-- end
--
local w = require("bombeelu.wezterm")
local term = require("FTerm")
local M = {}

function M.setup()
  M.setup_command()
end

M.results = vim.empty_dict()

function M.just(args)
  local cmd = vim.tbl_flatten({ "just", args })
  local bufnr = vim.api.nvim_get_current_buf()
  vim.system(cmd, { cwd = vim.loop.cwd() }, function(obj)
    -- vim.print(obj.stdout)
    local result = vim.json.decode(obj.stdout)
    local cases = vim.tbl_get(result, "rust-suites", "rubyrub-core", "testcases")
    vim.iter(cases):each(function (k, v)
      vim.print(k)
      vim.print(v)
      
    end)
    -- local lines = vim.split(obj.stdout, "\n")
    -- local messages = vim
    --   .iter(lines)
    --   :map(function(line)
    --     -- vim.print(line)
    --     local ok, result = pcall(vim.json.decode, line)
    --     if ok then
    --       -- vim.print(result)
    --       vim.print(result.type)
    --       vim.print(result.event)
    --       vim.print(result.name)
    --     end
    --   end)
    --   :totable()
    --
    -- M.results[bufnr] = messages
  end)
end

M.completion_list = nil

local on_exit = function(obj)
  if obj.code == 0 then
    M.completion_list = vim.split(obj.stdout, " ")
  end
end

function M.complete()
  if M.completion_list then
    return M.completion_list
  end

  vim.system({ "just", "--summary" }, { text = true }, on_exit):wait()

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
