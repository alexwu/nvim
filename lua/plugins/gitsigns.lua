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

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        return "]c"
      end
      vim.schedule(function()
        gs.next_hunk({ navigation_message = false, preview = false })
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Next Git hunk" })

    map("n", "[c", function()
      if vim.wo.diff then
        return "[c"
      end
      vim.schedule(function()
        gs.prev_hunk({ navigation_message = false, preview = false })
      end)
      return "<Ignore>"
    end, { expr = true, desc = "Previous Git hunk" })

    -- Actions
    map({ "n", "v" }, "gsh", gs.stage_hunk, { desc = "Stage Git hunk" })
    map({ "n", "v" }, "gsrh", gs.reset_hunk, { desc = "Reset Git hunk" })
    map("n", "gsuh", gs.undo_stage_hunk, { desc = "Undo stage Git hunk" })

    map("n", "gsb", gs.stage_buffer, { desc = "Stage Git buffer" })
    map("n", "gsrb", gs.reset_buffer, { desc = "Reset Git buffer" })

    map("n", "gsph", gs.preview_hunk, { desc = "Preview Git hunk" })
    map("n", "M", function()
      gs.preview_hunk()
    end, { desc = "Preview git hunk" })
    map("n", "gM", function()
      gs.blame_line({ full = true, ignore_whitespace = true })
    end, { desc = "Show Git blame" })
    map("n", "gsdh", gs.diffthis, { desc = "Git diff" })
    map("n", "ghD", function()
      gs.diffthis("~")
    end)

    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Inner Git hunk" })
  end,
})
