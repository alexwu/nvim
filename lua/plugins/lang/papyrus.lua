return {
  {
    "mkusm/nvim-papyrus",
    cond = function()
      return vim.uv.os_uname().version:match("Windows")
    end,
    lazy = false,
    config = function()
      vim.g.skyrim_install_path = vim.env.Skyrim64Path
    end,
  },
}
