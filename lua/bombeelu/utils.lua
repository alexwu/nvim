local if_nil = vim.F.if_nil
local mk_repeatable = require("bombeelu.repeat").mk_repeatable
local uv = vim.loop
local fs = vim.fs

local has_legendary, legendary = pcall(require, "legendary")

local a = require("plenary.async")

local M = {}

-- NOTE: The lazy helpers are from here: https://github.com/mrjones2014/legendary.nvim/blob/master/lua/legendary/helpers.lua
function M.lazy(fn, ...)
  local args = { ... }
  return function()
    fn(unpack(args))
  end
end

function M.lazy_required_fn(module_name, fn_name, ...)
  local args = { ... }
  return function()
    ((_G["require"](module_name))[fn_name])(unpack(args))
  end
end

local has_plenary, functional = pcall(require, "plenary.functional")
if has_plenary then
  M.F = functional
end

---@param modes string|string[]
---@param mappings string|string[]
---@param callback string|function
---@param opts? table
function M.set(modes, mappings, callback, opts)
  opts = if_nil(opts, {})
  if type(mappings) == "string" then
    mappings = { mappings }
  end

  local maps = vim.tbl_map(function(mapping)
    if has_legendary then
      local description = if_nil(opts.desc, "")
      return { mapping, callback, mode = modes, description = description, opts = opts }
    else
      vim.keymap.set(modes, mapping, callback, opts)
    end
  end, mappings)

  if has_legendary then
    legendary.keymaps(maps)
  end
end

---@param mappings string|string[]
---@param callback string|function
---@param opts? table
function M.keymap(mappings, callback, opts)
  opts = if_nil(opts, {})
  local modes = if_nil(opts.modes, { "n" })
  if type(modes) == "string" then
    modes = { modes }
  end
  opts.modes = nil

  if type(mappings) == "string" then
    mappings = { mappings }
  end

  local maps = vim.tbl_map(function(mapping)
    return { mapping, callback, mode = modes, opts = opts }
  end, mappings)

  legendary.keymaps(maps)
end

local function starts_with(str, start)
  return str:sub(1, #start) == start
end

local function ends_with(str, ending)
  return ending == "" or str:sub(-#ending) == ending
end

local function needs_command_wrapping(str)
  if type(str) ~= "string" then
    return false
  end

  return not starts_with(str, ":") and not starts_with(string, "<")
end

function M.nmap(lhs, rhs, opts, copts)
  opts = if_nil(opts, {})
  copts = if_nil(copts, {})

  local should_repeat = if_nil(copts.should_repeat, false)

  if type(rhs) == "function" then
    if should_repeat then
      rhs = mk_repeatable(M.lazy(rhs))
    else
      rhs = M.lazy(rhs)
    end
  elseif type(rhs) == "string" then
  end

  M.set("n", lhs, rhs, opts)
end

---@param name string
---@return string
function M.ex(name)
  return string.format("<CMD>%s<CR>", name)
end

---@param name string
---@return string
function M.leader(name)
  return string.format("<Leader>%s", name)
end

--- NOTE: Remove when upstreamed: https://github.com/neovim/neovim/pull/13896/files
--- Get the region between two marks and the start and end positions for the region
---
--@param mark1 Name of mark starting the region
--@param mark2 Name of mark ending the region
--@param options Table containing the adjustment function, register type and selection mode
--@return region region between the two marks, as returned by |vim.region|
--@return start (row,col) tuple denoting the start of the region
--@return finish (row,col) tuple denoting the end of the region
function M.get_marked_region(mark1, mark2, options)
  options = if_nil(options, {})
  local bufnr = 0
  local adjust = options.adjust or function(pos1, pos2)
    return pos1, pos2
  end
  local regtype = options.regtype or vim.fn.visualmode()
  local selection = options.selection or (vim.o.selection ~= "exclusive")

  local pos1 = vim.fn.getpos(mark1)
  local pos2 = vim.fn.getpos(mark2)
  pos1, pos2 = adjust(pos1, pos2)

  local start = { pos1[2] - 1, pos1[3] - 1 + pos1[4] }
  local finish = { pos2[2] - 1, pos2[3] - 1 + pos2[4] }

  -- Return if start or finish are invalid
  if start[2] < 0 or finish[1] < start[1] then
    return
  end

  local region = vim.region(bufnr, start, finish, regtype, selection)
  return region, start, finish
end

--- Get the current visual selection as a string
---
--@return selection string containing the current visual selection
function M.get_visual_selection()
  local bufnr = 0
  local visual_modes = {
    v = true,
    V = true,
    -- [t'<C-v>'] = true, -- Visual block does not seem to be supported by vim.region
  }

  -- Return if not in visual mode
  if visual_modes[vim.api.nvim_get_mode().mode] == nil then
    return
  end

  local options = {}
  options.adjust = function(pos1, pos2)
    if vim.fn.visualmode() == "V" then
      pos1[3] = 1
      pos2[3] = 2 ^ 31 - 1
    end

    if pos1[2] > pos2[2] then
      pos2[3], pos1[3] = pos1[3], pos2[3]
      return pos2, pos1
    elseif pos1[2] == pos2[2] and pos1[3] > pos2[3] then
      return pos2, pos1
    else
      return pos1, pos2
    end
  end

  local region, start, finish = M.get_marked_region("v", ".", options)

  -- Compute the number of chars to get from the first line,
  -- because vim.region returns -1 as the ending col if the
  -- end of the line is included in the selection
  local lines = vim.api.nvim_buf_get_lines(bufnr, start[1], finish[1] + 1, false)
  local line1_end
  if region[start[1]][2] - region[start[1]][1] < 0 then
    line1_end = #lines[1] - region[start[1]][1]
  else
    line1_end = region[start[1]][2] - region[start[1]][1]
  end

  lines[1] = vim.fn.strpart(lines[1], region[start[1]][1], line1_end, true)
  if start[1] ~= finish[1] then
    lines[#lines] = vim.fn.strpart(lines[#lines], region[finish[1]][1], region[finish[1]][2] - region[finish[1]][1])
  end
  return table.concat(lines)
end

function M.get_selection_range()
  local bufnr = 0
  local visual_modes = {
    v = true,
    -- V = true,
    -- [t'<C-v>'] = true, -- Visual block does not seem to be supported by vim.region
  }

  -- Return if not in visual mode
  if visual_modes[vim.api.nvim_get_mode().mode] == nil then
    return
  end

  local options = {}
  options.adjust = function(pos1, pos2)
    if vim.fn.visualmode() == "V" then
      pos1[3] = 1
      pos2[3] = 2 ^ 31 - 1
    end

    if pos1[2] > pos2[2] then
      pos2[3], pos1[3] = pos1[3], pos2[3]
      return pos2, pos1
    elseif pos1[2] == pos2[2] and pos1[3] > pos2[3] then
      return pos2, pos1
    else
      return pos1, pos2
    end
  end

  local region, start, finish = M.get_marked_region("v", ".", options)

  return { start_row = start[1], start_col = start[2], end_row = finish[1], end_col = finish[2] }
  -- -- Compute the number of chars to get from the first line,
  -- -- because vim.region returns -1 as the ending col if the
  -- -- end of the line is included in the selection
  -- local lines = vim.api.nvim_buf_get_lines(bufnr, start[1], finish[1] + 1, false)
  -- local line1_end
  -- if region[start[1]][2] - region[start[1]][1] < 0 then
  --   line1_end = #lines[1] - region[start[1]][1]
  -- else
  --   line1_end = region[start[1]][2] - region[start[1]][1]
  -- end
  --
  -- lines[1] = vim.fn.strpart(lines[1], region[start[1]][1], line1_end, true)
  -- if start[1] ~= finish[1] then
  --   lines[#lines] = vim.fn.strpart(lines[#lines], region[finish[1]][1], region[finish[1]][2] - region[finish[1]][1])
  -- end
  -- return table.concat(lines)
end

function M.map(fun, iter)
  vim.validate({ fun = { fun, "c" }, iter = { iter, "t" } })

  if vim.tbl_islist(iter) then
    local results = {}
    for _, v in ipairs(iter) do
      table.insert(results, fun(v))
    end

    return results
  else
    local rettab = {}
    for k, v in pairs(iter) do
      rettab[k] = fun(v)
    end
    return rettab
  end
end

function M.flatten(t)
  local result = {}
  local function _tbl_flatten(_t)
    local n = #_t
    for i = 1, n do
      local v = _t[i]
      if vim.tbl_islist(v) then
        _tbl_flatten(v)
      elseif v then
        table.insert(result, v)
      end
    end
  end
  _tbl_flatten(t)
  return result
end

-- NOTE: pos is currently 1 indexed cause lua. Should i handle that outside this function?
M.insert_text = function(text, pos, opts)
  opts = if_nil(opts, {})
  pos = if_nil(pos, vim.api.nvim_win_get_cursor(0))

  local bufnr = if_nil(opts.bufnr, 0)

  vim.api.nvim_buf_set_text(bufnr, pos[1] - 1, pos[2], pos[1] - 1, pos[2], { text })
end

local function can_merge(v)
  return type(v) == "table" and (vim.tbl_isempty(v) or not vim.tbl_islist(v))
end

local function tbl_extend(behavior, deep_extend, ...)
  if behavior ~= "error" and behavior ~= "keep" and behavior ~= "force" then
    error('invalid "behavior": ' .. tostring(behavior))
  end

  if select("#", ...) < 2 then
    error("wrong number of arguments (given " .. tostring(1 + select("#", ...)) .. ", expected at least 3)")
  end

  local ret = {}
  if vim._empty_dict_mt ~= nil and getmetatable(select(1, ...)) == vim._empty_dict_mt then
    ret = vim.empty_dict()
  end

  for i = 1, select("#", ...) do
    local tbl = select(i, ...)
    vim.validate({ ["after the second argument"] = { tbl, "t" } })
    if tbl then
      for k, v in pairs(tbl) do
        if deep_extend and can_merge(v) and can_merge(ret[k]) then
          ret[k] = tbl_extend(behavior, true, ret[k], v)
        elseif behavior ~= "force" and ret[k] ~= nil then
          if behavior == "error" then
            error("key found in more than one map: " .. k)
          end -- Else behavior is "keep".
        else
          ret[k] = v
        end
      end
    end
  end
  return ret
end

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type, in which case they override the values on the left.
--- Values will me merged in-place in the first left-most table. If you want the result to be in
--- a new table, then simply pass an empty table as the first argument `vim.merge({}, ...)`
function M.merge(...)
  local values = { ... }
  local ret = values[1]
  for i = 2, #values, 1 do
    local value = values[i]
    if can_merge(ret) and can_merge(value) then
      for k, v in pairs(value) do
        ret[k] = M.merge(ret[k], v)
      end
    else
      ret = value
    end
  end
  return ret
end

M.path = (function()
  local is_windows = uv.os_uname().version:match("Windows")

  local function sanitize(path)
    if is_windows then
      path = path:sub(1, 1):upper() .. path:sub(2)
      path = path:gsub("\\", "/")
    end
    return path
  end

  local function exists(filename)
    local stat = uv.fs_stat(filename)
    return stat and stat.type or false
  end

  local function is_dir(filename)
    return exists(filename) == "directory"
  end

  local function is_file(filename)
    return exists(filename) == "file"
  end

  local function is_fs_root(path)
    if is_windows then
      return path:match("^%a:$")
    else
      return path == "/"
    end
  end

  local function is_absolute(filename)
    if is_windows then
      return filename:match("^%a:") or filename:match("^\\\\")
    else
      return filename:match("^/")
    end
  end

  local function path_join(...)
    return table.concat(vim.tbl_flatten({ ... }), "/")
  end

  -- Traverse the path calling cb along the way.
  local function traverse_parents(path, cb)
    path = uv.fs_realpath(path)
    local dir = path
    -- Just in case our algo is buggy, don't infinite loop.
    for _ = 1, 100 do
      dir = fs.dirname(dir)
      if not dir then
        return
      end
      -- If we can't ascend further, then stop looking.
      if cb(dir, path) then
        return dir, path
      end
      if is_fs_root(dir) then
        break
      end
    end
  end

  -- Iterate the path until we find the rootdir.
  local function iterate_parents(path)
    local function it(_, v)
      if v and not is_fs_root(v) then
        v = fs.dirname(v)
      else
        return
      end
      if v and uv.fs_realpath(v) then
        return v, path
      else
        return
      end
    end
    return it, path, path
  end

  local function is_descendant(root, path)
    if not path then
      return false
    end

    local function cb(dir, _)
      return dir == root
    end

    local dir, _ = traverse_parents(path, cb)

    return dir == root
  end

  local path_separator = is_windows and ";" or ":"

  local function read_async(path, callback)
    local err, fd = a.uv.fs_open(path, "r", 438)
    assert(not err, err)

    local err, stat = a.uv.fs_fstat(fd)
    assert(not err, err)

    local err, data = a.uv.fs_read(fd, stat.size, 0)
    assert(not err, err)

    local err = a.uv.fs_close(fd)
    assert(not err, err)

    return callback(data)
  end

  local function read(path, callback)
    if callback then
      read_async(path, callback)
    else
      local fd = assert(uv.fs_open(path, "r", 438))
      local stat = assert(uv.fs_fstat(fd))
      local data = assert(uv.fs_read(fd, stat.size, 0))
      assert(uv.fs_close(fd))
      return data
    end
  end

  return {
    is_dir = is_dir,
    is_file = is_file,
    is_absolute = is_absolute,
    exists = exists,
    dirname = fs.dirname,
    join = path_join,
    sanitize = sanitize,
    traverse_parents = traverse_parents,
    iterate_parents = iterate_parents,
    is_descendant = is_descendant,
    path_separator = path_separator,
    read = read,
  }
end)()

function M.search_ancestors(startpath, func)
  vim.validate({ func = { func, "f" } })
  if func(startpath) then
    return startpath
  end
  local guard = 100
  for path in M.path.iterate_parents(startpath) do
    -- Prevent infinite recursion if our algorithm breaks
    guard = guard - 1
    if guard == 0 then
      return
    end

    if func(path) then
      return path
    end
  end
end

function M.root_pattern(...)
  local patterns = vim.tbl_flatten({ ... })
  local function matcher(path)
    for _, pattern in ipairs(patterns) do
      for _, p in ipairs(vim.fn.glob(M.path.join(path, pattern), true, true)) do
        if M.path.exists(p) then
          return path
        end
      end
    end
  end
  return function(startpath)
    return M.search_ancestors(startpath, matcher)
  end
end

function M.find_git_ancestor(startpath)
  return M.search_ancestors(startpath, function(path)
    -- Support git directories and git files (worktrees)
    if M.path.is_dir(M.path.join(path, ".git")) or M.path.is_file(M.path.join(path, ".git")) then
      return path
    end
  end)
end

function M.find_node_modules(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_dir(M.path.join(path, "node_modules")) then
      return path
    end
  end)
end

function M.find_package_json(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_file(M.path.join(path, "package.json")) then
      return path
    end
  end)
end

function M.find_makefile(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_file(M.path.join(path, "Makefile")) then
      return path
    end
  end)
end

function M.find_gemfile(startpath)
  return M.search_ancestors(startpath, function(path)
    if M.path.is_dir(M.path.join(path, "Gemfile")) then
      return path
    end
  end)
end

-- https://github.com/LazyVim/LazyVim/blob/e049928b8bb3a385a186617a97c56cfb8f74a6f8/lua/lazyvim/util/init.lua

local Util = require("lazy.core.util")

M.root_patterns = { ".git", "lua" }

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

function M.fg(name)
  ---@type {foreground?:number}?
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  local fg = hl and hl.fg or hl.foreground
  return fg and { fg = string.format("#%06x", fg) }
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
function M.get_root()
  ---@type string?
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  ---@type string[]
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace and vim.tbl_map(function(ws)
        return vim.uri_to_fname(ws.uri)
      end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  ---@type string?
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    ---@type string?
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  ---@cast root string
  return root
end

-- this will return a function that calls telescope.
-- cwd will default to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      opts.attach_mappings = function(_, map)
        map("i", "<a-c>", function()
          local action_state = require("telescope.actions.state")
          local line = action_state.get_current_line()
          M.telescope(
            params.builtin,
            vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
          )()
        end)
        return true
      end
    end

    require("telescope.builtin")[builtin](opts)
  end
end

---@type table<string,LazyFloat>
local terminals = {}

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyCmdOptions|{interactive?:boolean, esc_esc?:false}
function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    ft = "lazyterm",
    size = { width = 0.9, height = 0.9 },
  }, opts or {}, { persistent = true })
  ---@cast opts LazyCmdOptions|{interactive?:boolean, esc_esc?:false}

  local termkey = vim.inspect({ cmd = cmd or "shell", cwd = opts.cwd, env = opts.env })

  if terminals[termkey] and terminals[termkey]:buf_valid() then
    terminals[termkey]:toggle()
  else
    terminals[termkey] = require("lazy.util").float_term(cmd, opts)
    local buf = terminals[termkey].buf
    vim.b[buf].lazyterm_cmd = cmd
    if opts.esc_esc == false then
      vim.keymap.set("t", "<esc>", "<esc>", { buffer = buf, nowait = true })
    end
    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end

  return terminals[termkey]
end

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.toggle(option, silent, values)
  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end
    return Util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      Util.info("Enabled " .. option, { title = "Option" })
    else
      Util.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local enabled = true
function M.toggle_diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    Util.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    Util.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

function M.deprecate(old, new)
  Util.warn(("`%s` is deprecated. Please use `%s` instead"):format(old, new), { title = "LazyVim" })
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = vim.loop.new_check()

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

function M.lsp_get_config(server)
  local configs = require("lspconfig.configs")
  return rawget(configs, server)
end

---@param server string
---@param cond fun( root_dir, config): boolean
function M.lsp_disable(server, cond)
  local util = require("lspconfig.util")
  local def = M.lsp_get_config(server)
  def.document_config.on_new_config = util.add_hook_before(def.document_config.on_new_config, function(config, root_dir)
    if cond(root_dir, config) then
      config.enabled = false
    end
  end)
end

return M
