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
      {
        "<leader>y",
        desc = "Format file",
      },
      {
        "<leader>Y",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n" },
        desc = "Format Injected Langs",
      },
      {
        "<F8>",
        desc = "Format file",
      },
      {
        "gq",
        desc = "Format file",
      },
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
      {
        "<F10>",
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
        gdscript = { "gdformat" },
        handlebars = { "prettier" },
        html = { "prettier" },
        javascript = { "biome", "prettier", stop_after_first = true },
        javascriptreact = { "biome", "prettier", stop_after_first = true },
        json = { "biome", "prettier", stop_after_first = true },
        jsonc = { "prettier" },
        just = { "just" },
        less = { "prettier" },
        lua = { "stylua" },
        liquid = { "prettier" },
        markdown = { "prettier" },
        python = { "ruff" },
        query = { "format-queries", "query_fmt", stop_after_first = true },
        ruby = { "rubyfmt", "syntax_tree", stop_after_first = true },
        rust = { "rustfmt" },
        scss = { "prettier" },
        toml = { "taplo" },
        typescript = { "biome", "prettier", stop_after_first = true },
        typescriptreact = { "biome", "prettier", stop_after_first = true },
        vue = { "prettier" },
        yaml = { "prettier" },
        swift = { "swiftformat" },
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
          async = false,
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
          local formatters = vim.iter(require("conform").list_formatters_for_buffer(bufnr)):flatten():totable()

          local formatter_commands = vim
            .iter(formatters)
            :map(function(name)
              return require("conform").get_formatter_info(name, bufnr)
            end)
            :filter(function(formatter)
              return formatter.available
            end)
            :map(build_command)
            :totable()

          require("legendary").commands(formatter_commands)
        end,
      })

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })
    end,
  },
}
