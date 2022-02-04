local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"
local gem = require "nvim-lsp-installer.installers.gem"
local servers = require "nvim-lsp-installer.servers"
local server = require "nvim-lsp-installer.server"
local path = require "nvim-lsp-installer.path"
local util = lspconfig.util

if not configs["rubocop-lsp"] then
  configs["rubocop-lsp"] = {
    default_config = {
      cmd = { "rubocop-lsp" },
      filetypes = { "ruby" },
      root_dir = util.root_pattern(".rubocop.yml", "Gemfile"),
    },
  }
end

local root_dir = server.get_server_root_path "rubocop-lsp"

local rubocop_server = server.Server:new {
  name = "rubocop-lsp",
  root_dir = root_dir,
  installer = gem.packages { "rubocop-lsp" },
  default_options = {
    cmd = { path.concat { root_dir, "bin", "rubocop-lsp" } },
  },
}

servers.register(rubocop_server)
