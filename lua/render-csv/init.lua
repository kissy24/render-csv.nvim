local Manager = require("render-csv.manager")
local Config = require("render-csv.config")

local M = {}

--- Setup function for the plugin.
--- @param opts table?
function M.setup(opts)
  if opts then
    Config.defaults = vim.tbl_deep_extend("force", Config.defaults, opts)
  end

  local group = vim.api.nvim_create_augroup("RenderCsvGlobal", { clear = true })

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = group,
    pattern = "*.csv",
    callback = function(args)
      Manager.attach(args.buf)
    end,
  })

  -- Command to manually attach/render
  vim.api.nvim_create_user_command("RenderCsv", function()
    Manager.attach(vim.api.nvim_get_current_buf())
  end, {})
end

return M
