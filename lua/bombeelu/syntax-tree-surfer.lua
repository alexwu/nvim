local M = {}

function M.setup(opts)
  local o = opts or {}
  local cond = vim.F.if_nil(o.cond or true)

  if cond then
    require("syntax-tree-surfer").setup()
    vim.keymap.set("n", "vU", function()
      vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
      return "g@l"
    end, { silent = true, expr = true })
    vim.keymap.set("n", "vD", function()
      vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
      return "g@l"
    end, { silent = true, expr = true })

    vim.keymap.set("n", "vd", function()
      vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
      return "g@l"
    end, { silent = true, expr = true })
    vim.keymap.set("n", "vu", function()
      vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
      return "g@l"
    end, { silent = true, expr = true })
  end
end

return M
