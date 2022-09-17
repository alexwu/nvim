local jump_target = require("hop.jump_target")

local M = {}

local convert_diagnostic_type = function(severities, severity)
  -- convert from string to int
  if type(severity) == "string" then
    -- make sure that e.g. error is uppercased to ERROR
    return severities[severity:upper()]
  end
  -- otherwise keep original value, incl. nil
  return severity
end

function M.diagnostics_to_tbl(opts)
  opts = vim.F.if_nil(opts, {})
  local items = {}
  local severities = vim.diagnostic.severity
  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()

  opts.severity = convert_diagnostic_type(severities, opts.severity)
  opts.severity_limit = convert_diagnostic_type(severities, opts.severity_limit)
  opts.severity_bound = convert_diagnostic_type(severities, opts.severity_bound)

  local diagnosis_opts = { severity = {}, namespace = opts.namespace }
  if opts.severity ~= nil then
    if opts.severity_limit ~= nil or opts.severity_bound ~= nil then
      vim.notify("Invalid severity parameters. Both a specific severity and a limit/bound is not allowed", "error")
      return {}
    end
    diagnosis_opts.severity = opts.severity
  else
    if opts.severity_limit ~= nil then
      diagnosis_opts.severity["min"] = opts.severity_limit
    end
    if opts.severity_bound ~= nil then
      diagnosis_opts.severity["max"] = opts.severity_bound
    end
  end

  opts.root_dir = opts.root_dir == true and vim.loop.cwd() or opts.root_dir

  local bufnr_name_map = {}
  local filter_diagnostic = function(diagnostic)
    if bufnr_name_map[diagnostic.bufnr] == nil then
      bufnr_name_map[diagnostic.bufnr] = vim.api.nvim_buf_get_name(diagnostic.bufnr)
    end

    local root_dir_test = not opts.root_dir
      or string.sub(bufnr_name_map[diagnostic.bufnr], 1, #opts.root_dir) == opts.root_dir
    local listed_test = not opts.no_unlisted or vim.api.nvim_buf_get_option(diagnostic.bufnr, "buflisted")

    return root_dir_test and listed_test
  end

  local preprocess_diagnostic = function(diagnostic)
    return {
      bufnr = diagnostic.bufnr,
      filename = bufnr_name_map[diagnostic.bufnr],
      lnum = diagnostic.lnum + 1,
      col = diagnostic.col + 1,
      text = vim.trim(diagnostic.message:gsub("[\n]", "")),
      type = severities[diagnostic.severity] or severities[1],
    }
  end

  for _, d in ipairs(vim.diagnostic.get(opts.bufnr, diagnosis_opts)) do
    if filter_diagnostic(d) then
      table.insert(items, preprocess_diagnostic(d))
    end
  end

  -- sort results by bufnr (prioritize cur buf), severity, lnum
  table.sort(items, function(a, b)
    if a.bufnr == b.bufnr then
      if a.type == b.type then
        return a.lnum < b.lnum
      else
        return a.type < b.type
      end
    else
      -- prioritize for current bufnr
      if a.bufnr == current_buf then
        return true
      end
      if b.bufnr == current_buf then
        return false
      end
      return a.bufnr < b.bufnr
    end
  end)

  return items
end

-- Wrap all the given jump targets using manh_dist
M.wrap_targets = function(targets)
  local cursor_pos = require("hop.window").get_window_context()[1].contexts[1].cursor_pos
  local indir = {}
  for i, v in ipairs(targets) do
    indir[#indir + 1] = {
      index = i,
      score = -jump_target.manh_dist({ v.line, v.column }, cursor_pos),
    }
  end
  -- local indir = setmetatable({}, zero_jump_scores)
  return {
    jump_targets = targets,
    indirect_jump_targets = indir,
  }
end
-- Allows to override global options with user local overrides.
function M.override_opts(opts)
  local hopopts = require("hop").opts
  return setmetatable(opts or {}, {
    -- __index = function(_, key)
    --   return hopopts[key]
    -- end,
    __index = hopopts,
  })
end

return M
