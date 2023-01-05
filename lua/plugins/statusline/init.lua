local M = {}

local theme = {
  bg = "#282a36",
  fg = "#eff0eb",
  black = "#282a36",
  red = "#ff5c57",
  green = "#5af78e",
  yellow = "#f3f99d",
  skyblue = "#57c7ff",
  purple = "#ff6ac1",
  cyan = "#9aedfe",
  white = "#f1f1f0",
  orange = "#FF9F43",
  violet = "#A39DF9",
  magenta = "#ff6ac1",
}

function M.setup(provider)
  if provider == "feline" then
    require("statusline.feline").setup({ theme = theme })
  else
    require("statusline.lualine")
  end
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
    { "SmiteshP/nvim-gps", dependencies = "nvim-treesitter/nvim-treesitter" },
    "SmiteshP/nvim-navic",
  },
  config = function()
    M.setup("lualine")
  end,
}
