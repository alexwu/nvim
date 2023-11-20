local M = {}

function M.config_files()
---@diagnostic disable-next-line: undefined-field
  local config = vim.system({ "chezmoi", "source-path", "~/.config/nvim" }, { text = true }):wait()

  local cwd = string.gsub(config.stdout, "\n", "")

  require("telescope.builtin").find_files({ prompt_title = "nvim dotfiles", cwd = cwd })
end

return M
