local M = {}

M.defaults = {
  delimiter = ",",
  border = {
    left = "| ",
    middle = " | ",
    right = " |",
  },
  highlights = {
    border = "Comment",
    cell = "Normal",
  }
}

return M
