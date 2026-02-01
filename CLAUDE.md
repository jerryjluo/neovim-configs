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
- **Shell**: fish
- **Tabs**: 4 spaces (expandtab), except:
  - JS/TS/JSON: 2 spaces
  - Go: tabs (4-width)
- **Theme**: catppuccin
- Inline diagnostics off by default (toggle with `<leader>dt`)
- Telescope searches include hidden files (excludes `.git/`)

## LSP Keymaps (buffer-local when LSP attaches)

- `gd` - Go to definition | `gr` - Find references
- `gI` - Go to implementation | `gy` - Go to type definition
- `K` - Hover documentation | `<C-k>` - Signature help
- `<leader>ca` - Code action | `<leader>cr` - Rename symbol
- `<leader>cn` - Navbuddy (code navigation) | `<leader>cs` - Document symbols
- `<leader>cf` - Format (`:Format` command)

## Search (Telescope)

- `<leader>/` - Fuzzy search current buffer
- `<leader>sw` - Live grep in workspace | `<leader>sg` - Live grep in git root
- `<leader>sc` - Grep word under cursor | `<leader>sf` - Grep in current file
- `<leader>so` - Grep in open files | `<leader>sd` - Search diagnostics
- `<leader>sh` - Search help tags | `<leader>sr` - Resume last search
- `<leader>fs` - Find files | `<leader>fr` - Recent files | `<leader>fo` - Open buffers

## File Navigation

- `<leader>ft` - Toggle Neo-tree | `<leader>fc` - Neo-tree at current file
- `<leader>fe` - Netrw explore | `<leader>fv` - Netrw vertical split
- `<leader>fl` - Last buffer | `<leader>fd` - Diff buffer edits vs disk

## Debug (nvim-dap)

Go and Python adapters configured. Delve installed via Mason.

- `<F5>` Start/Continue | `<F6>` Terminate | `<F4>` Pause
- `<F1>` Step into | `<F2>` Step over | `<F3>` Step out
- `<leader>b` Toggle breakpoint | `<leader>B` Conditional breakpoint
- `<F7>` Toggle DAP UI
