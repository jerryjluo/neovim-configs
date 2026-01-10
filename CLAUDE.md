# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Neovim configuration based on kickstart.nvim, using lazy.nvim as the plugin manager. Written in Lua.

## Structure

- `init.lua` - Main configuration: options, keymaps, lazy.nvim setup with plugin requires
- `lua/plugins/*.lua` - Individual plugin specs (each returns a lazy.nvim plugin table)
- `lua/user-settings.lua` - Local overrides (gitignored, empty by default)

## Adding/Modifying Plugins

**Adding a plugin**: Create `lua/plugins/<name>.lua` returning a lazy.nvim spec, then add `require 'plugins.<name>'` to the `lazy.setup()` call in `init.lua`.

**Plugin spec format**:
```lua
return {
  'author/plugin-name',
  dependencies = { ... },
  config = function() ... end,
  -- or opts = {} for simple setup
}
```

## LSP Configuration

LSP servers are configured via Mason in `lua/plugins/nvim-lspconfig.lua`. To add a new language server, add it to the `servers` table:

```lua
local servers = {
  clangd = {},
  gopls = {},
  pyright = {},
  rust_analyzer = {},
  lua_ls = { Lua = { ... } },
  -- Add new servers here
}
```

Mason will auto-install servers listed in this table.

## Key Conventions

- **Leader**: Space
- **Tabs**: 4 spaces (expandtab)
- **Theme**: catppuccin
- Inline diagnostics off by default (toggle with `<leader>dt`)
- Telescope searches include hidden files (excludes `.git/`)

## LSP Keymaps (buffer-local when LSP attaches)

- `gd` - Go to definition
- `gr` - Find references
- `gI` - Go to implementation
- `gy` - Go to type definition
- `K` - Hover documentation
- `<leader>ca` - Code action
- `<leader>cr` - Rename symbol
- `<leader>cf` - Format (`:Format` command)

## Debug (nvim-dap)

Go and Python adapters configured. Delve installed via Mason.

- `<F5>` Start/Continue | `<F6>` Terminate
- `<F1>` Step into | `<F2>` Step over | `<F3>` Step out
- `<leader>b` Toggle breakpoint | `<leader>B` Conditional breakpoint
- `<F7>` Toggle DAP UI
