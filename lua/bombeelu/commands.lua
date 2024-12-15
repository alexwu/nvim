nvim.create_user_command("Qa", "qa", {})
nvim.create_user_command("Wq", "wq", {})
nvim.create_user_command("W", "w", {})

nvim.create_user_command("Ide", function()
  vim.cmd.Outline()
  require("neotest").summary.toggle()
end, {
  desc = "Enable all the fancy IDE features",
})
