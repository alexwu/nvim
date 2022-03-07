local M = {}
local pickers = require "telescope.pickers"
local sorters = require "telescope.sorters"
local finders = require "telescope.finders"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local action_set = require "telescope.actions.set"
local custom_actions = require "plugins.telescope.actions"
local make_entry = require "telescope.make_entry"
local conf = require("telescope.config").values

local filter = vim.tbl_filter

local function apply_cwd_only_aliases(opts)
  local has_cwd_only = opts.cwd_only ~= nil
  local has_only_cwd = opts.only_cwd ~= nil

  if has_only_cwd and not has_cwd_only then
    -- Internally, use cwd_only
    opts.cwd_only = opts.only_cwd
    opts.only_cwd = nil
  end

  return opts
end

M.buffers = function(opts)
  opts = apply_cwd_only_aliases(opts)
  local bufnrs = filter(function(b)
    if 1 ~= vim.fn.buflisted(b) then
      return false
    end
    -- only hide unloaded buffers if opts.show_all_buffers is false, keep them listed if true or nil
    if opts.show_all_buffers == false and not vim.api.nvim_buf_is_loaded(b) then
      return false
    end
    if opts.ignore_current_buffer and b == vim.api.nvim_get_current_buf() then
      return false
    end
    if opts.cwd_only and not string.find(vim.api.nvim_buf_get_name(b), vim.loop.cwd(), 1, true) then
      return false
    end
    return true
  end, vim.api.nvim_list_bufs())
  if not next(bufnrs) then
    return
  end
  if opts.sort_mru then
    table.sort(bufnrs, function(a, b)
      return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
    end)
  end

  local buffers = {}
  local default_selection_idx = 1
  for _, bufnr in ipairs(bufnrs) do
    local flag = bufnr == vim.fn.bufnr "" and "%" or (bufnr == vim.fn.bufnr "#" and "#" or " ")

    if opts.sort_lastused and not opts.ignore_current_buffer and flag == "#" then
      default_selection_idx = 2
    end

    local element = {
      bufnr = bufnr,
      flag = flag,
      info = vim.fn.getbufinfo(bufnr)[1],
    }

    if opts.sort_lastused and (flag == "#" or flag == "%") then
      local idx = ((buffers[1] ~= nil and buffers[1].flag == "%") and 2 or 1)
      table.insert(buffers, idx, element)
    else
      table.insert(buffers, element)
    end
  end

  if not opts.bufnr_width then
    local max_bufnr = math.max(unpack(bufnrs))
    opts.bufnr_width = #tostring(max_bufnr)
  end

  if #buffers == 1 then
    local bufnr = buffers[1].bufnr
    return vim.api.nvim_set_current_buf(bufnr)
  end

  pickers.new(opts, {
    prompt_title = "Buffers",
    finder = finders.new_table {
      results = buffers,
      entry_maker = opts.entry_maker or make_entry.gen_from_buffer(opts),
    },
    previewer = conf.grep_previewer(opts),
    sorter = conf.generic_sorter(opts),
    default_selection_index = default_selection_idx,
  }):find()
end

M.project_files = function(opts)
  opts = opts or {}
  local ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    require("telescope.builtin").find_files(opts)
  end
end

M.related_files = function()
  pickers.new({
    results_title = "Related Files",
    finder = require("plugins.telescope.finders").related_files(),
    sorter = sorters.get_fuzzy_file(),
  }):find()
end

M.snippets = function()
  pickers.new({
    results_title = "Snippets",
    finder = require("plugins.telescope.finders").luasnip(),
    sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
    attach_mappings = function(_, map)
      actions.select_default:replace(custom_actions.expand_snippet)
      return true
    end,
  }):find()
end

return M
