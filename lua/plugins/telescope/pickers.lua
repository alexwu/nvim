local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local custom_actions = require("plugins.telescope.actions")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local Job = require("plenary.job")

local conf = require("telescope.config").values
local filter = vim.tbl_filter
local if_nil = vim.F.if_nil

local M = {}

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
  opts.should_jump = if_nil(opts.should_jump, true)

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
    local flag = bufnr == vim.fn.bufnr("") and "%" or (bufnr == vim.fn.bufnr("#") and "#" or " ")

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

  --       vim.lsp.util.jump_to_location(flattened_results[1], offset_encoding)
  if opts.should_jump and #buffers == 1 then
    local bufnr = buffers[1].bufnr
    return vim.api.nvim_set_current_buf(bufnr)
  end

  pickers
    .new(opts, {
      prompt_title = "Buffers",
      finder = finders.new_table({
        results = buffers,
        entry_maker = opts.entry_maker or make_entry.gen_from_buffer(opts),
      }),
      previewer = conf.grep_previewer(opts),
      sorter = conf.generic_sorter(opts),
      default_selection_index = default_selection_idx,
    })
    :find()
end

M.project_files = function(opts)
  opts = if_nil(opts, {})
  local ok = pcall(require("telescope.builtin").git_files, opts)
  if not ok then
    require("telescope.builtin").find_files(opts)
  end
end

M.related_files = function(opts)
  opts = if_nil(opts, {})

  pickers
    .new(opts, {
      results_title = "Related Files",
      finder = require("plugins.telescope.finders").related_files(),
      sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
    })
    :find()
end

M.snippets = function(opts)
  opts = if_nil(opts, {})

  opts.bufnr = vim.api.nvim_get_current_buf()
  opts.winnr = vim.api.nvim_get_current_win()
  opts.ft = opts.ft or vim.bo.ft

  pickers
    .new(opts, {
      results_title = "Snippets",
      finder = require("plugins.telescope.finders").luasnip(opts),
      sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
      attach_mappings = function()
        actions.select_default:replace(custom_actions.expand_snippet)
        return true
      end,
    })
    :find()
end

M.favorites = function(opts)
  opts = if_nil(opts, {})

  local favorites = if_nil(opts.favorites, {})

  opts.bufnr = vim.api.nvim_get_current_buf()
  opts.winnr = vim.api.nvim_get_current_win()
  opts.ft = vim.bo.ft

  pickers
    .new(opts, {
      prompt_title = "Favorites",
      finder = finders.new_table({
        results = favorites,
        entry_maker = function(entry)
          return {
            value = entry,
            text = entry.name,
            display = entry.name,
            ordinal = entry.name,
            filename = nil,
          }
        end,
      }),
      previewer = false,
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(_)
        actions.select_default:replace(function(_)
          local selection = action_state.get_selected_entry()
          if not selection then
            vim.notify("[telescope] Nothing currently selected")
            return
          end

          selection.value.callback(opts)
        end)
        return true
      end,
    })
    :find()
end

M.default_branch = nil
M.cwd = vim.loop.cwd()

---@param async boolean
function M.get_default_branch(opts)
  opts = if_nil(opts, {})

  if not opts.force and M.default_branch ~= nil and M.cwd == vim.loop.cwd() then
    return M.default_branch
  end

  local job = Job:new({
    command = "gh",
    args = {
      "repo",
      "view",
      "--json",
      "defaultBranchRef",
      "--jq",
      ".defaultBranchRef.name",
    },
    cwd = vim.loop.cwd(),
    on_exit = function(j, data)
      if data == 0 then
        local result = j:result()
        M.default_branch = result[1]
      end
    end,
  })

  if opts.async then
    job:start()
  else
    job:sync()
  end
end

function M.git_changes(opts)
  opts = if_nil(opts, {})

  local default_branch = M.get_default_branch()

  pickers
    .new(opts, {
      prompt_title = "Git Changes",
      previewer = conf.file_previewer(opts),
      sorter = conf.generic_sorter(opts),
      finder = finders.new_oneshot_job({
        "git",
        "diff",
        "--name-only",
        "--diff-filter=ACMRTUXB",
        default_branch,
      }, {
        entry_maker = opts.entry_maker or make_entry.gen_from_file(opts),
      }),
    })
    :find()
end

-- previewer = previewers.new_buffer_previewer {
--   define_preview = function(self, entry, status)
--      -- Execute another command using the highlighted entry
--     return require('telescope.previewers.utils').job_maker(
--         {"terraform", "state", "list", entry.value},
--         self.state.bufnr,
--         {
--           callback = function(bufnr, content)
--             if content ~= nil then
--               require('telescope.previewers.utils').regex_highlighter(bufnr, 'terraform')
--             end
--           end,
--         })
--   end
--   }

return M
