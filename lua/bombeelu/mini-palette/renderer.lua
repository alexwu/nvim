local Class = require("plenary.class")

local Renderer = Class:extend()

function Renderer:new(opts)
  opts = vim.F.if_nil(opts, {})

  self.type = opts.type or "nui"
  if self.type == "nui" then
    self.inner = require("bombeelu.mini-palette.renderer.nui")(opts)
  else
  end
end

function Renderer:render()
  self.inner:render()
end

return Renderer
