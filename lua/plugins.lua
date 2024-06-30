local api = vim.api

if jit.os == "OSX" then
  vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")
end

return {
  {
    "sheerun/vim-polyglot",
    lazy = false,
    init = function()
      vim.g.polyglot_disabled = { "sensible", "ftdetect" }
    end,
  },
  { "antoinemadec/FixCursorHold.nvim", lazy = false },
  {
    "Bekaboo/dropbar.nvim",
    config = true,
    opts = {
      general = {
        enable = function(buf, win)
          return not vim.api.nvim_win_get_config(win).zindex
            and (vim.bo[buf].buftype == "" or vim.bo[buf].buftype == "terminal")
            and vim.api.nvim_buf_get_name(buf) ~= ""
            and not vim.wo[win].diff
        end,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "haydenmeade/neotest-jest",
      "rouge8/neotest-rust",
      "olimorris/neotest-rspec",
      "marilari88/neotest-vitest",
      "antoinemadec/FixCursorHold.nvim",
      "folke/trouble.nvim",
    },
    opts = {
      -- NOTE: Can be a list of adapters like what neotest expects,
      -- or a list of adapter names,
      -- or a table of adapter names, mapped to adapter configs.
      -- The adapter will then be automatically loaded with the config.
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/test/core.lua
      adapters = {
        ["neotest-rspec"] = {
          rspec_cmd = function()
            return vim
              .iter({
                "bundle",
                "exec",
                "rspec",
              })
              :flatten()
              :totable()
          end,
        },
        ["rustaceanvim.neotest"] = {},
        ["neotest-jest"] = {
          jestCommand = "yarn test",
          jestConfigFile = "jest.config.js",
          env = { DEBUG_PRINT_LIMIT = 20000 },
          cwd = function(path)
            return vim.fs.dirname(
              vim.fs.find(
                { "jest.config.js", "package.json" },
                { upward = true, stop = vim.loop.os_homedir(), path = path }
              )[1]
            )
          end,
        },
        ["neotest-vitest"] = {},
      },
      -- NOTE: Example for loading neotest-golang with a custom config
      -- adapters = {
      --   ["neotest-golang"] = {
      --     go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
      --     dap_go_enabled = true,
      --   },
      -- },
      icons = {
        passed = " ✔",
        running = " ",
        failed = " ✖",
        skipped = " ﰸ",
        unknown = " ?",
        non_collapsible = "─",
        collapsed = "─",
        expanded = "╮",
        child_prefix = "├",
        final_child_prefix = "╰",
        child_indent = "│",
        final_child_indent = " ",
      },
      status = { virtual_text = false },
      output = { open_on_run = true },
      quickfix = {
        open = function()
          require("trouble").open({ mode = "quickfix", focus = false })
        end,
      },
    },
    config = function(_, opts)
      opts.consumers = opts.consumers or {}
      -- Refresh and auto close trouble after running tests
      ---@type neotest.Consumer
      opts.consumers.trouble = function(client)
        client.listeners.results = function(adapter_id, results, partial)
          if partial then
            return
          end
          local tree = assert(client:get_position(nil, { adapter = adapter_id }))

          local failed = 0
          for pos_id, result in pairs(results) do
            if result.status == "failed" and tree:get_key(pos_id) then
              failed = failed + 1
            end
          end
          vim.schedule(function()
            local trouble = require("trouble")
            if trouble.is_open() then
              trouble.refresh()
              if failed == 0 then
                trouble.close()
              end
            end
          end)
          return {}
        end
      end

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
      require("bombeelu.neotest").setup()
    end,
    keys = {
      { "<leader>t", "", desc = "+test" },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run all tests in file",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.loop.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Re-run the last test",
      },
    },
  },
  {
    "alexwu/ruby.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
    dev = true,
    config = function()
      require("bombeelu.lsp").sorbet.setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
    ft = { "ruby" },
    enabled = false,
  },
  {
    "ckolkey/ts-node-action",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("ts-node-action").setup({})
      -- set({ "n" }, "gJ", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    config = true,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "vuki656/package-info.nvim",
    event = { "BufRead package.json" },
    dependencies = "MunifTanjim/nui.nvim",
    config = true,
    opts = {
      colors = {
        up_to_date = "#57c7ff",
        outdated = "#FF9F43",
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.dressing")
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      operators = { gc = "+comment" },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
      window = {
        border = "rounded",
      },
      defaults = {
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>o"] = { name = "+overseer" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
  { "echasnovski/mini.align", event = "VeryLazy", version = false, opts = {}, config = true },
  {
    "smjonas/inc-rename.nvim",
    event = "VeryLazy",
    config = function()
      require("inc_rename").setup({})

      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Rename symbol" })
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    setup = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
    cond = function()
      return not vim.g.vscode
    end,
    enabled = true,
  },
  {
    "ray-x/go.nvim",
    event = { "VeryLazy" },
    dependencies = { "ray-x/guihua.lua" },
    ft = "go",
    config = function()
      require("bombeelu.lsp.go").setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "lewis6991/spaceless.nvim",
    opts = {},
    config = true,
    cond = function()
      return not vim.g.vscode
    end,
    event = "InsertEnter",
  },
  {
    "willothy/wezterm.nvim",
    event = "VeryLazy",
    dependencies = { "mrjones2014/legendary.nvim" },
    enabled = true,
    cond = function()
      return vim.fn.executable("wezterm") ~= 0
    end,
    config = function()
      local w = require("wezterm")
      w.setup({})

      require("legendary").commands({
        {
          "Spawn",
          function(opts)
            local fargs = vim.F.if_nil(vim.deepcopy(opts.fargs), { "" })
            -- table.insert(fargs, 1, "wezterm")
            local program = opts.fargs[1]

            vim.print(program)

            table.remove(fargs, 1)
            local args = fargs
            vim.print(args)

            w.spawn(program, { cwd = vim.loop.cwd(), args = args })
          end,
          description = "Spawn a new wezterm process",
          unfinished = true,
          opts = {
            nargs = "*",
            complete = "shellcmd",
          },
        },
        {
          "WezSplit",
          function(opts)
            local fargs = vim.F.if_nil(vim.deepcopy(opts.fargs), { "" })
            -- table.insert(fargs, 1, "wezterm")
            -- local program = opts.fargs[1]

            -- vim.print(program)

            -- table.remove(fargs, 1)
            -- local args = fargs
            -- vim.print(args)

            w.split_pane.vertical({ cwd = vim.loop.cwd(), program = fargs, percent = 25 })
          end,
          description = "Split a new wezterm process",
          unfinished = true,
          opts = {
            nargs = "*",
            complete = "shellcmd",
          },
        },
      })
    end,
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    requires = "nvim-tree/nvim-web-devicons",
    opts = {
      use_diagnostic_signs = true,
      auto_close = true,
    },
    keys = {
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    config = true,
  },
  {
    "RRethy/vim-illuminate",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("illuminate").configure({
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {
          "lsp",
          "treesitter",
        },
        delay = 100,
        filetype_overrides = {},
        filetypes_denylist = {
          "neotree",
        },
      })
    end,
  },
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    version = false,
    config = function()
      require("mini.bracketed").setup({
        diagnostic = { suffix = "" },
        treesitter = { suffix = "" },
        quickfix = { suffix = "" },
        comment = { suffix = "" },
      })
      require("mini.splitjoin").setup()
      require("mini.colors").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          g = function() -- Whole buffer, similar to `gg` and 'G' motion
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      -- if require("lazyvim.util").has("which-key.nvim") then
      ---@type table<string, string|table>
      local i = {
        [" "] = "Whitespace",
        ['"'] = 'Balanced "',
        ["'"] = "Balanced '",
        ["`"] = "Balanced `",
        ["("] = "Balanced (",
        [")"] = "Balanced ) including white-space",
        [">"] = "Balanced > including white-space",
        ["<lt>"] = "Balanced <",
        ["]"] = "Balanced ] including white-space",
        ["["] = "Balanced [",
        ["}"] = "Balanced } including white-space",
        ["{"] = "Balanced {",
        ["?"] = "User Prompt",
        _ = "Underscore",
        a = "Argument",
        b = "Balanced ), ], }",
        c = "Class",
        f = "Function",
        o = "Block, conditional, loop",
        q = "Quote `, \", '",
        t = "Tag",
      }
      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(" including.*", "")
      end

      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs({ n = "Next", l = "Last" }) do
        i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
        a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
      end
      require("which-key").register({
        mode = { "o", "x" },
        i = i,
        a = a,
      })
      -- end
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          names = false,
        },
        buftypes = {},
      })
    end,
    cmd = { "ColorizerToggle" },
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "shortcuts/no-neck-pain.nvim",
    cmd = { "NoNeckPain" },
    version = "*",
    config = function()
      require("no-neck-pain").setup({
        width = 300,
        autocmds = {
          enableOnVimEnter = false,
          enableOnTabEnter = false,
        },
      })
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = {},
  },
  {
    "johmsalas/text-case.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
      vim.api.nvim_set_keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
      vim.api.nvim_set_keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
    end,
  },
  {
    "rgroli/other.nvim",
    event = "VeryLazy",
    config = function()
      local bu = require("bu")
      local mappings = bu.F.flatten({
        "golang",
        require("bombeelu.other.rails"),
        {
          pattern = "(.*)/(.*).ts$",
          target = "%1/%2.test.ts",
          context = "source",
        },
        {
          pattern = "(.*)/(.*).tsx$",
          target = "%1/%2.test.tsx",
          context = "source",
        },
        {
          pattern = "(.*)/(.*).test.ts$",
          target = "%1/%2.ts",
          context = "test",
        },
        {
          pattern = "(.*)/(.*).test.tsx$",
          target = "%1/%2.tsx",
          context = "test",
        },
      })

      require("other-nvim").setup({
        mappings = mappings,
        showMissingFiles = true,
        transformers = {
          lowercase = function(inputString)
            return inputString:lower()
          end,
          strip_test = function(inputString)
            return bu.strings.strip_suffix(inputString, ".test")
          end,
        },
        hooks = {
          filePickerBeforeShow = function(files)
            if vim.iter(files):any(function(entry)
              return entry.exists
            end) then
              return vim
                .iter(files)
                :filter(
                  ---@param entry table (filename (string), context (string), exists (boolean))
                  function(entry)
                    return entry.exists
                  end
                )
                :totable()
            end

            return files
          end,
        },
        style = {
          border = "rounded",
          seperator = "|",
          width = 0.7,
          minHeight = 2,
        },
      })

      api.nvim_create_user_command("O", function(opts)
        local fargs = opts.fargs
        if vim.tbl_isempty(fargs) then
          fargs = nil
        end

        require("other-nvim").open(fargs)
      end, { nargs = "*" })

      api.nvim_create_user_command("OSplit", function(opts)
        local fargs = opts.fargs
        if vim.tbl_isempty(fargs) then
          fargs = nil
        end
        require("other-nvim").openSplit(fargs)
      end, { nargs = "*" })
      api.nvim_create_user_command("OVSplit", function(opts)
        local fargs = opts.fargs
        if vim.tbl_isempty(fargs) then
          fargs = nil
        end
        require("other-nvim").openVSplit(fargs)
      end, { nargs = "*" })
      api.nvim_create_user_command("OClear", function(opts)
        local fargs = opts.fargs
        if vim.tbl_isempty(fargs) then
          fargs = nil
        end
        require("other-nvim").clear(fargs)
      end, { nargs = "*" })
    end,
  },
  {
    "TobinPalmer/rayso.nvim",
    cmd = { "Rayso" },
    opts = {
      options = {
        theme = "candy",
      },
    },
  },
  {
    "David-Kunz/gen.nvim",
    opts = {
      model = "llama3", -- The default model to use.
      display_mode = "float", -- The display mode. Can be "float" or "split".
      show_prompt = true, -- Shows the prompt submitted to Ollama.
      show_model = true, -- Displays which model you are using at the beginning of your chat session.
      no_auto_close = false, -- Never closes the window automatically.
      debug = false, -- Prints errors and the command which is run.
    },
  },
  {
    "danymat/neogen",
    config = true,
    cmd = "Neogen",
    keys = {
      {
        "<leader>cn",
        function()
          require("neogen").generate({})
        end,
        desc = "Generate Annotations (Neogen)",
      },
    },
    opts = {
      snippet_engine = "nvim",
    },
  },
  {
    "hedyhli/outline.nvim",
    keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    cmd = "Outline",
    config = true,
    opts = {},
  },
}
