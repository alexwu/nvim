local Class = require("plenary.class")

local config = {
  lua = {
    lsp = {
      handlers = {
        hover = "sumneko_lua",
        diagnostics = { "sumneko_lua", "null-ls" },
        go_to_definition = "sumneko_lua",
      },
    },
  },
}

local Project = Class:extend()

function Project:new(o)
  self.ft = o.ft
end

function Project:resolve_project()
  local ok, project = pcall(string.format("bombeelu.projects.%s", self.ft))
  if not ok then
    error(string.format("Could not find project for %s", self.ft))
  end

  return project
end

function Project:attach(opts) end
function Project:should_attach(opts) end
function Project:format(opts) end
function Project:code_action(opts) end

return Project
