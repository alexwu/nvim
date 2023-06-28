local M = {}

M.not_vscode = function()
  if vim.fn.exists("g:vscode") == 0 then
    return true
  else
    return false
  end
end

M.tree_width = function(percentage)
  percentage = percentage or 0.2
  return math.min(40, vim.fn.round(vim.o.columns * percentage))
end

return M
