# Neovim Configuration

Personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), using lazy.nvim as the plugin manager.

## Requirements

- **Neovim** >= 0.9.0
- **Git**
- **make** (for telescope-fzf-native)
- **ripgrep** (for Telescope live grep)
- **A Nerd Font** (for icons)
- **fish** shell (configured as default shell, or change `vim.o.shell` in init.lua)

### Language-specific (optional)

- **Node.js** - for TypeScript LSP
- **Python 3** - for Python LSP and DAP
- **Go** - for Go LSP and DAP (Delve debugger)
- **Rust** - for rust-analyzer
- **clang** - for C/C++ LSP

## Installation

1. Back up your existing Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this repository:
   ```bash
   git clone <repo-url> ~/.config/nvim
   ```

3. Start Neovim:
   ```bash
   nvim
   ```

   lazy.nvim will automatically install itself and all plugins on first launch. Mason will install configured LSP servers.

## Structure

```
~/.config/nvim/
├── init.lua              # Main config: options, keymaps, plugin loader
├── lua/
│   ├── plugins/          # Individual plugin specs
│   │   ├── nvim-lspconfig.lua
│   │   ├── telescope.lua
│   │   ├── treesitter.lua
│   │   └── ...
│   └── user-settings.lua # Local overrides (gitignored)
└── CLAUDE.md             # AI assistant instructions
```

## Key Bindings

Leader key is **Space**.

### Navigation
| Key | Action |
|-----|--------|
| `<leader>fs` | Find files |
| `<leader>sw` | Live grep workspace |
| `<leader>fo` | Open buffers |
| `<leader>fr` | Recent files |
| `<leader>ft` | Toggle file tree |
| `<leader>/` | Fuzzy search current buffer |

### LSP (when attached)
| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format buffer |

### Git
| Key | Action |
|-----|--------|
| `<leader>gb` | Git blame |
| `<leader>gs` | Git status |
| `<leader>gd` | Git diff |
| `<leader>gc` | Git commit |

### Debug
| Key | Action |
|-----|--------|
| `<F5>` | Start/Continue |
| `<F6>` | Terminate |
| `<leader>b` | Toggle breakpoint |
| `<F7>` | Toggle DAP UI |

Press `<leader>` and wait to see all available keymaps via which-key.

## Customization

### Adding an LSP server

Edit `lua/plugins/nvim-lspconfig.lua` and add to the `servers` table:

```lua
local servers = {
  -- existing servers...
  your_server = {},
}
```

Mason will auto-install it on next launch.

### Adding a plugin

1. Create `lua/plugins/<name>.lua`:
   ```lua
   return {
     'author/plugin-name',
     config = function()
       require('plugin-name').setup({})
     end,
   }
   ```

2. Add `require 'plugins.<name>'` to the `lazy.setup()` call in `init.lua`.

### Local overrides

Add personal settings to `lua/user-settings.lua` (gitignored).

## Included Plugins

- **LSP**: nvim-lspconfig, Mason, lazydev
- **Completion**: nvim-cmp, LuaSnip
- **Syntax**: Treesitter
- **Fuzzy finder**: Telescope
- **Git**: fugitive, gitsigns, diffview
- **Debug**: nvim-dap (Go, Python)
- **UI**: catppuccin, lualine, which-key, Neo-tree
- **Editing**: surround, various-textobjs
