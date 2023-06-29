local M = {}

function M.setup()
  require("legendary").setup({
    include_legendary_cmds = false,
    select_prompt = "Command Palette",
    extensions = {
      smart_splits = true,
      diffview = true,
    },
    lazy_nvim = { auto_register = true },
  })

  require("legendary").keymaps({
    {
      "<C-S-p>",
      function()
        require("legendary").find({
          filters = { require("legendary.filters").current_mode() },
          formatter = function(item, mode)
            local values = require("legendary.ui.format").default_format(item)
            if require("legendary.toolbox").is_keymap(item) then
              values[1] = mode
            end
            return values
          end,
        })
      end,
      description = "Find keymaps and commands",
      mode = { "n", "v", "i" },
    },
  })
end

return M
