local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
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

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
	delete_check_events = "InsertLeave",
	region_check_events = "InsertEnter",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "●", "Comment" } },
			},
		},
		[types.insertNode] = {
			active = {
				virt_text = { { "●", "" } },
			},
		},
	},
	ext_base_prio = 300,
	ext_prio_increase = 1,
	enable_autosnippets = false,
})

ls.add_snippets("javascript", {
	s("describetest", {
		t([[import "./]]),
		dl(1, l.TM_FILENAME),
		t([["]]),
		t([[]]),
		t([[describe("]]),
		dl(2, l.TM_FILENAME:gsub("%.", ""), {}),
		t([[", ]]),
		i(3, "() => {"),
		t(""),
		t([[it("]]),
		i(0, "test name"),
		t([[", () => {]], "", "})"),
		t("})"),
	}),
})

ls.filetype_extend("typescriptreact", { "typescript", "javascriptreact", "javascript" })
ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("javascriptreact", { "javascript" })
ls.filetype_extend("cpp", { "c" })

require("luasnip.loaders.from_vscode").load({})
