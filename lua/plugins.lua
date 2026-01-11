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
  { "brainwo/vim-modelfile" },
  { "antoinemadec/FixCursorHold.nvim", lazy = false },
  {
    "ckolkey/ts-node-action",
    enabled = false,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    opts = {},
  },
  {
    "vuki656/package-info.nvim",
    event = { "BufRead package.json" },
    dependencies = "MunifTanjim/nui.nvim",
    opts = {
      colors = {
        up_to_date = "#57c7ff",
        outdated = "#FF9F43",
      },
    },
  },
  {
    "echasnovski/mini.align",
    event = "VeryLazy",
    version = false,
    opts = {},
    cond = true,
  },
  {
    "smjonas/inc-rename.nvim",
    event = "VeryLazy",
    config = function()
      require("inc_rename").setup({})

      set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Rename symbol" })
      set("n", "grn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Rename symbol" })
    end,
  },
  {
    "andymass/vim-matchup",
    enabled = true,
    event = "VeryLazy",
    setup = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  {
    "lewis6991/spaceless.nvim",
    opts = {},
    event = "InsertEnter",
  },
  {
    "willothy/wezterm.nvim",
    event = "VeryLazy",
    dependencies = { "mrjones2014/legendary.nvim" },
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
        "<leader>xl",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xq",
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
    "echasnovski/mini.bracketed",
    event = "VeryLazy",
    version = false,
    opts = {
      diagnostic = { suffix = "" },
      treesitter = { suffix = "" },
      quickfix = { suffix = "" },
      comment = { suffix = "" },
    },
  },
  {
    "catgoose/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          names = false,
        },
        buftypes = {},
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = true, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = true, -- Enable all CSS *features*:
        -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
        tailwind = "both", -- Enable tailwind colors
        sass = { enable = true, parsers = { "css" } }, -- Enable sass colors
      })
    end,
    cmd = { "ColorizerToggle", "ColorizerAttachToBuffer" },
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

      set("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
      set("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
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
          separator = "|",
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
  -- {
  --   "TobinPalmer/rayso.nvim",
  --   cmd = { "Rayso" },
  --   opts = {
  --     options = {
  --       theme = "candy",
  --     },
  --   },
  -- },
  {
    "michaelrommel/nvim-silicon",
    lazy = true,
    cmd = "Silicon",
    main = "nvim-silicon",
    opts = {
      line_offset = function(args)
        return args.line1
      end,
      to_clipboard = true,
      output = function()
        return "~/.local/state/silicon/" .. os.date("!%Y-%m-%dT%H-%M-%SZ") .. "_code.png"
      end,
      theme = "Sublime Snazzy",
    },
  },
  {
    "hedyhli/outline.nvim",
    keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    cmd = "Outline",
    opts = {},
  },
  {
    "jmbuhr/otter.nvim",
    event = "VeryLazy",
    enabled = false,
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

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "toml", "markdown" },
        group = bu.nvim.augroup("bombeelu.otter"),
        callback = function()
          require("otter").activate()
        end,
      })
      -- nvim.create_autocmd("BufRead", {
      --   group = bu.nvim.augroup("bombeelu.otter"),
      --   callback = function(args)
      --     local ft = vim.filetype.match({ buf = args.buf })
      --
      --     -- if not ft or vim.list_contains({ "oil" }, ft) then
      --     --   return
      --     -- end
      --     if not ft or not vim.list_contains({ "ruby", "eruby", "markdown", "html" }, ft) then
      --       return
      --     end
      --     -- local lang = vim.treesitter.language.get_lang(args.match)
      --     local lang = vim.treesitter.language.get_lang(ft)
      --     if lang then
      --       -- vim.print(lang)
      --       otter.activate()
      --     end
      --   end,
      -- })
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
    ft = { "http", "rest" },
    opts = {
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    },
    keys = {
      { "<leader>Rs", desc = "Send request" },
      { "<leader>Ra", desc = "Send all requests" },
      { "<leader>Rb", desc = "Open scratchpad" },
    },
  },
  {
    "OXY2DEV/markview.nvim",
    enabled = false,
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
      "saghen/blink.cmp",
    },
    opts = function()
      local headings = require("markview.presets").headings

      return {
        markdown = {
          headings = headings.glow,
        },
        preview = {
          filetypes = {
            "md",
            "markdown",
            "norg",
            "rmd",
            "org",
            "vimwiki",
            "typst",
            "latex",
            "quarto",
            "Avante",
            "codecompanion",
          },
          ignore_buftypes = {},

          condition = function(buffer)
            local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt

            if bt == "nofile" and ft == "codecompanion" then
              return true
            elseif bt == "nofile" then
              return false
            else
              return true
            end
          end,
          modes = { "n", "i", "no", "c" },
          -- hybrid_modes = { "i", "n" },
          hybrid_modes = {},
          callbacks = {
            on_enable = function(_, win)
              vim.wo[win].conceallevel = 2
              vim.wo[win].concealcursor = "c"
            end,
          },
        },
      }
    end,
  },

  {
    "obsidian-nvim/obsidian.nvim",
    enabled = false,
    version = "*",
    ft = "markdown",
    cmd = { "Obsidian", "Notes" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      legacy_commands = false,
      workspaces = {
        {
          name = "personal",
          path = "~/Obsidian/Default",
        },
      },
      new_notes_location = "current_dir",
      -- Optional, customize how note IDs are generated given an optional title.
      ---@param title string|?
      ---@return string
      note_id_func = function(title)
        -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
        -- In this case a note with the title 'My new note' will be given an ID that looks
        -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
        local suffix = ""
        if title ~= nil then
          -- If title is given, transform it into valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- If title is nil, just add 4 random uppercase letters to the suffix.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,
      ---@param spec { id: string, dir: obsidian.Path, title: string|? }
      ---@return string|obsidian.Path The full path to the new note.
      note_path_func = function(spec)
        -- This is equivalent to the default behavior.
        local path = spec.dir / tostring(spec.id)
        return path:with_suffix(".md")
      end,
    },

    config = function(_, opts)
      require("obsidian").setup(opts)
      require("legendary").commands({
        {
          "Notes",
          function()
            vim.cmd.chdir([[~/Obsidian/Default]])
            vim.cmd.edit([[~/Obsidian/Default]])
          end,
          description = "Open default Obsidian vault",
        },
      })
    end,
  },
  {
    "OXY2DEV/helpview.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "echasnovski/mini.extra",
    event = "VeryLazy",
    version = false,
    opts = {},
  },

  {
    -- highlighting for chezmoi files template files
    "alker0/chezmoi.vim",
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = 1
      vim.g["chezmoi#source_dir_path"] = vim.uv.os_homedir() .. "/.local/share/chezmoi"
    end,
  },
  {
    "xvzc/chezmoi.nvim",
    opts = {
      edit = {
        watch = false,
        force = false,
      },
      notification = {
        on_open = true,
        on_apply = true,
        on_watch = false,
      },
      telescope = {
        select = { "<CR>" },
      },
    },
    init = function()
      -- run chezmoi edit on file enter
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { vim.uv.os_homedir() .. "/.local/share/chezmoi/*" },
        callback = function()
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end,
      })
    end,
  },
  {
    "ahmedkhalf/project.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    opts = {
      manual_mode = true,
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Gemfile", "node_modules/**" },
      exclude_dirs = { "node_modules", ".cargo" },
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
    keys = {
      {
        "<leader>fp",
        function()
          require("telescope").extensions.projects.projects({})
        end,
        desc = "Projects (Telescope)",
      },
    },
  },
  {
    "stevearc/resession.nvim",
    opts = {},
    config = function(_, opts)
      local resession = require("resession")
      resession.setup(opts)

      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          -- Always save a special session named "last"
          resession.save("last")
        end,
      })

      local function get_session_name()
        local name = vim.fn.getcwd()
        local branch = vim.trim(vim.fn.system("git branch --show-current"))
        if vim.v.shell_error == 0 then
          return name .. branch
        else
          return name
        end
      end
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            resession.load(get_session_name(), { dir = "dirsession", silence_errors = true })
          end
        end,
      })
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          resession.save(get_session_name(), { dir = "dirsession", notify = false })
        end,
      })
    end,
    keys = {
      {
        "<leader>ee",
        function()
          require("resession").save()
        end,
        desc = "Save session",
      },
      {
        "<leader>el",
        function()
          require("resession").load()
        end,
        desc = "Load session",
      },
      {
        "<leader>ed",
        function()
          require("resession").delete()
        end,
        desc = "Delete session",
      },
    },
  },
  {
    "wurli/visimatch.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "HakonHarnes/img-clip.nvim",
    enabled = false,
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

    keys = {
      -- suggested keymap
      { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
    },
  },
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "<leader>-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      open_for_directories = false,
      keymaps = {
        show_help = "<f1>",
      },
    },
  },
  {
    "Hashino/doing.nvim",
    enabled = false,
    event = "VeryLazy",
    keys = {
      {
        "<leader>da",
        function()
          require("doing").add()
        end,
        {},
      },
      {
        "<leader>dn",
        function()
          require("doing").done()
        end,
        {},
      },
      {
        "<leader>de",
        function()
          require("doing").edit()
        end,
        {},
      },
    },
  },
  {
    "dmtrKovalenko/fff.nvim",
    enabled = false,
    opts = {
      debug = {
        enabled = false, -- we expect your collaboration at least during the beta
        show_scores = false, -- to help us optimize the scoring system, feel free to share your scores!
      },
    },
    -- No need to lazy-load with lazy.nvim.
    -- This plugin initializes itself lazily.
    lazy = false,
    keys = {
      {
        "<leader>FF", -- try it if you didn't it is a banger keybinding for a picker
        function()
          require("fff").find_files()
        end,
        desc = "FFFind files",
      },
    },
  },
  { import = "plugins.lang" },
}
