# alidistlint.nvim

Neovim LSP integration for alidistlint.

## Requirements

- Neovim >= 0.8.0
- alidistlint installed and available in your PATH
- nvim-lspconfig

## Installation

Using your preferred plugin manager:

### packer
```lua
use {
  'singiamtel/alidistlint.nvim',
  requires = {
    'neovim/nvim-lspconfig',
  },
}
```

### lazy.nvim
```lua
{
  'singiamtel/alidistlint.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
  },
}
```

## Configuration

Add this to your Neovim configuration:

```lua
require('alidistlint').setup({
  -- Optional configuration
  cmd = { 'alidistlint' }, -- Command to run
  filetypes = { 'sh' },    -- File types to enable the linter for
  settings = {
    -- Add any settings here if needed
  },
})
```

### Disabling LSP for alidist files

If you want to disable the regular LSP for alidist files (recommended), add this to your LSP configuration:

```lua
-- Function to check if a buffer is an alidist file
local function is_alidist_file(filename)
  return filename:match("alidist/.*%.sh$") ~= nil
end

-- Modify the on_attach function to skip LSP for alidist files
local original_on_attach = lspconfig.util.on_attach
lspconfig.util.on_attach = function(client, bufnr, ...)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if is_alidist_file(filename) then
    -- Don't attach LSP for alidist files
    return
  end
  if original_on_attach then
    return original_on_attach(client, bufnr, ...)
  end
end
```

Make sure this code runs before your LSP servers are configured.

## Features

- LSP integration for alidistlint
- Automatic diagnostics in shell script files
- Works with alidist package files
- Real-time error reporting
- Option to disable regular LSP for alidist files

## License

Same as the main alidistlint project (GPLv3) 
