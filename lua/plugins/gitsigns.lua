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
    map("n", "]c", "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", { expr = true, desc = "Next git hunk" })
    map("n", "[c", "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", { expr = true, desc = "Previous git hunk" })

    -- Actions
    map({ "n", "v" }, "gsh", gs.stage_hunk)
    map("n", "gsb", gs.stage_buffer)
    map({ "n", "v" }, "<leader>rh", gs.reset_hunk)
    map("n", "grb", gs.reset_buffer)
    map("n", "guh", gs.undo_stage_hunk)
    map("n", "gph", gs.preview_hunk)
    map("n", "M", function()
      gs.blame_line({ full = true, ignore_whitespace = true })
    end)
    map("n", "gtb", gs.toggle_current_line_blame)
    map("n", "ghd", gs.diffthis)
    map("n", "ghD", function()
      gs.diffthis("~")
    end)
    map("n", "gtd", gs.toggle_deleted)

    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
  end,
})