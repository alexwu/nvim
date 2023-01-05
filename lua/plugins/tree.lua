return {
  "kyazdani42/nvim-tree.lua",
  dependencies = { "kyazdani42/nvim-web-devicons" },
  config = function()
    local tree = require("nvim-tree")
    local lib = require("nvim-tree.lib")
    local view = require("nvim-tree.view")
    local open_file = require("nvim-tree.actions.node.open-file")
    local change_dir = require("nvim-tree.actions.root.change-dir")
    local api = require("nvim-tree.api")

    local tree_width = require("utils").tree_width

    local vinegar = nil

    local function collapse_all()
      require("nvim-tree.actions.tree-modifiers.collapse-all").fn()
    end

    local function expand_dir()
      local action = "edit"
      local node = lib.get_node_at_cursor()

      -- Just copy what's done normally with vsplit
      if node.link_to and not node.nodes then
        open_file.fn(action, node.link_to)
        view.close()
      elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)
      end
    end

    local function vsplit_preview()
      local action = "vsplit"
      local node = lib.get_node_at_cursor()

      if node.link_to and not node.nodes then
        open_file.fn(action, node.link_to)
      elseif node.nodes ~= nil then
        lib.expand_or_collapse(node)
      else
        open_file.fn(action, node.absolute_path)
      end

      view.focus()
    end

    local function collapsed_dir_up()
      lib.dir_up()
      lib.collapse_all()
    end

    local function cd_or_edit()
      local action = "edit"
      if vinegar then
        action = "edit_in_place"
      end
      local node = lib.get_node_at_cursor()

      if node.has_children then
        change_dir.fn(lib.get_last_group_node(node).absolute_path)
      elseif node.link_to and not node.nodes then
        open_file.fn(action, node.link_to)
        -- view.close()
      else
        open_file.fn(action, node.absolute_path)
      end
    end

    tree.setup({
      auto_reload_on_write = true,
      git = {
        ignore = false,
      },
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = true,
      update_cwd = true,
      respect_buf_cwd = true,
      ignore_ft_on_setup = { "startify", "dashboard", "netrw", "help" },
      view = {
        float = {
          enable = true,
          open_win_config = {
            height = math.max(vim.o.lines - 6, 20),
            width = tree_width(0.3),
            -- height = 0.9,
          },
        },
        adaptive_size = false,
        preserve_window_proportions = false,
        hide_root_folder = true,
        mappings = {
          list = {
            { key = "-", action = "dir-up", action_cb = collapsed_dir_up },
            { key = "s", action = "" },
            { key = "<C-k>", action = "" },
            { key = "<C-n>", action = "close" },
            { key = "l", action = "unroll_dir", action_cb = expand_dir },
            { key = "<CR>", action = "cd", action_cb = cd_or_edit },
            { key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
            { key = "h", action = "close_node" },
            { key = "H", action = "collapse_all", action_cb = collapse_all },
          },
        },
      },
      filters = {
        custom = { ".DS_Store", ".git" },
      },
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = { "help" },
      },
      hijack_directories = {
        enable = true,
      },
      diagnostics = {
        enable = true,
      },
      actions = {
        change_dir = {
          global = false,
          restrict_above_cwd = true,
        },
        open_file = {
          quit_on_open = true,
          resize_window = true,
          window_picker = {
            enable = false,
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = {
                "notify",
                "packer",
                "qf",
              },
            },
          },
        },
      },
      filesystem_watchers = {
        enable = true,
      },
    })

    local function toggle_replace()
      if view.is_visible() then
        view.close()
      else
        require("nvim-tree").open_replacing_current_buffer()
      end
    end

    key.map("-", function()
      vinegar = true
      toggle_replace()
    end)

    key.map("<C-n>", function()
      vinegar = false
      api.tree.toggle(true, false)
    end)
  end,
}
-- set("n", "<C-n>", "<Cmd>NvimTreeFindFile<CR>")
