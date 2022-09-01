local M = {}

M.pinned_win = nil

function M.pin()
  local bufnr = vim.api.nvim_get_current_buf()

  if M.pinned_win then
    M.unpin()
  end

  local win = vim.api.nvim_open_win(bufnr, false, {
    relative = "win",
    row = 0,
    col = vim.o.columns - 1,
    win = 0,
    width = 80,
    height = 25,
    style = "minimal",
    border = "rounded",
    noautocmd = true,
  })

  M.pinned_win = { win = win, bufnr = bufnr }
end

function M.unpin()
  if M.pinned_win and vim.api.nvim_win_is_valid(M.pinned_win.win) then
    vim.api.nvim_win_close(M.pinned_win.win, true)
    M.pinned_win = nil
  end
end

function M.show()
  if M.pinned_win and vim.api.nvim_buf_is_loaded(M.pinned_win.bufnr) then
    local win = vim.api.nvim_open_win(M.pinned_win.bufnr, false, {
      relative = "win",
      row = 0,
      col = vim.o.columns - 1,
      win = 0,
      width = 80,
      height = 25,
      style = "minimal",
      border = "rounded",
      noautocmd = true,
    })

    M.pinned_win.win = win
  end
end

function M.hide()
  vim.api.nvim_win_close(M.pinned_win, true)
end

function M.setup()
  vim.api.nvim_create_user_command("Pin", function()
    M.pin()
  end, {})

  vim.api.nvim_create_user_command("Unpin", function()
    M.unpin()
  end, {})

  vim.keymap.set("n", "gP", function()
    require("bombeelu.pin").pin()
  end)

  vim.keymap.set("n", "dP", function()
    require("bombeelu.pin").unpin()
  end)
end

return M
