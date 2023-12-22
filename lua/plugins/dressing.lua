return {
  "stevearc/dressing.nvim",
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    require("dressing").setup({
      input = {
        enabled = true,
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
        get_config = function(opts)
          if opts.kind == "codeaction" then
            return {
              backend = "telescope",
              telescope = require("telescope.themes").get_cursor({
                initial_mode = "insert",
              }),
            }
          elseif opts.kind == "legendary.nvim" then
            return {
              backend = "telescope",
              telescope = {
                sorter = require("telescope.sorters").fuzzy_with_index_bias({}),
                layout_config = {
                  anchor = "N",
                  width = 0.7,
                },
              },
            }
          else
            return {}
          end
        end,
        telescope = require("telescope.themes").get_dropdown({
          initial_mode = "insert",
          layout_config = {
            height = 0.5,
          },
        }),
      },
    })
  end,
}
