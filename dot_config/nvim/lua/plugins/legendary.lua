local M = {}

M.setup = function()
  local legendary = require("legendary")

  legendary.setup({
    include_builtin = true,
    include_legendary_cmds = true,
    -- Customize the prompt that appears on your vim.ui.select() handler
    -- Can be a string or a function that takes the `kind` and returns
    -- a string. See "Item Kinds" below for details. By default,
    -- prompt is 'Legendary' when searching all items,
    -- 'Legendary Keymaps' when searching keymaps,
    -- 'Legendary Commands' when searching commands,
    -- and 'Legendary Autocmds' when searching autocmds.
    select_prompt = nil,
    -- Optionally pass a custom formatter function. This function
    -- receives the item as a parameter and must return a table of
    -- non-nil string values for display. It must return the same
    -- number of values for each item to work correctly.
    -- The values will be used as column values when formatted.
    -- See function `get_default_format_values(item)` in
    -- `lua/legendary/formatter.lua` to see default implementation.
    formatter = nil,
    most_recent_item_at_top = true,
    -- Initial keymaps to bind

    keymaps = {
      -- your keymap tables here
    },
    -- Initial commands to bind
    commands = {
      -- your command tables here
    },
    -- Initial augroups and autocmds to bind
    autocmds = {
      -- your autocmd tables here
    },
    auto_register_which_key = false,
    scratchpad = {
      -- configure how to show results of evaluated Lua code,
      -- either 'print' or 'float'
      -- Pressing q or <ESC> will close the float
      display_results = "float",
    },
  })

  vim.keymap.set("n", "<Leader>k", function()
    legendary.find()
  end)
end

return M
