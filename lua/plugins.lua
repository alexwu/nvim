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
      "alexwu/neotest-rspec",
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
        desc = "Run all test files",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show test output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle output panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop running tests",
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
    "alexwu/ruby-lsp.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    dev = true,
    opts = {},
    config = true,
    cond = function()
      return not vim.g.vscode
    end,
    ft = { "ruby" },
  },
  {
    "ckolkey/ts-node-action",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    opts = {},
  },
  {
    "saecki/crates.nvim",
    cond = function()
      local result = require("bombeelu.utils").root_pattern("Cargo.toml")(vim.uv.cwd() or vim.uv.os_homedir())

      return result
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "neovim/nvim-lspconfig",
    },
    opts = function()
      return {
        lsp = {
          enabled = true,
          on_attach = require("plugins.lsp.defaults").on_attach,
          actions = true,
          completion = true,
          hover = true,
        },
      }
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
    opts = {
      preset = "modern",
      -- preset = "helix",
      ---@type wk.Spec
      spec = {
        {
          mode = { "n", "v" },
          { "[", group = "prev" },
          { "]", group = "next" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
        },
        {
          mode = { "n", "x" },
          { "s", group = "flash" },
        },
      },
      triggers = {
        { "<auto>", mode = "nixsotc" },
        { "s", mode = { "n", "v" } },
      },
      icons = {
        rules = false,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
    },
    keys = {
      {
        "g?",
        function()
          require("which-key").show({ global = true })
        end,
        desc = "Keymaps (which-key)",
      },
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
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
    version = "^5",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = function()
        return {
          server = {
            on_attach = function(client, bufnr)
              local opts = { noremap = true, silent = true, buffer = bufnr }
              set("n", "<CR>", '<cmd>lua require("tree_climber_rust").init_selection()<CR>', opts)
              set("x", "<CR>", '<cmd>lua require("tree_climber_rust").select_incremental()<CR>', opts)
              set("x", "<BS>", '<cmd>lua require("tree_climber_rust").select_previous()<CR>', opts)
            end,
          },
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              cargo = {
                features = "all",
              },
            },
          },
        }
      end
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  { "adaszko/tree_climber_rust.nvim" },
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
      -- register all text objects with which-key
      local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
      }

      local ret = { mode = { "o", "x" } }
      ---@type table<string, string>
      local mappings = vim.tbl_extend("force", {}, {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == "i" then
            desc = desc:gsub(" with ws", "")
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end
      require("which-key").add(ret, { notify = false })
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
          enableOnVimEnter = true,
          enableOnTabEnter = true,
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
  {
    "jmbuhr/otter.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      verbose = {
        no_code_found = false,
      },
    },
    config = function(_, opts)
      local otter = require("otter")

      otter.setup(opts)

      nvim.create_autocmd("BufRead", {
        group = bu.nvim.augroup("bombeelu.otter"),
        callback = function(args)
          local ft = vim.filetype.match({ buf = args.buf })

          if not ft or vim.list_contains({}, ft) then
            return
          end
          -- local lang = vim.treesitter.language.get_lang(args.match)
          local lang = vim.treesitter.language.get_lang(ft)
          if lang then
            -- vim.print(args)
            otter.activate()
          end
        end,
      })
      -- nvim.create_autocmd("BufRead", {
      --   group = bu.nvim.augroup("bombeelu.otter"),
      --   callback = function(o)
      --     -- require("legendary").command(o.buf, ":Chezmoi", chezmoi_apply, { nargs = 0, desc = "Runs chezmoi apply" })
      --     otter.activate()
      --   end,
      -- })
    end,
  },
  {
    "mistweaverco/kulala.nvim",
    ft = { "http" },
    opts = {
      debug = true,
    },
    config = true,
    keys = {
      -- {
      --   "<C-k>",
      --   ":lua require('kulala').jump_prev()<CR>",
      --   { noremap = true, silent = true },
      -- },
      -- {
      --
      --   "<C-j>",
      --   ":lua require('kulala').jump_next()<CR>",
      --   { noremap = true, silent = true },
      -- },
      {
        "<Leader>kl",
        ":lua require('kulala').run()<CR>",
        noremap = true,
        silent = true,
      },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false, -- Recommended
    dependencies = {
      -- You will not need this if you installed the
      -- parsers manually
      -- Or if the parsers are in your $RUNTIMEPATH
      "nvim-treesitter/nvim-treesitter",

      "nvim-tree/nvim-web-devicons",
    },
  },

  {
    "mkusm/nvim-papyrus",
    lazy = false,
    config = function()
      -- vim.g.skyrim_install_path = vim.env.SkyrimInstal
    end,
  },
  {
    "leath-dub/snipe.nvim",
    enabled = false,
    keys = {
      {
        "gbb",
        function()
          require("snipe").open_buffer_menu()
        end,
        desc = "Open Snipe buffer menu",
      },
    },
    opts = {},
  },
  {
    "MagicDuck/grug-far.nvim",
    event = "VeryLazy",
    config = function()
      require("grug-far").setup({
        engine = "ripgrep",
        -- ... options, see Configuration section below ...
        -- ... there are no required options atm...
        -- ... engine = 'ripgrep' is default, but 'astgrep' can be specified...
      })
    end,
  },
}
