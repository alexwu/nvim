local files = require("overseer.files")

return {
  name = "chezmoi apply",
  condition = {
    dir = "~/.local/share/chezmoi/",
  },
  builder = function()
    return {
      cmd = { "chezmoi" },
      args = { "apply" },
      name = "chezmoi apply",
    }
  end,
}
