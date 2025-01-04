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
  {
    "brainwo/vim-modelfile",
  },
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
        },
        {
          mode = { "n", "x" },
          { "s", group = "flash" },
        },
      },
      filter = function(mapping)
        return mapping.desc and mapping.desc ~= ""
      end,

      triggers = {
        { "<auto>", mode = "nixsotc" },
        { "s", mode = { "n", "v" } },
        { "<leader>", mode = { "n", "v" } },
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
    end,
  },
  {
    "andymass/vim-matchup",
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
    "echasnovski/mini.splitjoin",
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

      nvim.create_autocmd("BufRead", {
        group = bu.nvim.augroup("bombeelu.otter"),
        callback = function(args)
          local ft = vim.filetype.match({ buf = args.buf })

          -- if not ft or vim.list_contains({ "oil" }, ft) then
          --   return
          -- end
          if
            not ft
            or not vim.list_contains({ "ruby", "eruby", "markdown", "tyescriptreact", "javascriptreact", "html" }, ft)
          then
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
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      modes = { "n", "i", "no", "c" },
      hybrid_modes = { "i", "n" },
      callbacks = {
        on_enable = function(_, win)
          vim.wo[win].conceallevel = 2
          vim.wo[win].concealcursor = "c"
        end,
      },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/Obsidian/Default",
        },
        {
          name = "work",
          path = "~/Obsidian/Work/",
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
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" },
    opts = {
      engine = "ripgrep",
    },
  },
  {
    "pwntester/octo.nvim",
    event = "VeryLazy",
    init = function()
      vim.treesitter.language.register("markdown", "octo")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      suppress_missing_scope = {
        projects_v2 = true,
      },
    },
    keys = {
      { "<leader>gi", "<cmd>Octo issue list<CR>", desc = "List Issues (Octo)" },
      { "<leader>gI", "<cmd>Octo issue search<CR>", desc = "Search Issues (Octo)" },
      { "<leader>gp", "<cmd>Octo pr list<CR>", desc = "List PRs (Octo)" },
      { "<leader>gP", "<cmd>Octo pr search<CR>", desc = "Search PRs (Octo)" },
      { "<leader>gr", "<cmd>Octo repo list<CR>", desc = "List Repos (Octo)" },
    },
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
      vim.g["chezmoi#source_dir_path"] = os.getenv("HOME") .. "/.local/share/chezmoi"
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
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
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
    "Goose97/timber.nvim",
    event = "VeryLazy",
    opts = {},
  },
  { import = "plugins.lang" },
}
