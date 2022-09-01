local ts_utils = require("nvim-treesitter.ts_utils")
local parser = require("nvim-treesitter.parsers")
local api = vim.api

local M = {}

local current_node_namespace = api.nvim_create_namespace("nvim-treesitter-current-node")

function M.init()
  require("nvim-treesitter").define_modules({
    highlight_current_scope = {
      module_path = "bombeelu.treesitter",
      enable = false,
      disable = {},
      is_supported = parser.has_parser,
    },
  })
end


-- TODO: Set this equal to the config value
M.enable = false

function M.toggle(bufnr)
  if M.enable then
    M.clear_highlights(bufnr)
  end

  M.enable = not M.enable
end

function M.highlight_current_node(bufnr)
  if not M.enable then
    return
  end

  M.clear_highlights(bufnr)

  local current_node = ts_utils.get_node_at_cursor()

  if current_node then
    local start_line = current_node:start()

    if start_line ~= 0 then
      ts_utils.highlight_node(current_node, bufnr, current_node_namespace, "TSCurrentNode")
    end
  end
end

function M.clear_highlights(bufnr)
  if not M.enable then
    return
  end

  api.nvim_buf_clear_namespace(bufnr, current_node_namespace, 0, -1)
end

function M.attach(bufnr)
  vim.keymap.set("n", "gh", function()
    require("bombeelu.treesitter").toggle(bufnr)
  end, { buffer = bufnr })

  local group_name = string.format("NvimTreesitterCurrentNode_%d", bufnr)
  vim.api.nvim_create_augroup(group_name, { clear = true })

  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    group = group_name,
    callback = function()
      require("bombeelu.treesitter").highlight_current_node(bufnr)
    end,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter", "CursorMoved" }, {
    group = group_name,
    callback = function()
      require("bombeelu.treesitter").clear_highlights(bufnr)
    end,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    group = group_name,
    callback = function()
      require("bombeelu.treesitter").clear_highlights(bufnr)
    end,
    buffer = bufnr,
  })
end

function M.detach(bufnr)
  M.clear_highlights(bufnr)

  local group = string.format("NvimTreesitterCurrentNode_%d", bufnr)
  vim.api.nvim_del_augroup_by_name(group)
  -- vim.api.nvim_exec_autocmds({"CursorMoved", "BufLeave" }, { group = group })

  vim.keymap.del("n", "gh", { buffer = bufnr })

  -- cmd(string.format("autocmd! NvimTreesitterCurrentNode_%d CursorMoved", bufnr))
  -- cmd(string.format("autocmd! NvimTreesitterCurrentNode_%d BufLeave", bufnr))
end

return M
