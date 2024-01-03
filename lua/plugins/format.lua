local bu = require("bu")

local function build_command(formatter)
  local cmd = bu.format_command(formatter.name)

  return {
    cmd,
    function(o)
      require("conform").format({
        formatters = { formatter.name },
        bufnr = o.buf,
        async = true,
      })
    end,
    description = string.format("Format file with %s", cmd),
    opts = { bang = true, buffer = 0 },
  }
end

return {
  {
    "stevearc/conform.nvim",
    lazy = false,
    keys = {
      { "<leader>y" },
      { "<F8>" },
      { "gq" },
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      formatters_by_ft = {
        ["markdown.mdx"] = { "prettier" },
        c = { "clang_format" },
        cmake = { "cmake_format" },
        cpp = { "clang_format" },
        css = { "prettier" },
        eruby = { "erb_format" },
        go = { "gofmt" },
        graphql = { "prettier" },
        handlebars = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        just = { "just" },
        less = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "black" },
        query = { "query_fmt" },
        ruby = { { "rubyfmt", "syntax_tree" } },
        rust = { "rustfmt" },
        scss = { "prettier" },
        toml = { "taplo" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        yaml = { "prettier" },
        zig = { "zigfmt" },
      },
      formatters = {
        rub = {
          command = "rub",
          args = { "--stdin" },
          stdin = true,
          -- cwd = require("conform.util").root_file({ "Gemfile" }),
          require_cwd = false,
        },
        syntax_tree = {
          command = "stree",
          args = { "format" },
          stdin = true,
          require_cwd = false,
        },
        query_fmt = {
          command = "query-fmt",
          args = { "$FILENAME" },
          stdin = false,
          require_cwd = false,
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

      key.map({ "<F8>", "<Leader>y", "gq" }, function()
        require("conform").format({
          bufnr = vim.api.nvim_get_current_buf(),
          async = true,
        })
      end, { silent = true, desc = "Format file", modes = { "n" } })

      key.map({ "<F8>" }, function()
        require("conform").format({
          bufnr = vim.api.nvim_get_current_buf(),
          async = true,
        })
      end, { silent = true, desc = "Format file", modes = { "i" } })

      nvim.create_augroup("bombeelu.format2", { clear = true })
      vim.api.nvim_create_autocmd("BufRead", {
        group = "bombeelu.format2",
        callback = function(args)
          local bufnr = args.buf
          local formatters = require("conform").list_formatters(bufnr)

          local formatter_commands = vim
            .iter(formatters)
            :filter(function(formatter)
              return formatter.available
            end)
            :map(build_command)
            :totable()

          require("legendary").commands(formatter_commands)
        end,
      })
    end,
  },
}
