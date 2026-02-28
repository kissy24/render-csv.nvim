local Parser = require("render-csv.parser")
local Layout = require("render-csv.layout")
local Renderer = require("render-csv.renderer")
local Config = require("render-csv.config")

local M = {}
local ns_id = vim.api.nvim_create_namespace("render-csv")

local buffers = {}

--- Clear all rendering for a buffer.
--- @param bufnr number
function M.clear(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)
end

--- Render the buffer as a table.
--- @param bufnr number
function M.render(bufnr)
  M.clear(bufnr)
  local config = Config.defaults -- TODO: allow user config
  local delimiter = config.delimiter
  local max_widths = Layout.calculate_column_widths(bufnr, delimiter)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  for i, line in ipairs(lines) do
    if line ~= "" then
      local fields = Parser.parse(line, delimiter)
      local virt_text = Renderer.generate_virt_text(fields, max_widths, config)
      vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, {
        virt_text = virt_text,
        virt_text_pos = "overlay",
      })
    end
  end
end

--- Handle mode change.
--- @param bufnr number
function M.on_mode_changed(bufnr)
  local mode = vim.api.nvim_get_mode().mode
  if mode:find("i") or mode:find("v") then
    M.clear(bufnr)
  else
    M.render(bufnr)
  end
end

--- Attach the plugin to a buffer.
--- @param bufnr number
function M.attach(bufnr)
  if buffers[bufnr] then return end
  buffers[bufnr] = true

  local group = vim.api.nvim_create_augroup("RenderCsv_" .. bufnr, { clear = true })

  vim.api.nvim_create_autocmd({ "InsertEnter", "ModeChanged" }, {
    group = group,
    buffer = bufnr,
    callback = function(args)
      M.on_mode_changed(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "TextChanged" }, {
    group = group,
    buffer = bufnr,
    callback = function(args)
      -- Wait for a moment or check mode again to ensure we're out of insert
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(args.buf) then
          M.on_mode_changed(args.buf)
        end
      end)
    end,
  })

  -- Initial render
  M.render(bufnr)
end

return M
