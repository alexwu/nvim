local ts = vim.treesitter

local queries = require("nvim-treesitter.query")
local strings = require("plenary.strings")
local u = require("bombeelu.utils")

local M = {}

-- M.query = [[(jsx_element (jsx_text) @text)]]

-- M.query = [[
-- ( jsx_element (jsx_text) @text)
-- (
--   (jsx_self_closing_element
--   name: (identifier) @tag.type
--   attribute: (jsx_attribute (property_identifier) @tag.name (string (string_fragment) @tag.name-value))
--   attribute: (jsx_attribute (property_identifier) @tag.label (string) @tag.label-value)
-- ) @tag
-- (#any-of? @tag.name "name" "label")
-- (#any-of? @tag.label "label" "name")
-- )
-- ]]

-- M.query = [[
-- ( jsx_element (jsx_text) @text)
-- (
--   (jsx_self_closing_element
--   name: (identifier) @tag.type
--   attribute: (jsx_attribute (property_identifier) @tag.label (string) @tag.label-value)
-- ) @tag
-- (#any-of? @tag.label "label" "title" "text" "alt")
-- )
-- ]]

M.query = [[
(jsx_element open_tag: (jsx_opening_element name: (_) @tag.type) (jsx_text) @tag.text) @tag
(
  (jsx_self_closing_element
  name: (_) @tag.type
  attribute: (jsx_attribute (property_identifier) @tag.label (string (string_fragment)) @tag.text)
) @tag
(#any-of? @tag.label "label" "title" "text" "alt" "placeholder")
)
(
 (import_statement (import_clause (named_imports (import_specifier name: (identifier) @import.variable)))) @import
(#any-of? @import.variable "useTranslation")
)

((statement_block (return_statement) @return))
]]

function M.iter_parents(node)
  local parent = node:parent()
  local function iter()
    parent = parent:parent()
    return parent
  end

  return iter
end

M.find_parent = function(node, type)
  local parent = nil

  for n in M.iter_parents(node) do
    if n:type() == type then
      parent = n
      break
    end
  end

  return parent
end

function M.replace(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  ts.query.set("tsx", "i18n", M.query)
  -- local query = ts.query.get("tsx", "i18n")
  local parser = ts.get_parser(bufnr)

  parser:parse()
  -- parser:for_each_tree(function(tree, ltree)
  --   if ltree:lang() == "tsx" then
  --     for _, match, _ in query:iter_matches(tree:root(), bufnr, 0, -1) do
  --       for id, node in pairs(match) do
  --         if query.captures[id] == "tag.text" then
  --           local start_row, start_col, end_row, end_col = ts.get_node_range(node)
  --           local text = ts.get_node_text(node, bufnr)
  --
  --           -- local parent_key = ts.get_node_text(node:parent():named_child()[0]:named_child()[0], bufnr)
  --
  --           -- local component = M.find_parent(match.node, "lexical_declaration")
  --           -- local component_name = ts.get_node_text(component:named_child(0):named_child(0), bufnr)
  --           -- local translation_key = table.concat({ component_name, "text" }, ".")
  --
  --           local replacement_text = string.format([[{t("DUMMY.KEY", "%s")}]], text)
  --
  --           vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { replacement_text })
  --         end
  --       end
  --     end
  --   end
  -- end)

  -- vim.print(ts.get_node_text(node, bufnr))
  -- queries.get_capture_matches(bufnr, "@tag")

  local imports = queries.get_capture_matches(bufnr, { "@import" }, "i18n")
  if vim.tbl_isempty(imports) then
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, { 'import { useTranslation } from "react-i18next";' })
  end

  if vim.tbl_isempty(imports) then
    local returns = queries.get_capture_matches(bufnr, { "@return" }, "i18n")

    for match in vim.iter(returns) do
      local start_row, start_col, end_row, end_col = unpack(ts.get_range(match.node, bufnr))
      local text = ts.get_node_text(match.node, bufnr)

      vim.api.nvim_buf_set_lines(bufnr, start_row, start_row, false, { [[  const { t } = useTranslation();]] })
    end
  end

  local matches = queries.get_capture_matches(bufnr, { "@tag" }, "i18n")
  for match in vim.iter(matches) do
    local component = M.find_parent(match.node, "lexical_declaration")

    local component_name = ts.get_node_text(component:named_child(0):named_child(0), bufnr)

    local tag_name = ts.get_node_text(match["type"].node, bufnr)

    local tag_label = nil
    if match["label"] ~= nil then
      tag_label = ts.get_node_text(match["label"].node, bufnr)
    end

    local label_value = match["text"].node

    local start_row, start_col, end_row, end_col = ts.get_node_range(label_value)
    local text = ts.get_node_text(label_value, bufnr)

    if vim.startswith(text, [["]]) and vim.endswith(text, [["]]) then
      text = vim.split(text, [["]])[2]
    end

    local text_name = nil

    if tag_label == nil then
      text_name = vim.split(text, " ")[1]
    end

    local name_list = {}
    -- vim.print(u.flatten({ component_name, tag_name, tag_label, text_name }))
    -- vim.print({ component_name, tag_name, tag_label, text_name })
    vim.iter(u.flatten({ component_name, tag_name, tag_label, text_name })):each(function(name)
      -- vim.print(name)
      if name ~= nil then
        table.insert(name_list, name)
      end
    end)

    local translation_key = table.concat(name_list, ".")
    local replacement_text = string.format([[{t("%s", "%s")}]], translation_key, text)
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { replacement_text })
  end
end

function M.setup()
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*.tsx" },
    callback = function(args)
      local bufnr = args.buf

      vim.api.nvim_buf_create_user_command(bufnr, "Replace", function()
        M.replace()
      end, {})
    end,
  })
end

return M
