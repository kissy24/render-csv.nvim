# render-csv.nvim

A Neovim plugin that renders CSV files as Excel-like tables in Normal mode.

## Features
- **Excel-like Rendering**: Automatic alignment and borders for CSV fields.
- **Dynamic Mode Toggling**:
  - **Normal Mode**: Table view.
  - **Insert Mode**: Raw CSV text for easy editing.
- **Zero Configuration**: Works out of the box for `.csv` files.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "your-username/render-csv.nvim",
  config = function()
    require("render-csv").setup({
      -- optional configuration
      -- delimiter = ",",
    })
  end
}
```

## Configuration

Default options:

```lua
require("render-csv").setup({
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
})
```

## Commands
- `:RenderCsv`: Manually attach the renderer to the current buffer.