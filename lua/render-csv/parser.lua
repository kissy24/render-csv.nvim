local M = {}

--- Parse a single CSV line into fields.
--- @param line string
--- @param delimiter string
--- @return string[]
function M.parse(line, delimiter)
  delimiter = delimiter or ","
  local result = {}
  local from = 1
  local sep_len = #delimiter
  local line_len = #line

  while from <= line_len do
    local field
    local next_char = line:sub(from, from)

    if next_char == '"' then
      -- Quoted field
      local end_quote = line:find('"', from + 1)
      while end_quote and line:sub(end_quote + 1, end_quote + 1) == '"' do
        -- Escaped quote: ""
        end_quote = line:find('"', end_quote + 2)
      end

      if not end_quote then
        field = line:sub(from + 1)
        from = line_len + 1
      else
        field = line:sub(from + 1, end_quote - 1)
        field = field:gsub('""', '"')
        from = end_quote + 1
        -- Skip the separator after the closing quote
        if line:sub(from, from + sep_len - 1) == delimiter then
          from = from + sep_len
        end
      end
    else
      -- Non-quoted field
      local sep_start, sep_end = line:find(delimiter, from, true)
      if sep_start then
        field = line:sub(from, sep_start - 1)
        from = sep_end + 1
      else
        field = line:sub(from)
        from = line_len + 1
      end
    end
    table.insert(result, field or "")
  end

  -- Handle trailing empty field (e.g., "a,b,")
  if line:sub(-sep_len) == delimiter then
    table.insert(result, "")
  end

  return result
end

return M
