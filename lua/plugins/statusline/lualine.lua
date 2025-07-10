local u = require("bombeelu.root")

local colors = {
  background = "#282a36",
  foreground = "#eff0eb",
  black = "#282a36",
  red = "#ff5c57",
  green = "#5af78e",
  yellow = "#f3f99d",
  blue = "#57c7ff",
  purple = "#ff6ac1",
  cyan = "#9aedfe",
  white = "#f1f1f0",
  lightgray = "#b1b1b1",
  darkgray = "#3a3d4d",
}

local snazzy = function()
  return {
    normal = {
      a = { bg = colors.blue, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    insert = {
      a = { bg = colors.green, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    visual = {
      a = { bg = colors.purple, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    replace = {
      a = { bg = colors.red, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    command = {
      a = { bg = colors.yellow, fg = colors.black, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.white },
      c = { bg = colors.darkgray, fg = colors.lightgray },
    },
    inactive = {
      a = { bg = colors.darkgray, fg = colors.gray, gui = "bold" },
      b = { bg = colors.lightgray, fg = colors.gray },
      c = { bg = colors.darkgray, fg = colors.darkgray },
    },
  }
end

local function ui_fg(name)
  ---@type {foreground?:number}?
  ---@diagnostic disable-next-line: deprecated
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  ---@diagnostic disable-next-line: undefined-field
  local fg = hl and (hl.fg or hl.foreground)
  return fg and { fg = string.format("#%06x", fg) } or nil
end

---@param component any
---@param text string
---@param hl_group? string
---@return string
local function format(component, text, hl_group)
  if not hl_group then
    return text
  end
  ---@type table<string, string>
  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]
  if not lualine_hl_group then
    local utils = require("lualine.utils.utils")
    lualine_hl_group = component:create_hl({ fg = utils.extract_highlight_colors(hl_group, "fg") }, "LV_" .. hl_group)
    component.hl_cache[hl_group] = lualine_hl_group
  end
  return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

---@param opts? {relative: "cwd"|"root", modified_hl: string?}
local function pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "Constant",
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p") --[[@as string]]

    if path == "" then
      return ""
    end
    local root = u.get({ normalize = true })
    local cwd = u.cwd()

    if opts.relative == "cwd" and path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    else
      path = path:sub(#root + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")
    if #parts > 3 then
      parts = { parts[1], "…", parts[#parts - 1], parts[#parts] }
    end

    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = format(self, parts[#parts], opts.modified_hl)
    end

    return table.concat(parts, sep)
  end
end

---@param opts? {cwd:false, subdirectory: true, parent: true, other: true, icon?:string}
local function root_dir(opts)
  opts = vim.tbl_extend("force", {
    cwd = false,
    subdirectory = true,
    parent = true,
    other = true,
    icon = "󱉭 ",
    color = ui_fg("Special"),
  }, opts or {})

  local function get()
    local cwd = u.cwd()
    local root = u.get({ normalize = true })
    local name = vim.fs.basename(root)

    if root == cwd then
      -- root is cwd
      return opts.cwd and name
    elseif root:find(cwd, 1, true) == 1 then
      -- root is subdirectory of cwd
      return opts.subdirectory and name
    elseif cwd:find(root, 1, true) == 1 then
      -- root is parent directory of cwd
      return opts.parent and name
    else
      -- root and cwd are not related
      return opts.other and name
    end
  end

  return {
    function()
      return (opts.icon and opts.icon .. " ") .. get()
    end,
    cond = function()
      return type(get()) == "string"
    end,
    color = opts.color,
  }
end

require("lualine").setup({
  options = {
    theme = snazzy(),
    disabled_filetypes = {
      statusline = {
        "dashboard",
        "alpha",
        "starter",
        "snacks_dashboard",
      },
      winbar = { "neo-tree" },
    },
    component_separators = "|",
    section_separators = { left = "", right = "" },
    globalstatus = true,
  },
  extensions = {
    "fzf",
    "fugitive",
    "quickfix",
    "neo-tree",
    "lazy",
    "trouble",
    "oil",
    "nvim-dap-ui",
    "overseer",
    "toggleterm",
    "man",
    "mason",
    "trouble",
  },
  sections = {
    lualine_a = {
      {
        "mode",
        -- separator = { left = "" },
        separator = {},
        right_padding = 2,
      },
    },
    lualine_b = {
      { "branch", color = { fg = "#3a3d4d", bg = "#f1f1f0" }, separator = { right = "" } },
    },
    lualine_c = {
      root_dir(),
      {
        "filetype",
        icon_only = true,
        separator = "",
        padding = { left = 1, right = 0 },
      },
      -- { pretty_path() },
      {
        "filename",
        color = { fg = colors.white },
        symbols = {
          modified = "[+]",
          readonly = "[-]",
          unnamed = "",
          newfile = "[New]",
        },
      },
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn", "info", "hint" },

        -- diagnostics_color = {
        --   error = "DiagnosticError",
        --   warn = "DiagnosticWarn",
        --   info = "DiagnosticInfo",
        --   hint = "DiagnosticHint",
        -- },
        symbols = { error = " ", warn = " ", info = " ", hint = " " },
        colored = true,
        update_in_insert = false,
        always_visible = false,
      },

      { require("doing").status },
    },
    lualine_x = {
      {
        function()
          return require("noice").api.status.command.get()
        end,
        cond = function()
          return package.loaded["noice"] and require("noice").api.status.command.has()
        end,
        color = { fg = "#ff9e64" },
      },
      {
        function()
          return require("noice").api.status.mode.get()
        end,
        cond = function()
          return package.loaded["noice"] and require("noice").api.status.mode.has()
        end,
        color = { fg = "#ff9e64" },
      },
      {
        function()
          return "  " .. require("dap").status()
        end,
        cond = function()
          return package.loaded["dap"] and require("dap").status() ~= ""
        end,
        color = { fg = "#ff9e64" },
      },
      {
        require("lazy.status").updates,
        cond = require("lazy.status").has_updates,
        color = { fg = "#ff9e64" },
      },
      {
        "diff",
        symbols = {
          added = " ",
          modified = " ",
          removed = " ",
        },
        source = function()
          local gitsigns = vim.b.gitsigns_status_dict
          if gitsigns then
            return {
              added = gitsigns.added,
              modified = gitsigns.changed,
              removed = gitsigns.removed,
            }
          end
        end,
      },
    },
    lualine_y = {
      {
        "overseer",
      },
      {
        "codecompanion",
      },
    },
    -- lualine_z = { { "location", separator = { right = "", left = "" } } },
    lualine_z = { { "location", separator = { left = "" } } },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
  winbar = {},
  inactive_winbar = {},
})
