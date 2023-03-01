local stages = function()
  local stages_util = require("notify.stages.util")

  return {
    function(state)
      local next_height = state.message.height + 2
      -- local next_row = stages_util.available_row(state.open_windows, next_height)
      local next_row = stages_util.available_slot(state.open_windows, next_height, stages_util.DIRECTION.TOP_DOWN)
      if not next_row then
        return nil
      end
      return {
        relative = "editor",
        anchor = "NW",
        width = vim.fn.min({ state.message.width, vim.fn.floor(vim.opt.columns:get() / 4) }),
        height = state.message.height,
        col = vim.opt.columns:get(),
        row = next_row,
        border = "rounded",
        style = "minimal",
        opacity = 50,
      }
    end,
    function()
      return {
        opacity = { 100 },
        col = { vim.opt.columns:get() },
      }
    end,
    function()
      return {
        col = { vim.opt.columns:get() },
        time = true,
      }
    end,
    function()
      return {
        width = {
          1,
          frequency = 2.5,
          damping = 0.9,
          complete = function(cur_width)
            return cur_width < 3
          end,
        },
        opacity = {
          0,
          frequency = 2,
          complete = function(cur_opacity)
            return cur_opacity <= 4
          end,
        },
        col = { vim.opt.columns:get() },
      }
    end,
  }
end
return {
  "rcarriga/nvim-notify",
  config = function()
    -- vim.notify = require("notify")
    require("notify").setup({
      timeout = 100,
      fps = 60,
      stages = stages(),
      background_colour = "Normal",
      render = "minimal",
      on_open = nil,
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
    })
  end,
}
