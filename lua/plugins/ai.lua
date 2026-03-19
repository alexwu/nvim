return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    -- ft = { "markdown", "codecompanion", "Avante" },
    opts = {
      anti_conceal = { enabled = false },
    },
  },
  {
    "folke/sidekick.nvim",
    dependencies = {},
    opts = {
      cli = {
        mux = {
          backend = "zellij",
          enabled = true,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>"
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
        mode = { "n" },
      },
      -- {
      --   "<c-.>",
      --   function()
      --     require("sidekick.cli").focus()
      --   end,
      --   desc = "Sidekick Switch Focus",
      --   mode = { "n", "v" },
      -- },
      -- {
      --   "<leader>aa",
      --   function()
      --     require("sidekick.cli").toggle({ focus = true })
      --   end,
      --   desc = "Sidekick Toggle CLI",
      --   mode = { "n", "v" },
      -- },
      -- {
      --   "<leader>ac",
      --   function()
      --     require("sidekick.cli").toggle({ name = "claude", focus = true })
      --   end,
      --   desc = "Sidekick Claude Toggle",
      --   mode = { "n", "v" },
      -- },
      -- {
      --   "<leader>ap",
      --   function()
      --     require("sidekick.cli").select_prompt()
      --   end,
      --   desc = "Sidekick Ask Prompt",
      --   mode = { "n", "v" },
      -- },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = { "folke/sidekick.nvim" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "super-tab",
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              cmp.select_next({ on_ghost_text = true })
            end
          end,
          function()
            return require("sidekick").nes_jump_or_apply()
          end,
          function()
            return vim.lsp.inline_completion.get()
          end,
          "fallback",
        },
      },
    },
  },

  {
    "linw1995/nvim-mcp",
    -- install the mcp server binary automatically
    build = "cargo install --path .",
    opts = {},
  },
  {
    "Davidyz/VectorCode",
    enabled = false,
    event = "VeryLazy",
    version = "*",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    setup = function(_, opts)
      require("vectorcode").setup(opts)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          local bufnr = vim.api.nvim_get_current_buf()
          local cacher = require("vectorcode.cacher")

          cacher.async_check("config", function()
            cacher.register_buffer(bufnr, {
              n_query = 10,
            })
          end, nil)
        end,
        desc = "Register buffer for VectorCode",
      })
    end,
  },
  {
    "ravitemer/mcphub.nvim",
    enabled = false,
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- cmd = "MCPHub",
    -- build = "mise use -g npm:mcp-hub@latest",
    -- build = "mise upgrade npm:mcp-hub",
    build = "bundled_build.lua",
    config = function()
      require("mcphub").setup({
        port = 3000,
        config = vim.fn.expand("~/Library/Application Support/Claude/claude_desktop_config.json"),
        use_bundled_binary = true,
        log = {
          level = vim.log.levels.WARN,
          to_file = false,
          file_path = nil,
          prefix = "MCPHub",
        },
        extensions = {
          avante = {
            make_slash_commands = true,
          },
        },
      })
    end,
  },
}
