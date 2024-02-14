local tinygit = require("tinygit")
local gs = require("gitsigns")
local L = require("legendary")

local M = {}

local function complete(arglead, cmdline, _cursorpos)
  local leading = vim.trim(arglead)
  if vim.trim(cmdline) == "G" and leading == "" then
    return { "commit" }
  end
end

function M.git(fargs)
  local cmd = fargs[1]

  if vim.tbl_isempty(fargs) or cmd == "commit" then
    M.commit()
  elseif cmd == "stage" then
    M.stage("hunk")
  elseif cmd == "push" then
    require("tinygit").push()
  end
end

function M.commit()
  tinygit.smartCommit({ push = false })
end

function M.stage(arg)
  if arg == "hunk" then
    gs.stage_hunk()
  end
end

function M.attach(bufnr)
  L.command({
    ":G",
    function(o)
      local fargs = o.fargs

      M.git(fargs)
    end,
    description = "Git commands",
    opts = {
      bang = true,
      nargs = "*",
      complete = complete,
      bufnr = bufnr,
    },
  })
end
