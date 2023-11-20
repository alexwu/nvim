local utils = require("bombeelu.utils")
local lazy = utils.lazy
local set = utils.set
local ex = utils.ex
local augroup = bu.nvim.augroup

nvim.create_autocmd("FileType", {
  pattern = "qf",
  group = augroup("quickfix"),
  callback = function()
    set("n", "<CR>", "<CR>" .. ex("cclose"), { buffer = true })
    set("n", "<ESC>", lazy(vim.cmd.cclose), { buffer = true })
  end,
})

nvim.create_autocmd({ "FileType", "DirChanged" }, {
  pattern = "help",
  group = augroup("help"),
  callback = function()
    set("n", "gd", "<C-]>", { buffer = true })
  end,
})

nvim.create_autocmd({ "BufEnter" }, {
  pattern = "*",
  group = augroup("formatoptions"),
  callback = function()
    vim.opt.formatoptions:remove({ "c", "o", "r" })
  end,
})

-- Credit: https://github.com/LazyVim/LazyVim/blob/68ff818a5bb7549f90b05e412b76fe448f605ffb/lua/lazyvim/config/autocmds.lua#L52
nvim.create_autocmd("FileType", {
  group = augroup("q_for_quit"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- resize splits if window got resized
nvim.create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

local ok, Job = pcall(require, "plenary.job")
if not ok then
  return
end

local notify_ok, notify = pcall(require, "notify")
if not notify_ok then
  return
end

local chezmoi_apply = function()
  vim.cmd.wall()

  Job:new({
    command = "chezmoi",
    args = { "apply" },
    cwd = vim.loop.cwd(),
    on_stderr = function(_, data)
      notify(data, "error")
    end,
    on_stdout = function(_, return_val)
      notify(return_val)
    end,
    on_exit = function(_, _)
      notify("chezmoi apply: successful")
    end,
  }):start()
end

nvim.create_autocmd("BufRead", {
  group = augroup("chezmoi"),
  pattern = vim.fs.normalize("~/.local/share/chezmoi/*"),
  callback = function(o)
    -- require("legendary").command(o.buf, ":Chezmoi", chezmoi_apply, { nargs = 0, desc = "Runs chezmoi apply" })
    nvim.buf_create_user_command(o.buf, "Chezmoi", chezmoi_apply, { nargs = 0, desc = "Runs chezmoi apply" })
  end,
})
