local Menu = require("nui.menu")
local event = require("nui.utils.autocmd").event
local Class = require("plenary.class")

local default_popup_options = {
  relative = "cursor",
  position = {
    row = 1,
    col = 0,
  },
  border = {
    style = "rounded",
    text = {
      top = " Select a command: ",
      top_align = "center",
    },
    padding = {
      left = 1,
    },
  },
  win_options = {
    winblend = 10,
    winhighlight = "Normal:Normal,FloatBorder:Normal",
  },
  -- bufnr = 1,
}

local Nui = Class:extend()

function Nui:new(opts)
  opts = vim.F.if_nil(opts, {})
  local items = vim.F.if_nil(opts.items, {})

  local winnr = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(winnr)

  local lines = {}
  for _, command in ipairs(items) do
    table.insert(
      lines,
      Menu.item(command.display, {
        callback = command.callback,
      })
    )
  end

  self.menu = Menu(default_popup_options, {
    lines = lines,
    keymap = {
      focus_next = { "j", "<Down>", "<C-n>" },
      focus_prev = { "k", "<Up>", "<C-p>" },
      close = { "<Esc>", "<C-c>", "q" },
      submit = { "<CR>", "<Space>" },
    },
    min_width = 40,
    max_width = 80,
    on_submit = function(item)
      if item.callback then
        vim.api.nvim_win_set_cursor(winnr, cursor_pos)
        item.callback()
      end
    end,
  })

  self.menu:on({ event.BufLeave }, function()
    self.menu:unmount()
  end, { once = true })

  self.menu:map("n", "<Tab>", function(bufnr)
    require("hop").hint_lines()
  end, { noremap = true })
end

function Nui:render()
  self.menu:mount()
end

return Nui
