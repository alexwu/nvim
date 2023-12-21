local files = require("overseer.files")

return {
  name = "bin scripts",
  condition = {
    callback = function()
      return not vim.tbl_isempty(vim.fs.find("bin", {}))
    end,
  },
  generator = function(opts, cb)
    local bin_folder = vim.fs.find("bin")[1]
    local scripts = vim.tbl_filter(function(filename)
      -- return filename:match("%")
      return true
    end, files.list_files(bin_folder))
    local ret = {}
    for _, filename in ipairs(scripts) do
      table.insert(ret, {
        name = filename,
        params = {
          args = { optional = true, type = "list", delimiter = " " },
        },
        builder = function(params)
          return {
            cmd = { files.join(bin_folder, filename) },
            args = params.args,
          }
        end,
      })
    end

    cb(ret)
  end,
}
