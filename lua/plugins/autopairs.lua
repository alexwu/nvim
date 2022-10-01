local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")

npairs.setup({
  map_bs = false,
  check_ts = true,
  ignored_next_char = '[%w%."]',
  map_c_w = false,
  fast_wrap = {},
  enable_afterquote = true,
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

local get_closing_for_line = function(line)
  local i = -1
  local clo = ""

  while true do
    i, _ = string.find(line, "[%(%)%{%}%[%]]", i + 1)
    if i == nil then
      break
    end
    local ch = string.sub(line, i, i)
    local st = string.sub(clo, 1, 1)

    if ch == "{" then
      clo = "}" .. clo
    elseif ch == "}" then
      if st ~= "}" then
        return ""
      end
      clo = string.sub(clo, 2)
    elseif ch == "(" then
      clo = ")" .. clo
    elseif ch == ")" then
      if st ~= ")" then
        return ""
      end
      clo = string.sub(clo, 2)
    elseif ch == "[" then
      clo = "]" .. clo
    elseif ch == "]" then
      if st ~= "]" then
        return ""
      end
      clo = string.sub(clo, 2)
    end
  end

  return clo
end

-- npairs.remove_rule("(")
-- npairs.remove_rule("{")
-- npairs.remove_rule("[")
--
-- npairs.add_rule(Rule("[%(%{%[]", "")
--   :use_regex(true)
--   :replace_endpair(function(opts)
--     return get_closing_for_line(opts.line)
--   end)
--   :end_wise())
--
-- TODO: Autowrap (like afterquote!) scenarios
-- TODO: js/jsx/ts/tsx import statements
-- |import_clause        {            {|import_clause}

-- TODO: js/jsx/ts/tsx arrow functions
-- (x) => |{x + 1}        (         (x) => ({x+1})
--
-- NOTE: These next few might just be tree-sitter in general...
-- TODO: surround functionality but using treesitter
