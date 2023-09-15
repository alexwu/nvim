local function upper_first(str)
  return (str:gsub("^%l", string.upper))
end

local function build_command(formatter)
  local cmd = upper_first(formatter.name)
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
    opts = {
      formatters_by_ft = {
        c = { "clang_format" },
        cmake = { "cmake_format" },
        cpp = { "clang_format" },
        erb = { "erb_format" },
        go = { "gofmt" },
        graphql = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        javascript = { "prettier" },
        lua = { "stylua" },
        python = { "black" },
        ruby = { "rubyfmt" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        zig = { "zigfmt" },
      },
      formatters = {
        rubyfmt = {
          command = "rubyfmt",
          stdin = true,
          -- cwd = require("conform.util").root_file({ "Gemfile" }),
          require_cwd = false,
        },
        rub = {
          command = "rub",
          args = { "--stdin" },
          stdin = true,
          -- cwd = require("conform.util").root_file({ "Gemfile" }),
          require_cwd = false,
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)

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
