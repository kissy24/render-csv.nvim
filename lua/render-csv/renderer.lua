local Config = require("render-csv.config")
local M = {}

--- Create the virtual text for a single line.
--- @param fields string[]
--- @param max_widths number[]
--- @param config table
--- @return table[]
function M.generate_virt_text(fields, max_widths, config)
  config = config or Config.defaults
  local virt_text = {}

  -- Left border
  table.insert(virt_text, { config.border.left, config.highlights.border })

  for i, field in ipairs(fields) do
    local width = vim.fn.strdisplaywidth(field)
    local padding = (max_widths[i] or width) - width
    local padded_field = field .. string.rep(" ", padding)

    table.insert(virt_text, { padded_field, config.highlights.cell })

    -- Middle or right border
    if i < #fields then
      table.insert(virt_text, { config.border.middle, config.highlights.border })
    else
      table.insert(virt_text, { config.border.right, config.highlights.border })
    end
  end

  return virt_text
end

return M
