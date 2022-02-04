require("todo-comments").setup {
  signs = true,
  keywords = {
    FIX = {
      icon = " ",
      color = "error",
      alt = { "FIXME", "BUG", "FIXIT", "FIX", "ISSUE" },
    },
    TODO = { icon = " ", color = "info" },
    HACK = { icon = " ", color = "warning" },
    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
  },
  highlight = {
    before = "",
    keyword = "wide",
    after = "fg",
    pattern = [[.*<(KEYWORDS)\s*:]],
    comments_only = true,
  },
  colors = {
    error = { "#ff5c57" },
    warning = { "#f3f99d" },
    info = { "#9aedfe" },
    hint = { "#5af78e" },
    default = { "Identifier" },
  },
  search = {
    command = "rg",
    args = {
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
    },
    pattern = [[\b(KEYWORDS):]],
  },
}
