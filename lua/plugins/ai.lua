return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {},
        ft = { "codecompanion", "Avante" },
      },
    },
    keys = {
      { "<c-s>", "<CR>", ft = "codecompanion", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        noremap = true,
        silent = true,
        desc = "CodeCompanion (Toggle Chat)",
      },
    },
    config = function()
      require("codecompanion").setup({
        display = {
          chat = {
            show_settings = false,
            window = {
              width = 0.33,
            },
          },
        },
        opts = {
          system_prompt = function()
            local version = vim.version()

            local cwd = vim.fn.getcwd()
            local files = {}
            for file, t in vim.fs.dir(cwd) do
              if t == "file" then
                table.insert(files, file .. " (file)")
              elseif t == "directory" then
                table.insert(files, file .. " (directory)")
              end
            end

            local context = {
              os = vim.uv.os_uname().sysname,
              nvim_version = string.format("%d.%d.%d", version.major, version.minor, version.patch),
              files = files,
              home = vim.env.HOME,
              editor = vim.env.EDITOR,
              term = vim.env.TERM,
              shell = vim.env.SHELL,
            }

            local output = "### Current Session Information:\n"
            for key, value in pairs(context) do
              if key ~= "files" then
                output = output .. "  " .. key .. ": " .. tostring(value) .. "\n"
              end
            end

            output = output .. "  Files in Current Working Directory: " .. table.concat(context.files, ", ")

            return output
            -- return string.format(
            --   [[
            -- ### Current Session Information:
            --   Current Working Directory: %s
            --   Files in Current Working Directory: %s
            --   Operating System: %s
            --   Neovim Version: %s
            -- ]],
            --   cwd,
            --   table.concat(files, ", "),
            --   os,
            --   version_string
            -- )
          end,
        },
        strategies = {
          chat = {
            adapter = "luna",
            roles = {
              ---@type string|fun(adapter: CodeCompanion.Adapter): string
              llm = function(adapter)
                return adapter.formatted_name
              end,
            },
            slash_commands = {
              ["buffer"] = {
                callback = "strategies.chat.slash_commands.buffer",
                description = "Select a buffer",
                opts = {
                  provider = "snacks",
                  contains_code = true,
                },
              },
            },
          },
          inline = {
            adapter = "luna",
          },
        },
        adapters = {
          opts = {
            show_defaults = false,
          },
          ---@returns CodeCompanion.Adapter
          luna = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              schema = {
                model = {
                  default = "luna-work-neovim-remote",
                },
              },
              name = "luna",
              formatted_name = "Luna",
              env = {
                url = "https://open-webui.burro-neon.ts.net",
                api_key = [[cmd:op read "op://personal/Open WebUI/credential" --no-newline]],
                chat_url = "/api/chat/completions",
              },
            })
          end,
          luna_local = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              schema = {
                model = {
                  default = "luna-work-neovim-local",
                },
              },
              name = "luna (local)",
              formatted_name = "Luna (Local)",
              env = {
                url = "https://open-webui.burro-neon.ts.net",
                api_key = [[cmd:op read "op://personal/Open WebUI/credential" --no-newline]],
                chat_url = "/api/chat/completions",
              },
            })
          end,
        },
      })
    end,
  },
}
