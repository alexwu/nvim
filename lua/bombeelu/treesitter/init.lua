local ts_utils = require("nvim-treesitter.ts_utils")
local parser = require("nvim-treesitter.parsers")
local ft = require("plenary.filetype")
local api = vim.api

local M = {}

local current_node_namespace = api.nvim_create_namespace("nvim-treesitter-current-node")

function M.is_supported(lang)
  local filetype = require("nvim-treesitter.parsers").ft_to_lang(lang)

  return parser.has_parser(lang) and not vim.tbl_contains(M.config.excluded_filetypes, filetype)
end

function M.init()
  -- require("nvim-treesitter").define_modules({
  --   highlight_current_node = {
  --     module_path = "bombeelu.treesitter",
  --     enable = false,
  --     disable = {},
  --     is_supported = function(lang)
  --       return parser.has_parser(lang) and lang ~= "help"
  --     end,
  --   },
  -- })
end

M.config = {
  enable = false,
  excluded_filetypes = { "help" },
}

M.enable = M.config.enable

function M.toggle(bufnr)
  if M.enable then
    M.clear_highlights(bufnr)
  end

  M.enable = not M.enable
end

M.previous_node = {}

function M.highlight_current_node(bufnr)
  if not M.enable then
    return
  end

  local current_node = ts_utils.get_node_at_cursor()

  if not current_node then
    return
  end

  local start_line = current_node:start()
  local end_line = current_node:end_()

  if M.previous_node[bufnr] then
    local prev_start_line = M.previous_node[bufnr]:start()
    local prev_end_line = M.previous_node[bufnr]:end_()

    if prev_start_line == start_line and prev_end_line == end_line then
      return
    end
  end

  M.clear_highlights(bufnr)
  M.previous_node[bufnr] = current_node

  if start_line == 0 then
    return
  end

  if end_line == start_line then
    return
  end

  if end_line - start_line > 50 then
    return
  end

  ts_utils.highlight_node(current_node, bufnr, current_node_namespace, "TSCurrentNode")
end

function M.clear_highlights(bufnr)
  if not M.enable then
    return
  end

  api.nvim_buf_clear_namespace(bufnr, current_node_namespace, 0, -1)
end

function M.attach(bufnr)
  if not M.config.enable then
    return
  end

  if vim.tbl_contains(M.config.excluded_filetypes, ft.detect(vim.api.nvim_buf_get_name(bufnr))) then
    return
  end

  vim.keymap.set("n", "gh", function()
    require("bombeelu.treesitter").toggle(bufnr)
  end, { buffer = bufnr })

  local group_name = string.format("NvimTreesitterCurrentNode_%d", bufnr)
  vim.api.nvim_create_augroup(group_name, { clear = true })

  vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    group = group_name,
    callback = function()
      require("bombeelu.treesitter").highlight_current_node(bufnr)
    end,
    buffer = bufnr,
  })

  vim.api.nvim_create_autocmd({ "BufLeave", "InsertEnter" }, {
    group = group_name,
    callback = function()
      require("bombeelu.treesitter").clear_highlights(bufnr)
    end,
    buffer = bufnr,
  })
end

function M.detach(bufnr)
  if not M.config.enable then
    return
  end

  if vim.tbl_contains(M.config.excluded_filetypes, ft.detect(vim.api.nvim_buf_get_name(bufnr))) then
    return
  end

  M.clear_highlights(bufnr)
  M.previous_node[bufnr] = nil

  local group = string.format("NvimTreesitterCurrentNode_%d", bufnr)
  vim.api.nvim_del_augroup_by_name(group)
  -- vim.api.nvim_exec_autocmds({"CursorMoved", "BufLeave" }, { group = group })

  vim.keymap.del("n", "gh", { buffer = bufnr })

  -- cmd(string.format("autocmd! NvimTreesitterCurrentNode_%d CursorMoved", bufnr))
  -- cmd(string.format("autocmd! NvimTreesitterCurrentNode_%d BufLeave", bufnr))
end

return M
