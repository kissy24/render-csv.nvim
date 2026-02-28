# render-csv.nvim Specification

## Overview
`render-csv.nvim` is a Neovim plugin that transforms a standard CSV file into an Excel-like table view in Normal mode, while reverting to raw CSV text in Insert mode. It uses Neovim's virtual text (extmarks) to achieve this without altering the underlying file content.

## Key Features
- **Excel-like Rendering**: Aligned columns with borders using virtual text.
- **Mode-switching**: Automatic rendering in Normal mode; raw text in Insert mode.
- **Alignment**: Column widths are calculated dynamically to ensure consistent alignment.
- **Non-destructive**: The actual buffer content remains unchanged.

## Architecture

### 1. Parser (Core.Parser)
- **Responsibility**: Parse a line of text into a list of fields.
- **Design**: Handle standard CSV rules (commas, quoted fields).
- **Interface**: `parse(line: string) -> string[]`

### 2. Renderer (Core.Renderer)
- **Responsibility**: Generate virtual text decorations for a line based on parsed fields and column widths.
- **Design**: Use `nvim_buf_set_extmark` with `virt_text`, `virt_text_pos='overlay'`, or `inline` virtual text.
- **Interface**: `render(bufnr, line_idx, fields, column_widths) -> ExtmarkData`

### 3. Layout Manager (Core.Layout)
- **Responsibility**: Calculate the maximum width of each column for the entire buffer or a visible range.
- **Design**: Scans the buffer to determine optimal column widths.

### 4. Buffer Manager (Core.Buffer)
- **Responsibility**: Manage the state (rendered vs. raw) for a specific buffer.
- **Design**: Attaches to a buffer, sets up `autocmd` for `InsertEnter`, `InsertLeave`, and `BufWritePost`.

### 5. Config (Core.Config)
- **Responsibility**: Manage user settings (delimiters, border styles).

## Implementation Details

### Rendering Strategy
- **Extmarks**: Use a namespace `render-csv`.
- **Normal Mode**: 
  - Hide commas and original text.
  - Inject virtual text that includes padded cell content and borders (e.g., `| Cell A | Cell B |`).
- **Insert Mode**: 
  - Clear all extmarks in the namespace.

### Principles
- **SOLID**: Each component (Parser, Renderer, Layout) has a single responsibility.
- **DRY**: Shared logic for padding and string manipulation.
- **KISS**: Start with simple rendering and expand as needed.
- **Decoupled**: Parser doesn't know about Neovim APIs; Renderer doesn't know about CSV rules.

## File Structure
```
lua/render-csv/
├── init.lua          # Entry point
├── config.lua        # User configuration
├── parser.lua        # CSV parsing logic
├── renderer.lua      # Extmark generation
├── layout.lua        # Column width calculation
└── manager.lua       # Buffer-specific lifecycle management
```

## Roadmap
1. Basic CSV parsing.
2. Static column width calculation.
3. Extmark rendering for simple tables.
4. Auto-toggle on mode change.
5. Dynamic updates on text change.
