local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

---@param s string
---@return string
local file_prefix = function(str)
  vim.validate({ str = { str, "string" } })

  return vim.split(str, ".", { plain = true })[1]
end

-- Get a list of  the property names given an `interface_declaration`
-- treesitter *tsx* node.
-- Ie, if the treesitter node represents:
--   interface {
--     prop1: string;
--     prop2: number;
--   }
-- Then this function would return `{"prop1", "prop2"}
---@param id_node {} Stands for "interface declaration node"
---@return string[]
local function get_prop_names(id_node)
  local object_type_node = id_node:child(2)
  if object_type_node:type() ~= "object_type" then
    return {}
  end

  local prop_names = {}

  for prop_signature in object_type_node:iter_children() do
    if prop_signature:type() == "property_signature" then
      local prop_iden = prop_signature:child(0)
      local prop_name = vim.treesitter.query.get_node_text(prop_iden, 0)
      prop_names[#prop_names + 1] = prop_name
    end
  end

  return prop_names
end

-- return {
--   s(
--     "c",
--     fmt(
--       [[
-- {}interface {}Props {{
--   {}
-- }}
-- {}function {}({{{}}}: {}Props) {{
--   {}
-- }}
-- ]],
--       {
--         i(1, "export "),
--
--         -- Initialize component name to file name
--         d(2, function(_, snip)
--           return sn(nil, {
--             i(1, vim.fn.substitute(snip.env.TM_FILENAME, "\\..*$", "", "g")),
--           })
--         end, { 1 }),
--         i(3, "// props"),
--         rep(1),
--         rep(2),
--         f(function(_, snip, _)
--           local pos_begin = snip.nodes[6].mark:pos_begin()
--           local pos_end = snip.nodes[6].mark:pos_end()
--           local parser = vim.treesitter.get_parser(0, "tsx")
--           local tstree = parser:parse()
--
--           local node = tstree[1]:root():named_descendant_for_range(pos_begin[1], pos_begin[2], pos_end[1], pos_end[2])
--
--           while node ~= nil and node:type() ~= "interface_declaration" do
--             node = node:parent()
--           end
--
--           if node == nil then
--             return ""
--           end
--
--           -- `node` is now surely of type "interface_declaration"
--           local prop_names = get_prop_names(node)
--
--           -- Does this lua->vimscript->lua thing cause a slow down? Dunno.
--           return vim.fn.join(prop_names, ", ")
--         end, { 3 }),
--         rep(2),
--         i(5, "return <div></div>"),
--       }
--     )
--   ),
-- }

return {
  s(
    "import ...",
    fmt(
      [[
      import React from "react";

      const {component} = ({params}:{typename}) => {{
        return ({render});
      }}

      export default {component};
      ]],
      {
        component = f(function(_, parent)
          return file_prefix(parent.snippet.env.TM_FILENAME)
        end),

        params = i(1),
        typename = i(2),
        render = i(3),
      }
    )
  ),
}, {}
