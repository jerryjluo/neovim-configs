# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Neovim configuration based on kickstart.nvim, using lazy.nvim as the plugin manager. The configuration is written in Lua.

## Structure

- `init.lua` - Main configuration file containing settings, keymaps, and plugin loading
- `lua/plugins/` - Individual plugin configurations (each file returns a lazy.nvim plugin spec)
- `lua/user-settings.lua` - User-specific customizations (empty by default, for local overrides)
- `lazy-lock.json` - Plugin version lockfile

## Key Configuration Details

**Leader key**: Space

**Tab settings**: 4 spaces (expandtab enabled)

**Plugin manager**: lazy.nvim (auto-bootstraps on first run)

### Installed Plugins

Core functionality:
- **telescope.nvim** - Fuzzy finder for files, grep, buffers
- **nvim-treesitter** - Syntax highlighting and text objects
- **nvim-cmp** - Autocompletion
- **null-ls.nvim** - Linting/formatting (configured for Python: flake8, black, isort, autoflake)
- **nvim-dap** - Debugging (Go and Python adapters configured)
- **gitsigns.nvim** - Git integration in the gutter
- **vim-fugitive** - Git commands (with GitHub and GitLab support)
- **neo-tree.nvim** - File tree
- **which-key.nvim** - Keymap hints
- **claudecode.nvim** - Claude Code integration

Theme: catppuccin

### Key Keymaps

File operations (`<leader>f`):
- `<leader>fs` - Find files
- `<leader>ft` - Toggle file tree
- `<leader>fr` - Recent files
- `<leader>fo` - Open buffers

Search (`<leader>s`):
- `<leader>sw` - Live grep in workspace
- `<leader>sg` - Live grep from git root
- `<leader>sc` - Grep word under cursor
- `<leader>/` - Fuzzy find in current buffer

Git (`<leader>g`):
- `<leader>gs` - Git status (vertical split)
- `<leader>gb` - Git blame
- `<leader>gd` - Git diff against staged
- `<leader>gl` - Copy git link to clipboard

Diagnostics (`<leader>d`):
- `<leader>dt` - Toggle inline diagnostics
- `<leader>dp` - Open floating diagnostic
- `[d`/`]d` - Navigate diagnostics

Debug:
- `<F5>` - Start/Continue
- `<F1>` - Step into
- `<F2>` - Step over
- `<F3>` - Step out
- `<F6>` - Terminate
- `<leader>b` - Toggle breakpoint

Claude Code (`<leader>a`):
- `<leader>ac` - Toggle Claude
- `<leader>af` or `<C-,>` - Focus Claude
- `<leader>as` (visual) - Send selection to Claude

## Adding New Plugins

Create a new file in `lua/plugins/` that returns a lazy.nvim plugin spec, then require it in `init.lua` within the `lazy.setup()` call.
