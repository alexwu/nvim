local finders = require("telescope.finders")
local if_nil = vim.F.if_nil

local function get_context(snip)
	return {
		name = snip.name,
		trigger = snip.trigger,
		description = snip.dscr,
		wordTrig = snip.wordTrig and true or false,
		regTrig = snip.regTrig and true or false,
	}
end

local function available(fts)
	local ls = require("luasnip")
	local res = {}

	for _, ft in ipairs(fts) do
		res[ft] = {}
		for _, snip in ipairs(ls.get_snippets(ft)) do
			if not snip.invalidated then
				table.insert(res[ft], get_context(snip))
			end
		end
		for _, snip in ipairs(ls.get_snippets(ft, { type = "autosnippets" })) do
			if not snip.invalidated then
				table.insert(res[ft], get_context(snip))
			end
		end
	end
	return res
end

return function(opts)
	opts = if_nil(opts, {})
	opts.ft = if_nil(opts.ft, vim.bo.ft)

	-- TODO: Get all of them and then flatten
	local finder = function()
		return available({ opts.ft })[opts.ft] or {}
	end

	return finders.new_table({
		results = finder(),
		entry_maker = function(entry)
			-- TODO: Sort by name and description and value?
			-- TODO: Show preview
			return {
				value = entry.trigger,
				display = entry.name,
				ordinal = entry.name,
			}
		end,
	})
end
