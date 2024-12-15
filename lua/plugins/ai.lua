return {
  {
    "nomnivore/ollama.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },

    -- All the user commands added by the plugin
    cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

    keys = {
      -- Sample keybind for prompt menu. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>og",
        ":<c-u>lua require('ollama').prompt('Explain_Code')<cr>",
        desc = "ollama prompt",
        mode = { "v" },
      },

      -- Sample keybind for direct prompting. Note that the <c-u> is important for selections to work properly.
      {
        "<leader>oG",
        ":<c-u>lua require('ollama').prompt('Ask_About_Code')<cr>",
        desc = "ollama Ask about Code",
        mode = { "v" },
      },
    },

    ---@type Ollama.Config
    opts = {
      model = "flirty-assistant:latest",
      url = "http://100.67.168.114:11434",
    },
  },
  {
    "gsuuon/model.nvim",
    enabled = false,
    -- Don't need these if lazy = false
    cmd = { "M", "Model", "Mchat" },
    init = function()
      vim.filetype.add({
        extension = {
          mchat = "mchat",
        },
      })
    end,
    ft = "mchat",

    keys = {
      { "<C-m>d", ":Mdelete<cr>", mode = "n" },
      { "<C-m>s", ":Mselect<cr>", mode = "n" },
      { "<C-m><space>", ":Mchat<cr>", mode = "n" },
    },

    config = function()
      local open_webui = require("model.providers.openai")
      local util = require("model.util")

      require("model").setup({
        hl_group = "Substitute",
        default_prompt = {
          provider = open_webui,
          options = {
            url = "https://open-webui.burro-neon.ts.net/ollama/v1",
          },
          builder = function(input)
            return {
              model = "luna-max",
              messages = {
                {
                  role = "user",
                  content = input,
                },
              },
            }
          end,
        },
      })

      require("model.providers.openai").initialize({
        model = "luna-work",
      })
    end,

    -- To override defaults add a config field and call setup()

    -- config = function()
    --   require('model').setup({
    --     prompts = {..},
    --     chats = {..},
    --     ..
    --   })
    --
    --   require('model.providers.llamacpp').setup({
    --     binary = '~/path/to/server/binary',
    --     models = '~/path/to/models/directory'
    --   })
    --end
  },

  {
    "olimorris/codecompanion.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- The following are optional:
      { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "ollama",
          },
          inline = {
            adapter = "ollama",
          },
        },
        adapters = {
          ollama = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              schema = {
                model = {
                  default = "luna-max",
                },
              },
              env = {
                url = "https://open-webui.burro-neon.ts.net/", -- optional: default value is ollama url http://127.0.0.1:11434
                api_key = "sk-69752d6367d7479da4528e9ac4731bdc", -- optional: if your endpoint is authenticated
                chat_url = "api/chat/completions", -- optional: default value, override if different
              },
            })
          end,
        },
      })
    end,
  },
  -- lazy.nvim
  {
    "robitx/gp.nvim",
    init = function()
      vim.env.OPENAI_API_KEY = "sk-69752d6367d7479da4528e9ac4731bdc"
    end,
    opts = function()
      return {
        providers = {

          openai = {
            endpoint = "https://open-webui.burro-neon.ts.net/api/chat/completions",
            secret = vim.env.OPENAI_API_KEY,
          },
        },

        default_chat_agent = "Luna",

        agents = {
          {
            provider = "openai",
            name = "Luna",
            chat = true,
            command = true,
            -- string with model name or table with model name and parameters
            model = { model = "luna-work" },
            -- system prompt (use this to specify the persona/role of the AI)
            -- system_prompt = "You are helping me code.",
            system_prompt = require("gp.defaults").chat_system_prompt,
          },
        },
      }
    end,
  },
  {
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    lazy = false,
    version = false, -- set this if you want to always pull the latest change
    init = function()
      vim.env.OPENAI_API_KEY = "sk-69752d6367d7479da4528e9ac4731bdc"
    end,
    opts = {
      provider = "openai",
      -- auto_suggestions_provider = "claude",
      openai = {
        endpoint = "https://open-webui.burro-neon.ts.net/api",
        model = "luna-max",
        timeout = 30000, -- Timeout in milliseconds
        -- temperature = 0,
        -- max_tokens = 4096,
      },
      -- add any opts here
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
