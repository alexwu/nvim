local npairs = require("nvim-autopairs")
npairs.setup({
	map_bs = false,
	check_ts = true,
	ignored_next_char = "[%w%.]",
	map_c_w = false,
	fast_wrap = {},
	enable_afterquote = true,
})


local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- TODO: Autowrap (like afterquote!) scenarios
-- TODO: js/jsx/ts/tsx import statements
-- |import_clause        {            {|import_clause}

-- TODO: js/jsx/ts/tsx arrow functions
-- (x) => |{x + 1}        (         (x) => ({x+1})
--
-- NOTE: These next few might just be tree-sitter in general...
-- TODO: surround functionality but using treesitter
