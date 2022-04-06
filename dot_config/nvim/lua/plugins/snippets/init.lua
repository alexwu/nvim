local ls = require("luasnip")
local types = require("luasnip.util.types")

-- ls.snippets = require("luasnip-snippets").load_snippets()

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

ls.filetype_extend("tsx", { "ts" })
ls.filetype_extend("jsx", { "js" })
ls.filetype_extend("cpp", { "c" })

require("luasnip.loaders.from_vscode").load({})
