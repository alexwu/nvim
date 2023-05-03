local function init()
  local keymaps = require("neo-tree").config.mappings.get_keymap()
  local commands = require("nvim-tree.api").commands.get()
  local legendary_keymaps = vim.tbl_map(function(keymap)
    return {
      keymap.lhs,
      description = keymap.desc,
      mode = keymap.mode,
      filters = { filetype = "NvimTree" },
    }
  end, keymaps)
  local legendary_commands = vim.tbl_map(function(cmd)
    return {
      cmd.name,
      description = cmd.opts.desc,
    }
  end, commands)
  require("legendary").keymaps(legendary_keymaps)
  require("legendary").commands(legendary_commands)
end

return function()
  if vim.g.NvimTreeRequired and vim.g.NvimTreeSetup then
    init()
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "NeotreeSetup",
      callback = init,
      once = true,
    })
  end
end
