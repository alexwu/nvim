local if_nil = vim.F.if_nil

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

M.F = require("plenary.functional")

---@param modes string|string[]
---@param mappings string|string[]
---@param callback string|function
---@param opts? table
function M.set(modes, mappings, callback, opts)
  if type(mappings) == "string" then
    mappings = { mappings }
  end

  vim.tbl_map(function(mapping)
    vim.keymap.set(modes, mapping, callback, opts)
  end, mappings)
end

-- TODO: MEH, come up with something better
-- function M.map(lhs, rhs, opts)
--   opts = if_nil(opts, {})
--   local modes = if_nil(vim.deepcopy(opts.modes), { "n" })
--   local args = vim.deepcopy(opts.args)
--   opts.modes = nil
--   opts.args = nil
--
--   if type(rhs) == "function" then
--     rhs = M.lazy(rhs, args)
--   end
--
--   M.set(modes, lhs, rhs, opts)
-- end
--
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

function M.nmap(lhs, rhs, opts)
  opts = if_nil(opts, {})

  if type(rhs) == "function" then
    rhs = M.lazy(rhs)
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

-- M.root_pattern = require("lspconfig").util.root_pattern

return M
