nvim.create_user_command("Qa", "qa", {})
nvim.create_user_command("Wq", "wq", {})
nvim.create_user_command("W", "w", {})

nvim.create_user_command("Ide", function()
  vim.cmd.Outline()
  require("neotest").summary.toggle()
end, {
  desc = "Enable all the fancy IDE features",
})

-- ============================================================================
-- PICK COMMAND (unified picker interface)
-- ============================================================================

-- Custom pickers registry (easily extensible!)
local custom_pickers = {
  { name = "files", callback = function() require("bombeelu.pickers").files() end },
  { name = "grep", callback = function() vim.cmd.Telescope("live_grep") end },
  { name = "live_grep", callback = function() vim.cmd.Telescope("live_grep") end },
  -- Add more custom pickers here:
  -- { name = "my_custom", callback = function() ... end },
}

-- Get list of available pickers
local function get_picker_names()
  local pickers = {}

  -- Add custom pickers
  for _, picker in ipairs(custom_pickers) do
    table.insert(pickers, picker.name)
  end

  -- Add Snacks pickers
  if Snacks and Snacks.picker and Snacks.picker.sources then
    for name, _ in pairs(Snacks.picker.sources) do
      table.insert(pickers, name)
    end
  end

  return pickers
end

nvim.create_user_command("Pick", function(opts)
  local picker_name = opts.args

  -- Default to files if no argument
  if picker_name == "" then
    picker_name = "files"
  end

  -- Check custom pickers first
  for _, picker in ipairs(custom_pickers) do
    if picker.name == picker_name then
      picker.callback()
      return
    end
  end

  -- Fall back to Snacks picker
  if Snacks and Snacks.picker then
    Snacks.picker(picker_name)
  else
    vim.notify("Picker not found: " .. picker_name, vim.log.levels.ERROR)
  end
end, {
  nargs = "?",
  desc = "Open picker",
  complete = function(arg_lead, _, _)
    local pickers = get_picker_names()
    return vim.tbl_filter(function(name)
      return name:find(arg_lead, 1, true) == 1
    end, pickers)
  end,
})
