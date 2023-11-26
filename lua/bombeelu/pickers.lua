local M = {}

function M.config_files()
  local config = vim.system({ "chezmoi", "source-path", "~/.config/nvim" }, { text = true }):wait()

  local cwd = string.gsub(config.stdout, "\n", "")

  require("nucleo").find({ cwd = cwd })
end

return M
