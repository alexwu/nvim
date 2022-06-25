local h = require("null-ls.helpers")
local methods = require("null-ls.methods")

local CODE_ACTION = methods.internal.CODE_ACTION

local api = vim.api

local is_fixable = function(problem, row)
  if not problem or not row then
    return false
  end
  local span = problem.primary_label.span

  if span.end_line then
    return span.start_line + 1 <= row and span.end_line + 1 >= row
  end

  return false
end

local generate_edit_line_action = function(title, new_text, row, params)
  return {
    title = title,
    action = function()
      -- 0-indexed
      api.nvim_buf_set_lines(params.bufnr, row, row, false, { new_text })
    end,
  }
end

local generate_disable_actions = function(diagnostic, indentation, params)
  local code = diagnostic.code

  local actions = {}
  local line_title = string.format("Disable Selene rule %s for this line", code)
  local line_new_text = indentation .. string.format("-- selene: allow(%s)", code)
  table.insert(
    actions,
    generate_edit_line_action(line_title, line_new_text, diagnostic.primary_label.span.start_line, params)
  )

  local file_title = string.format("Disable Selene rule %s for this file", code)
  local file_new_text = indentation .. string.format("--# selene: allow(%s)", code)
  table.insert(actions, generate_edit_line_action(file_title, file_new_text, 0, params))

  return actions
end

local code_action_handler = function(params)
  local row = params.row
  local indentation = params.content[row]:match("^%s+") or ""

  local rules, actions = {}, {}
  for _, message in ipairs(params.messages) do
    if is_fixable(message, row) then
      if message.code and not rules[message.code] then
        rules[message.code] = true
        vim.list_extend(actions, generate_disable_actions(message, indentation, params))
      end
    end
  end

  return actions
end

return h.make_builtin({
  name = "selene",
  meta = {
    url = "https://kampfkarren.github.io/selene/",
    description = "Command line tool designed to help write correct and idiomatic Lua code.",
  },
  method = CODE_ACTION,
  filetypes = { "lua" },
  generator_opts = {
    command = "selene",
    args = { "-n", "--display-style", "json", "-" },
    use_cache = true,
    to_stdin = true,
    format = "json_raw",
    ignore_stderr = true,
    check_exit_code = function(code)
      return code <= 1
    end,
    on_output = function(params)
      if type(params.output) == "table" then
        params.messages = { params.output }

        return code_action_handler(params)
      end

      local output = vim.split(params.output, "\n")
      local messages = {}
      for _, v in ipairs(output) do
        local ok, message = pcall(vim.fn.json_decode, v)

        if ok then
          table.insert(messages, message)
        end
      end

      params.messages = messages
      return code_action_handler(params)
    end,
  },
  factory = h.generator_factory,
})
