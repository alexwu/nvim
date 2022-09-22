local null_ls = require("null-ls")
local on_attach = require("plugins.lsp.defaults").on_attach
local Path = require("plenary.path")

local M = {}

local default_severities = {
  ["error"] = 1,
  ["warning"] = 2,
  ["information"] = 3,
  ["hint"] = 4,
}

local default_json_attributes = {
  row = "line",
  col = "column",
  end_row = "endLine",
  end_col = "endColumn",
  code = "ruleId",
  severity = "level",
  message = "message",
  path = "path",
}

-- User defined diagnostic attribute adapters
local diagnostic_adapters = {
  end_col = {
    from_quote = {
      end_col = function(entries, line)
        local end_col = entries["end_col"]
        local quote = entries["_quote"]
        if end_col or not quote or not line then
          return end_col
        end

        _, end_col = line:find(quote, 1, true)
        if end_col and end_col > tonumber(entries["col"]) then
          return end_col + 1
        end
      end,
    },
    from_length = {
      end_col = function(entries)
        local col = tonumber(entries["col"])
        local length = tonumber(entries["_length"])
        return col + length
      end,
    },
  },
}

local make_attr_adapters = function(severities, user_adapters)
  local adapters = {
    severity = function(entries, _)
      return severities[entries["severity"]] or severities["_fallback"]
    end,
  }
  for _, adapter in ipairs(user_adapters) do
    adapters = vim.tbl_extend("force", adapters, adapter)
  end

  return adapters
end

local make_diagnostic = function(entries, defaults, attr_adapters, params, offsets)
  if not entries["message"] then
    return nil
  end

  local content_line = params.content and params.content[tonumber(entries["row"])] or nil
  for attr, adapter in pairs(attr_adapters) do
    entries[attr] = adapter(entries, content_line)
  end

  -- Unset private attributes
  for k, _ in pairs(entries) do
    if k:find("^_") then
      entries[k] = nil
    end
  end

  local diagnostic = vim.tbl_extend("keep", defaults, entries)
  for k, offset in pairs(offsets) do
    diagnostic[k] = diagnostic[k] and diagnostic[k] + offset
  end
  return diagnostic
end

--- Parse a linter's output in JSON format
-- @param overrides A table providing overrides for {adapters, diagnostic, severities, offsets}
-- @param overrides.attributes An optional table of JSON to diagnostic attributes (see default_json_attributes)
-- @param overrides.diagnostic An optional table of diagnostic default values
-- @param overrides.severities An optional table of severity overrides (see default_severities)
-- @param overrides.adapters An optional table of adapters from JSON entries to diagnostic attributes
-- @param overrides.offsets An optional table of offsets to apply to diagnostic ranges
local from_json = function(overrides)
  overrides = overrides or {}
  local attributes = vim.tbl_extend("force", default_json_attributes, overrides.attributes or {})
  local severities = vim.tbl_extend("force", default_severities, overrides.severities or {})
  local defaults = overrides.diagnostic or {}
  local offsets = overrides.offsets or {}
  local attr_adapters = make_attr_adapters(severities, overrides.adapters or {})

  return function(params)
    local diagnostics = {}
    for _, json_diagnostic in ipairs(params.output) do
      local entries = {}
      for attr, json_key in pairs(attributes) do
        if json_diagnostic[json_key] ~= vim.NIL then
          entries[attr] = json_diagnostic[json_key]
        end
      end

      local diagnostic = make_diagnostic(entries, defaults, attr_adapters, params, offsets)
      local bufpath = vim.api.nvim_buf_get_name(0)

      local absolute_path = Path:new(diagnostic.path):absolute()

      if diagnostic and absolute_path == bufpath then
        vim.pretty_print(absolute_path)
        table.insert(diagnostics, diagnostic)
      end
    end

    return diagnostics
  end
end

local gh_comments = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact", "ruby" },
  generator = null_ls.generator({
    command = "gh",
    args = { "comments" },
    to_stdin = true,
    from_stderr = false,
    format = "json",
    -- check_exit_code = function(code, stderr)
    --   local success = code <= 1
    --
    --   if not success then
    --     -- can be noisy for things that run often (e.g. diagnostics), but can
    --     -- be useful for things that run on demand (e.g. formatting)
    --     print(stderr)
    --   end
    --
    --   return success
    -- end,
    -- use helpers to parse the output from string matchers,
    -- or parse it manually with a function
    on_output = from_json({
      attributes = {
        row = "line",
        col = "column",
        code = "ruleId",
        severity = "level",
        message = "body",
      },
      severities = {
        ["_fallback"] = "info",
      },
    }),
  }),
}

null_ls.register(gh_comments)

M.setup = function(opts)
  opts = opts or {}

  null_ls.setup({
    debug = true,
    sources = {
      -- null_ls.builtins.formatting.pg_format,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.clang_format,
      null_ls.builtins.formatting.just,
      -- null_ls.builtins.formatting.deno_fmt.with({
      --   filetypes = { "javascriptreact", "typescriptreact" },
      --   extra_args = { "--options-line-width", 100 },
      -- }),
      null_ls.builtins.formatting.dprint.with({
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "toml", "json" },
      }),
      null_ls.builtins.formatting.prettier.with({
        prefer_local = "node_modules/.bin",
      }),
      null_ls.builtins.formatting.rustywind,
      null_ls.builtins.diagnostics.zsh,
      null_ls.builtins.diagnostics.selene.with({
        cwd = function(_params)
          return vim.fs.dirname(
            vim.fs.find({ "selene.toml" }, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
          ) or vim.fn.expand("~/.config/nvim/selene.toml")
        end,
      }),
      require("plugins.lsp.null-ls.code_actions.selene").with({
        cwd = function(_params)
          return vim.fs.dirname(
            vim.fs.find({ "selene.toml" }, { upward = true, path = vim.api.nvim_buf_get_name(0) })[1]
          ) or vim.fs.normalize("~/.config/nvim/selene.toml") -- fallback value
        end,
      }),
      null_ls.builtins.diagnostics.luacheck.with({
        condition = function(utils)
          return utils.root_has_file({ ".luacheckrc" })
        end,
      }),
      null_ls.builtins.formatting.stylua,
      -- null_ls.builtins.code_actions.gitsigns,
    },
    on_attach = on_attach,
    should_attach = function(bufnr)
      return vim.bo[bufnr].buftype ~= "nofile"
    end,
  })
end

return M
