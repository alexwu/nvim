local Path = require("plenary.path")
local async_oneshot_finder = require("telescope.finders.async_oneshot_finder")
local if_nil = vim.F.if_nil

local utils = require("telescope.utils")

local os_sep = Path.path.sep

-- TODO: REDO ALL OF THIS
local make_entry = function(opts)
	-- needed since Path:make_relative does not resolve parent dirs
	local parent_dir = Path:new(opts.cwd):parent():absolute()
	local mt = {}
	mt.cwd = opts.cwd
	mt.display = function(entry)
		local hl_group
		-- mt.cwd can change due to caching and traversal
		opts.cwd = mt.cwd
		local display = utils.transform_path(opts, entry.path)
		if entry.Path:is_dir() then
			-- TODO: better solution requires plenary PR to Path:make_relative
			if entry.value == parent_dir then
				display = ".."
			end
			display = display .. os_sep
			if not opts.disable_devicons then
				display = (opts.dir_icon or "") .. " " .. display
				hl_group = opts.dir_icon_hl or "Default"
			end
		else
			display, hl_group = utils.transform_devicons(entry.path, display, opts.disable_devicons)
		end

		if hl_group then
			return display, { { { 1, 3 }, hl_group } }
		else
			return display
		end
	end

	mt.__index = function(t, k)
		local raw = rawget(mt, k)
		if raw then
			return raw
		end

		if k == "path" then
			local retpath = t.Path:absolute()
			if not vim.loop.fs_access(retpath, "R", nil) then
				retpath = t.value
			end
			return retpath
		end

		return rawget(t, rawget({ value = 1 }, k))
	end

	return function(line)
		local p = Path:new(line)
		local absolute = p:absolute()

		local e = setmetatable(
			-- TODO: better solution requires plenary PR to Path:make_relative
			{ absolute, Path = p, ordinal = absolute == parent_dir and ".." or p:make_relative(opts.cwd) },
			mt
		)

		local cached_entry = opts.entry_cache[e.path]
		if cached_entry ~= nil then
			-- update the entry in-place to keep multi selections in tact
			cached_entry.ordinal = e.ordinal
			cached_entry.display = e.display
			cached_entry.cwd = opts.cwd
			return cached_entry
		end

		opts.entry_cache[e.path] = e
		return e -- entry
	end
end

local function buffer_dir(bufnr)
	bufnr = if_nil(bufnr, 0)
	local buffer_name = vim.api.nvim_buf_get_name(bufnr)

	return Path.new(buffer_name):parent():normalize(vim.loop.cwd())
end

local function fd(opts)
	opts = if_nil(opts, {})

	return async_oneshot_finder({
		fn_command = function()
			return { command = "fd", args = { "--strip-cwd-prefix", "--type", "f" } }
		end,
		entry_maker = function(entry)
			local display = Path:new(entry):make_relative(buffer_dir())
			return {
				value = entry,
				display = display,
				ordinal = entry,
			}
		end,
		cwd = opts.path,
	})
end

-- TODO: combine with lsp definitions
-- TODO: Perhaps an option to have references as well?
return function(opts)
	opts = opts or {}
	local cwd = if_nil(opts.cwd, vim.api.nvim_buf_get_name(0))
	local results_path = Path.new(cwd):parent():make_relative(".")

	return fd({ path = results_path })
end
