-- Leader key (must be set before plugins are loaded)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Shared between a keymap (<C-l>) and the FocusGained/BufEnter autocmd, so it
-- lives at top scope where both setup_basic_keymaps() and setup_autocmds() can
-- close over it.
local function refresh_buffers_and_tree()
  vim.cmd 'checktime'
  pcall(function()
    require('neo-tree.sources.manager').refresh 'filesystem'
  end)
end

-- Clone lazy.nvim on first launch, then declare the plugin list.
local function bootstrap_lazy()
  local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
  if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/folke/lazy.nvim.git',
      '--branch=stable',
      lazypath,
    }
  end
  vim.opt.rtp:prepend(lazypath)

  require('lazy').setup({
    require 'plugins.fugitive', -- Git: fugitive (+ GitHub/GitLab GBrowse)
    'tpope/vim-surround', -- Add/change/delete surrounding pairs (cs, ds, ys)
    'jeetsukumaran/vim-indentwise', -- Motions based on indent levels ([-, ]+, etc.)
    'nvim-neotest/nvim-nio', -- Async IO library (dependency for other plugins)
    require 'plugins.debug', -- DAP debugger for Go and Python
    require 'plugins.nvim-lspconfig', -- LSP configuration with Mason
    require 'plugins.conform', -- Formatter (stylua/gofmt/rustfmt) + format-on-save
    require 'plugins.filetree', -- Neo-tree file explorer
    require 'plugins.diffview', -- Git diff viewer with file tree
    require 'plugins.gitsigns', -- Git signs in gutter + hunk operations
    require 'plugins.lsp-signature', -- Function signature help while typing
    require 'plugins.lualine', -- Status line
    require 'plugins.nvim-cmp', -- Autocompletion engine
    require 'plugins.aerial', -- Code outline sidebar
    require 'plugins.telescope', -- Fuzzy finder for files, grep, buffers
    require 'plugins.treesitter', -- Syntax highlighting and text objects
    require 'plugins.treesitter-context', -- Sticky scroll: pin enclosing scope to top of window
    require 'plugins.which-key', -- Keymap hints popup
    require 'plugins.catppuccin', -- Color theme
    require 'plugins.nvim-various-textobjs', -- Extra text objects (multiline comments, etc.)
    require 'plugins.claude-code', -- Claude Code integration
    require 'plugins.harpoon', -- Pinned file marks
    require 'plugins.flash', -- Jump anywhere on screen via labeled motions
    require 'plugins.oil', -- Buffer-based file manager (edit dirs as text)
  }, {})
end

-- Editor-wide options.
local function setup_options()
  vim.o.autoread = true
  vim.o.hlsearch = true
  vim.wo.number = true
  vim.cmd 'highlight LineNr guifg=#666729'
  vim.o.clipboard = 'unnamedplus'
  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.wo.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  -- Keep cursor away from window edges; also ensures the treesitter-context
  -- sticky header always has room (it caps its height to the cursor's distance
  -- from the top of the window, so scrolloff=0 made the header vanish at the top).
  vim.o.scrolloff = 8
  vim.o.completeopt = 'menuone,noselect'
  vim.o.termguicolors = true
  vim.o.expandtab = true
  vim.o.tabstop = 4
  vim.o.softtabstop = 4
  vim.o.shiftwidth = 4
  vim.o.shell = 'fish'
end

-- Per-language indentation overrides (defaults live in setup_options).
local function setup_indentation()
  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'json', 'jsonc', 'lua' },
    callback = function()
      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 2
      vim.opt_local.softtabstop = 2
      vim.opt_local.shiftwidth = 2
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    callback = function()
      vim.opt_local.expandtab = false
      vim.opt_local.tabstop = 4
      vim.opt_local.softtabstop = 4
      vim.opt_local.shiftwidth = 4
    end,
  })
end

local function setup_basic_keymaps()
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
  vim.keymap.set('n', "'", '`')
  vim.keymap.set('n', '<C-_>', '<Cmd>noh<CR>', { desc = 'Clear search' })
  vim.keymap.set('n', '<C-l>', function()
    refresh_buffers_and_tree()
    vim.cmd 'nohlsearch'
    vim.cmd 'diffupdate'
    vim.cmd 'redraw!'
  end, { desc = 'Reload buffers and refresh filetree' })
  vim.keymap.set('t', '<C-]>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
end

-- Diagnostic navigation, plus the virtual_text toggle (off by default).
local function setup_diagnostics_keymaps()
  local function diag_prev()
    vim.diagnostic.jump { count = -1, float = true }
  end
  local function diag_next()
    vim.diagnostic.jump { count = 1, float = true }
  end
  vim.keymap.set('n', '[d', diag_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', '[$', diag_prev, { desc = 'Go to previous diagnostic message' })
  vim.keymap.set('n', ']d', diag_next, { desc = 'Go to next diagnostic message' })
  vim.keymap.set('n', ']$', diag_next, { desc = 'Go to next diagnostic message' })
  vim.keymap.set('n', '<leader>dp', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

  vim.g.diagnostics_active = false
  vim.diagnostic.config { virtual_text = false }
  local function toggle_diagnostic()
    if vim.g.diagnostics_active then
      vim.g.diagnostics_active = false
      vim.diagnostic.config { virtual_text = false }
    else
      vim.g.diagnostics_active = true
      vim.diagnostic.config { virtual_text = true }
    end
  end
  vim.keymap.set('n', '<leader>dt', toggle_diagnostic, { desc = 'Toggle diagnostic' })
end

-- Native file maps only; plugin-driven file/git maps live in their specs
-- (telescope.lua, oil.lua, filetree.lua, fugitive.lua).
local function setup_file_keymaps()
  vim.keymap.set('n', '<leader>fl', '<Cmd>b#<CR>', { desc = '[F]ile [L]ast' })
  vim.keymap.set('n', '<leader>fd', '<Cmd>w !git diff --no-index -- % -<CR>', { desc = '[F]ile [D]iff buffer edit' })
end

local function setup_yank_keymaps()
  vim.keymap.set('n', '<leader>yr', '<Cmd>let @+ = expand("%:.")<CR>', { desc = '[Y]ank [R]elative path' })
  vim.keymap.set('n', '<leader>ya', '<Cmd>let @+ = expand("%:p")<CR>', { desc = '[Y]ank [A]bsolute path' })
  local function yank_path_with_range(expr)
    return function()
      local path = vim.fn.expand(expr)
      local l1, l2 = vim.fn.line 'v', vim.fn.line '.'
      if l1 > l2 then
        l1, l2 = l2, l1
      end
      local range = l1 == l2 and tostring(l1) or (l1 .. '-' .. l2)
      local text = path .. ':' .. range
      vim.fn.setreg('+', text)
      vim.notify('Yanked: ' .. text)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
    end
  end
  vim.keymap.set('x', '<leader>yr', yank_path_with_range '%:.', { desc = '[Y]ank [R]elative path with range' })
  vim.keymap.set('x', '<leader>ya', yank_path_with_range '%:p', { desc = '[Y]ank [A]bsolute path with range' })
  vim.keymap.set({ 'n', 'v' }, '<C-p>', '"0p', { desc = 'Paste down from last yank' })
  vim.keymap.set({ 'n', 'v' }, '<C-P>', '"0P', { desc = 'Paste up from last yank' })
end

local function setup_tab_keymaps()
  vim.keymap.set('n', '<leader>tn', '<Cmd>tabnew<CR>', { desc = '[T]ab [N]ew' })
  vim.keymap.set('n', '<leader>tu', '<Cmd>tabnew %<CR>', { desc = '[T]ab D[u]plicate current file' })
  vim.keymap.set('n', '<leader>tt', '<Cmd>tabnew | set nonu | term<CR>', { desc = '[T]ab new [T]erminal' })
end

local function setup_buffer_keymaps()
  vim.keymap.set('n', '[b', '<Cmd>bprev<CR>', { desc = 'Previous buffer' })
  vim.keymap.set('n', '[\\', '<Cmd>bprev<CR>', { desc = 'Previous buffer' })
  vim.keymap.set('n', ']b', '<Cmd>bnext<CR>', { desc = 'Next buffer' })
  vim.keymap.set('n', ']\\', '<Cmd>bnext<CR>', { desc = 'Next buffer' })
end

local function setup_quickfix_keymaps()
  vim.keymap.set('n', '[q', '<Cmd>cprev<CR>', { desc = 'Prev quickfix' })
  vim.keymap.set('n', ']q', '<Cmd>cnext<CR>', { desc = 'Next quickfix' })
  vim.keymap.set('n', '<leader>q', '<Cmd>copen<CR>', { desc = 'Open quickfix' })
end

local function setup_arglist_keymaps()
  vim.keymap.set('n', '[r', '<Cmd>previous<CR>', { desc = 'Previous argument' })
  vim.keymap.set('n', '[`', '<Cmd>previous<CR>', { desc = 'Previous argument' })
  vim.keymap.set('n', ']r', '<Cmd>next<CR>', { desc = 'Next argument' })
  vim.keymap.set('n', ']`', '<Cmd>next<CR>', { desc = 'Next argument' })
  vim.keymap.set('n', '<leader>ra', '<Cmd>arga %<CR>', { desc = 'Add current file to arglist' })
  vim.keymap.set('n', '<leader>rr', '<Cmd>argd %<CR>', { desc = 'Remove current file to arglist' })
  vim.keymap.set('n', '<leader>rl', '<Cmd>args<CR>', { desc = 'List the arglist' })
end

-- Autocmds not tied to a single option group.
local function setup_autocmds()
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })

  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter' }, {
    callback = refresh_buffers_and_tree,
  })
end

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

bootstrap_lazy()
setup_options()
setup_indentation()

setup_basic_keymaps()
setup_diagnostics_keymaps()
setup_file_keymaps()
setup_yank_keymaps()
setup_tab_keymaps()
setup_buffer_keymaps()
setup_quickfix_keymaps()
setup_arglist_keymaps()

setup_autocmds()
require 'user-settings'
