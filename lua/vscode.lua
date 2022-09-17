local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap =
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

return require("packer").startup(function(use)
  use({ "tpope/vim-repeat" })

  use({
    "phaazon/hop.nvim",
    requires = { "indianboy42/hop-extensions", "nvim-telescope/telescope.nvim" },
    config = function()
      require("plugins.hop")
    end,
  })

  use({
    "kylechui/nvim-surround",
    config = function()
      require("nvim-surround").setup({})
    end,
  })

  use({
    "monaqa/dial.nvim",
    config = function()
      require("plugins.dial")
    end,
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end, {
  compile_path = require("packer.util").join_paths(vim.fn.stdpath("config"), "plugin", "packer_vscode_compiled.lua"),
})
