local ex = require("bombeelu.utils").ex
local set = require("bombeelu.utils").set

local function prettier()
  return {
    exe = "prettier",
    args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
    stdin = true,
  }
end

local function rubocop()
  return {
    exe = "bundle exec rubocop",
    args = {
      "--auto-correct",
      "--stdin",
      "%:p",
      "2>/dev/null",
      "|",
      "awk 'f; /^====================$/{f=1}'",
    },
    stdin = true,
  }
end

local function rubyfmt()
  return {
    exe = "rubyfmt",
    args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
    stdin = false,
  }
end

local function rufo()
  return {
    exe = "rufo",
    args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
    stdin = false,
  }
end

local function stylua()
  return {
    exe = "stylua",
    args = {
      "-",
    },
    stdin = true,
  }
end

local function rustfmt()
  return { exe = "rustfmt", args = { "--emit=stdout", "--edition=2021" }, stdin = true }
end

local function gofmt()
  return { exe = "gofmt", args = { "-s" }, stdin = true }
end

local function black()
  return { exe = "black", args = {}, stdin = true }
end

require("formatter").setup({
  logging = false,
  filetype = {
    typescript = { prettier },
    typescriptreact = { prettier },
    javascript = { prettier },
    javascriptreact = { prettier },
    go = { gofmt },
    graphql = { prettier },
    json = { prettier },
    jsonc = { prettier },
    html = { prettier },
    css = { prettier },
    ruby = { rubyfmt },
    rust = { rustfmt },
    lua = { stylua },
    python = { black },
  },
})

-- set({ "n", "v" }, { "<F8>", "<Leader>y", "gy" }, ex("Format"), { silent = true })
