local M = {}
local fn = vim.fn

---@param install_path string
---@return boolean
M.install_packer = function(install_path)
  return fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
end

---@param install_path string
---@return boolean
M.needs_packer = function(install_path)
  return fn.empty(fn.glob(install_path)) > 0
end

M.tree_width = function(percentage)
  percentage = percentage or 0.2
  return math.min(40, vim.fn.round(vim.o.columns * percentage))
  -- return 40
end

return M
