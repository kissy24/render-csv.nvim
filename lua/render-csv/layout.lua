local Parser = require("render-csv.parser")
local M = {}

--- Calculate maximum column widths for a buffer.
--- @param bufnr number
--- @param delimiter string
--- @return number[]
function M.calculate_column_widths(bufnr, delimiter)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local max_widths = {}

  for _, line in ipairs(lines) do
    if line ~= "" then
      local fields = Parser.parse(line, delimiter)
      for i, field in ipairs(fields) do
        local width = vim.fn.strdisplaywidth(field)
        max_widths[i] = math.max(max_widths[i] or 0, width)
      end
    end
  end

  return max_widths
end

return M
