return {
  {
    "chrisgrieser/nvim-tinygit",
    dependencies = { "stevearc/dressing.nvim" },
    config = function()
      require("legendary").command({
        ":Commit",
        function(_o)
          require("tinygit").smartCommit({ push = false })
        end,
        description = "Commit staged changes or all diffs",
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup({
        debug_mode = false,
        sign_priority = 6,
        attach_to_untracked = true,
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = false,
          virt_text_pos = "eol",
          delay = 500,
        },
        preview_config = { border = "rounded" },
        current_line_blame_formatter_opts = { relative_time = true },
        current_line_blame_formatter = function(name, blame_info, opts)
          if blame_info.author == name then
            blame_info.author = "You"
          end

          local text
          if blame_info.author == "Not Committed Yet" then
            text = blame_info.author
          else
            local date_time

            if opts.relative_time then
              date_time = require("gitsigns.util").get_relative_time(tonumber(blame_info["author_time"]))
            else
              date_time = os.date("%m/%d/%Y", tonumber(blame_info["author_time"]))
            end

            text = string.format("%s, %s • %s", blame_info.author, date_time, blame_info.summary)
          end

          return { { " " .. text, "GitSignsCurrentLineBlame" } }
        end,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Actions
          local keymap = require("legendary").keymap
          local keymaps = require("legendary").keymaps

          keymaps({
            {
              "gssh",
              gs.stage_hunk,
              -- itemgroup = "Git",
              description = "Stage hunk",
              opts = { desc = "Stage Git hunk", buffer = bufnr },
            },
            {
              "gsrh",
              gs.reset_hunk,
              -- itemgroup = "Git",
              description = "Reset Git hunk",
              mode = { "n", "v" },
              opts = {
                buffer = bufnr,
              },
            },
            {
              "gsuh",
              gs.undo_stage_hunk,
              -- itemgroup = "Git",
              description = "Undo stage Git hunk",
              mode = { "n" },
              opts = { buffer = bufnr },
            },
            {
              "gssb",
              gs.stage_buffer,
              -- itemgroup = "Git",
              description = "Stage Git buffer",
              mode = { "n" },
              opts = { buffer = bufnr },
            },
            {
              "gsrb",
              gs.reset_buffer,
              -- itemgroup = "Git",
              description = "Reset Git buffer",
              mode = { "n" },
              opts = { buffer = bufnr },
            },
            {
              "gM",
              function()
                gs.blame_line({ full = true, ignore_whitespace = true })
              end,
              -- itemgroup = "Git",
              description = "Show Git blame",
              opts = { desc = "Show Git blame", buffer = bufnr },
            },
            {
              "]c",
              function()
                if vim.wo.diff then
                  return "]c"
                end
                vim.schedule(function()
                  gs.next_hunk({ navigation_message = false, preview = false })
                end)
                return "<Ignore>"
              end,
              -- itemgroup = "Git",
              description = "Next Git hunk",
              opts = { desc = "Next Git hunk", buffer = bufnr, expr = true },
            },
            {
              "[c",
              function()
                if vim.wo.diff then
                  return "[c"
                end
                vim.schedule(function()
                  gs.prev_hunk({ navigation_message = false, preview = false })
                end)
                return "<Ignore>"
              end,
              -- itemgroup = "Git",
              description = "Previous Git hunk",
              opts = { desc = "Previous Git hunk", buffer = bufnr, expr = true },
            },
            {
              "M",
              function()
                gs.preview_hunk()
              end,
              -- itemgroup = "Git",
              description = "Preview Git hunk",
              opts = { desc = "Preview Git hunk", buffer = bufnr },
            },
          })

          -- keymap({ "gssh", gs.stage_hunk, description = "Stage hunk", opts = { desc = "Stage Git hunk", buffer = bufnr } })
          -- map({ "n", "v" }, "gsrh", gs.reset_hunk, { desc = "Reset Git hunk" })
          -- keymap({ "gsrh", gs.reset_hunk, description = "Reset Git hunk", mode = { "n", "v" }, opts = { buffer = bufnr } })
          -- keymap({
          --   "gsuh",
          --   gs.undo_stage_hunk,
          --   description = "Undo stage Git hunk",
          --   mode = { "n" },
          --   opts = { buffer = bufnr },
          -- })
          -- map("n", "gsuh", gs.undo_stage_hunk, { desc = "Undo stage Git hunk" })

          -- keymap({ "gssb", gs.stage_buffer, description = "Stage Git buffer", mode = { "n" } })
          -- keymap({ "gsrb", gs.reset_buffer, description = "Reset Git buffer", mode = { "n" } })

          -- map("n", "gM", function()
          --   gs.blame_line({ full = true, ignore_whitespace = true })
          -- end, { desc = "Show Git blame" })
          -- map("n", "gsdh", gs.diffthis, { desc = "Git diff" })
          -- map("n", "ghD", function()
          --   gs.diffthis("~")
          -- end)

          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Inner Git hunk" })
        end,
      })
    end,
  },
}
