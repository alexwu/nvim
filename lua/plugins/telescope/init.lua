local lazy = require("bombeelu.utils").lazy
local set = require("bombeelu.utils").set

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "mrjones2014/legendary.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "kkharji/sqlite.lua",
      "AckslD/nvim-neoclip.lua",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
      "tsakirist/telescope-lazy.nvim",
    },
    cond = function()
      return not vim.g.vscode
    end,
    config = function()
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local custom_pickers = require("plugins.telescope.pickers")
      local default_layout_config = {
        width = function()
          return math.max(100, vim.fn.round(vim.o.columns * 0.5))
        end,
      }

      local defaults = require("telescope.themes").get_dropdown({
        set_env = { ["COLORTERM"] = "truecolor" },
        prompt_prefix = "❯ ",
        layout_config = {
          width = function(_, max_columns, _)
            return math.max(120, vim.fn.round(vim.o.columns * 0.5))
          end,

          height = function(_, _, max_lines)
            return math.min(max_lines, 40)
          end,
        },
        sorting_strategy = "ascending",
        dynamic_preview_title = true,
        winblend = 20,
        mappings = {
          i = {
            ["<esc>"] = actions.close,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
            ["<C-u>"] = false,
          },
          n = {
            ["q"] = actions.close,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.move_selection_next,
            ["<C-p>"] = actions.move_selection_previous,
          },
        },
      })

      require("telescope").setup({
        defaults = {
          set_env = { ["COLORTERM"] = "truecolor" },
          prompt_prefix = "❯ ",
          -- sorting_strategy = "ascending",
          -- preview = {
          -- treesitter = { disable = { "lua" } },
          -- },
          winblend = 20,
          mappings = {
            i = {
              ["<esc>"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-u>"] = false,
            },
            n = {
              ["q"] = actions.close,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = {
              "fd",
              "--type",
              "f",
              "--strip-cwd-prefix",
              "--exclude",
              ".git",
              "--hidden",
              "--exclude",
              ".DS_Store",
              "--exclude",
              ".keep",
            },
            follow = true,
            hidden = true,
            no_ignore = false,
          },
          fd = {
            find_command = {
              "fd",
              "--type",
              "f",
              "--strip-cwd-prefix",
              "--exclude",
              ".git",
              "--hidden",
              "--exclude",
              ".DS_Store",
              "--exclude",
              ".keep",
            },
            follow = true,
            hidden = true,
            no_ignore = false,
          },
          buffers = {
            initial_mode = "insert",
            layout_config = default_layout_config,
            layout_strategy = "center",
            ignore_current_buffer = true,
            cwd_only = false,
            sort_lastused = true,
            path_display = function(opts, path)
              local tail = require("telescope.utils").path_tail(path)
              return string.format("%s (%s)", tail, path)
            end,
            mappings = {
              n = {
                ["<leader><space>"] = actions.close,
              },
            },
          },
          oldfiles = {
            cwd_only = true,
          },
          jumplist = {
            show_line = false,
            trim_text = true,
            layout_config = default_layout_config,
            layout_strategy = "center",
            path_display = function(opts, path)
              local tail = require("telescope.utils").path_tail(path)
              return string.format("%s (%s)", tail, path)
            end,
          },
          lsp_definitions = {
            initial_mode = "insert",
            layout_config = default_layout_config,
            layout_strategy = "center",
          },
          lsp_references = {
            initial_mode = "insert",
            layout_config = default_layout_config,
            layout_strategy = "center",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
          project = {
            base_dirs = {
              "~/Code",
              "~/Projects",
            },
            hidden_files = true,
            load_session = true,
          },
          commander = {},
          lazy = {
            theme = "ivy",
            show_icon = true,
            mappings = {
              open_in_browser = "<C-o>",
              open_in_file_browser = "<M-b>",
              open_in_find_files = "<C-f>",
              open_in_live_grep = "<C-g>",
              open_plugins_picker = "<C-b>",
              open_lazy_root_find_files = "<C-r>f",
              open_lazy_root_live_grep = "<C-r>g",
            },
          },
        },
      })

      local legendary = require("legendary")

      require("telescope").load_extension("fzf")

      require("neoclip").setup({
        enable_persistent_history = true,
      })

      set("n", { "<Leader>b" }, lazy(builtin.buffers), { desc = "Select from open buffers" })

      -- set("n", "<Leader>f", lazy(builtin.find_files, { prompt_title = "Find Files" }), { desc = "Find files" })
      set(
        "n",
        "<Leader>F",
        lazy(builtin.find_files, { prompt_title = "Find All Files", no_ignore = true }),
        { desc = "Find files (no_ignore)" }
      )

      set("n", "<Leader>d", lazy(builtin.diagnostics, { bufnr = 0 }), { desc = "Select from buffer diagnostics " })
      set("n", "<Leader>D", lazy(builtin.diagnostics, {}), { desc = "Select from workspace diagnostics " })
      set(
        "n",
        "<Leader>g",
        lazy(custom_pickers.git_changes),
        { desc = "Select from changed files since default branch" }
      )
      set("n", "<Leader>/", lazy(builtin.live_grep), { desc = "Live grep current working directory" })
      set("n", "gd", lazy(builtin.lsp_definitions), { desc = "Go to definition" })
      set("n", "gr", lazy(builtin.lsp_references), { desc = "Go to references" })
      set("n", "gi", lazy(builtin.lsp_implementations), { desc = "Go to implementation" })
      set("n", "<Leader>s", lazy(builtin.lsp_document_symbols), { desc = "Select LSP document symbol" })
      set("n", "<Leader>S", lazy(builtin.lsp_workplace_symbols), { desc = "Select LSP workplace symbol" })

      local group = augroup("bombeelu.telescope", { clear = true })

      autocmd(
        "FileType",
        { group = "bombeelu.telescope", pattern = "TelescopePrompt", command = "setlocal nocursorline" }
      )
      nvim.create_autocmd({ "VimEnter", "DirChanged" }, {
        pattern = "*",
        group = group,
        callback = function()
          vim.g.default_branch = custom_pickers.get_default_branch({ force = true })
        end,
      })

      vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])

      legendary.commands({
        {
          ":Config",
          function()
            require("bombeelu.pickers").config_files()
          end,
          description = "Select from nvim config files",
        },
      })
    end,
  },
  {
    "danielfalk/smart-open.nvim",
    config = function()
      require("telescope").load_extension("smart_open")
      local legendary = require("legendary")
      legendary.keymaps({
        {
          "<Leader><Leader>",
          function()
            require("telescope").extensions.smart_open.smart_open({ cwd_only = true, match_algorithm = "fzf" })
          end,
          description = "Select from recent files",
        },
      })
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
}
