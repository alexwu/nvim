local Class = require("plenary.class")
local mk_repeatable = require("bombeelu.repeat").mk_repeatable

---@type Palette
local Palette = Class:extend()

function Palette:new(commands, opts)
  opts = vim.F.if_nil(opts, {})

  self.command_list = commands
  self.prompt = opts.prompt or "Select a command:"
end

function Palette:gen_commands()
  local commands = {}

  for _, command in ipairs(self.command_list) do
    local cond = command.cond or function()
      return true
    end
    local repeatable = vim.F.if_nil(command.repeatable, false)

    local callback = command.callback
    if repeatable then
      callback = mk_repeatable(command.callback)
    end

    if cond() then
      local display = command.display
      if vim.is_callable(display) then
        display = display()
      end

      table.insert(commands, {
        display = display,
        callback = callback,
      })
    end
  end

  return commands
end

function Palette:run()
  local winnr = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(winnr)

  vim.ui.select(self:gen_commands(), {
    prompt = self.prompt,
    format_item = function(item)
      return item.display
    end,
  }, function(choice)
    if choice then
      vim.api.nvim_win_set_cursor(winnr, cursor_pos)
      choice.callback()
    end
  end)
end

function Palette:extend(commands)
  self.command_list = vim.tbl_deep_extend("force", self.command_list, commands)
end

return Palette
