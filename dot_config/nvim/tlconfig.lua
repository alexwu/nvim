return {
  include_dir = { "teal", "types", "vim.d.tl" },
  exclude = {},
  global_env_def = "vim",

  gen_compat = "off",
  gen_target = "5.1",

  source_dir = "teal",
  build_dir = "lua",

  warning_error = { "unused", "redeclaration" },
}
