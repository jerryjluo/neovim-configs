-- Leader key (must be set before plugins are loaded)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- =============================================================================
-- PLUGIN MANAGER
-- =============================================================================

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
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
  'tpope/vim-fugitive',            -- Git commands (:Git, :Gvdiffsplit, etc.)
  'tpope/vim-rhubarb',             -- GitHub integration for fugitive
  'shumphrey/fugitive-gitlab.vim', -- GitLab integration for fugitive
  'tpope/vim-surround',            -- Add/change/delete surrounding pairs (cs, ds, ys)
  'jeetsukumaran/vim-indentwise',  -- Motions based on indent levels ([-, ]+, etc.)
  'nvim-neotest/nvim-nio',         -- Async IO library (dependency for other plugins)
  require 'plugins.debug',         -- DAP debugger for Go and Python
  require 'plugins.filetree',      -- Neo-tree file explorer
  require 'plugins.gitsigns',      -- Git signs in gutter + hunk operations
  require 'plugins.lsp-signature', -- Function signature help while typing
  require 'plugins.lualine',       -- Status line
  require 'plugins.null-ls',       -- Linting and formatting (flake8, black, isort)
  require 'plugins.nvim-cmp',      -- Autocompletion engine
  require 'plugins.symbols-outline', -- Code outline sidebar
  require 'plugins.telescope',     -- Fuzzy finder for files, grep, buffers
  require 'plugins.treesitter',    -- Syntax highlighting and text objects
  require 'plugins.which-key',     -- Keymap hints popup
  require 'plugins.catppuccin',    -- Color theme
  require 'plugins.nvim-various-textobjs', -- Extra text objects (multiline comments, etc.)
  require 'plugins.claude-code',   -- Claude Code integration
}, {})

-- =============================================================================
-- OPTIONS
-- =============================================================================

vim.o.autoread = true
vim.o.hlsearch = true
vim.wo.number = true
vim.cmd("highlight LineNr guifg=#666729")
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.termguicolors = true
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Per-language indentation
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'json', 'jsonc' },
  callback = function()
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

-- =============================================================================
-- KEYMAPS
-- =============================================================================

-- Basic
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "'", "`")
vim.keymap.set('n', '<C-_>', '<Cmd>noh<CR>', { desc = 'Clear search' })
vim.keymap.set('t', '<C-]>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', '[$', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', ']$', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

vim.g.diagnostics_active = false
vim.diagnostic.config({ virtual_text = false })
local function toggle_diagnostic()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.diagnostic.config({ virtual_text = false })
  else
    vim.g.diagnostics_active = true
    vim.diagnostic.config({ virtual_text = true })
  end
end
vim.keymap.set('n', '<leader>dt', toggle_diagnostic, { desc = 'Toggle diagnostic' })

-- File
vim.keymap.set('n', '<leader>fl', '<Cmd>b#<CR>', { desc = '[F]ile [L]ast' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = '[F]ile [r]ecents' })
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').buffers, { desc = '[F]ile [o]pened' })
vim.keymap.set('n', '<leader>fe', '<Cmd>Ex<CR>', { desc = '[F]ile [E]xplore' })
vim.keymap.set('n', '<leader>fv', '<Cmd>Vex<CR>', { desc = '[F]ile Explore [V]ertical' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').find_files, { desc = '[F]ile [S]earch' })
vim.keymap.set('n', '<leader>ft', '<Cmd>Neotree toggle left<CR>', { desc = '[F]ile [T]ree' })
vim.keymap.set('n', '<leader>fc', '<Cmd>Neotree position=current<CR>', { desc = '[F]iletree [C]urrent position' })
vim.keymap.set('n', '<leader>fd', '<Cmd>w !git diff --no-index -- % -<CR>', { desc = '[F]ile [D]iff buffer edit' })

-- Git
vim.keymap.set('n', '<leader>gb', '<Cmd>Git blame<CR>', { desc = '[G]it [B]lame' })
vim.keymap.set('n', '<leader>gr', '<Cmd>Telescope git_branches<CR>', { desc = '[G]it B[r]anches' })
vim.keymap.set('n', '<leader>gs', '<Cmd>vertical Git<CR>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gl', '<Cmd>.GBrowse!<CR>', { desc = '[G]it [L]ink' })
vim.keymap.set('n', '<leader>gd', '<Cmd>Gvdiffsplit<CR>', { desc = '[G]it [D]iff against staged' })

-- Code
vim.keymap.set('n', '<leader>cf', '<Cmd>Format<CR>', { desc = '[C]ode [F]ormat' })

-- Yank
vim.keymap.set('n', '<leader>yr', '<Cmd>let @+ = expand("%")<CR>', { desc = '[Y]ank [R]elative path' })
vim.keymap.set('n', '<leader>ya', '<Cmd>let @+ = expand("%:p")<CR>', { desc = '[Y]ank [A]bsolute path' })
vim.keymap.set({ 'n', 'v' }, '<C-p>', '"0p', { desc = 'Paste down from last yank' })
vim.keymap.set({ 'n', 'v' }, '<C-P>', '"0P', { desc = 'Paste up from last yank' })

-- Tab
vim.keymap.set('n', '<leader>tn', '<Cmd>tabnew<CR>', { desc = '[T]ab [N]ew' })
vim.keymap.set('n', '<leader>tu', '<Cmd>tabnew %<CR>', { desc = '[T]ab D[u]plicate current file' })
vim.keymap.set('n', '<leader>tt', '<Cmd>tabnew | set nonu | term<CR>', { desc = '[T]ab new [T]erminal' })

-- Buffer
vim.keymap.set('n', '[b', '<Cmd>bprev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '[\\', '<Cmd>bprev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', '<Cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', ']\\', '<Cmd>bnext<CR>', { desc = 'Next buffer' })

-- Quickfix
vim.keymap.set('n', '[q', '<Cmd>cprev<CR>', { desc = 'Prev quickfix' })
vim.keymap.set('n', ']q', '<Cmd>cnext<CR>', { desc = 'Next quickfix' })
vim.keymap.set('n', '<leader>q', '<Cmd>copen<CR>', { desc = 'Open quickfix' })

-- Text objects
vim.keymap.set({ 'o', 'v' }, 'am', '<Cmd>lua require("various-textobjs").multiCommentedLines()<CR>',
  { desc = 'Select multiline comment' })
vim.keymap.set({ 'o', 'v' }, 'im', '<Cmd>lua require("various-textobjs").multiCommentedLines()<CR>',
  { desc = 'Select multiline comment' })

-- Argument list
vim.keymap.set('n', '[r', '<Cmd>previous<CR>', { desc = 'Previous argument' })
vim.keymap.set('n', '[`', '<Cmd>previous<CR>', { desc = 'Previous argument' })
vim.keymap.set('n', ']r', '<Cmd>next<CR>', { desc = 'Next argument' })
vim.keymap.set('n', ']`', '<Cmd>next<CR>', { desc = 'Next argument' })
vim.keymap.set('n', '<leader>ra', '<Cmd>arga %<CR>', { desc = 'Add current file to arglist' })
vim.keymap.set('n', '<leader>rr', '<Cmd>argd %<CR>', { desc = 'Remove current file to arglist' })
vim.keymap.set('n', '<leader>rl', '<Cmd>args<CR>', { desc = 'List the arglist' })

-- =============================================================================
-- AUTOCMDS
-- =============================================================================

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- =============================================================================
-- USER SETTINGS
-- =============================================================================

require('user-settings')

-- vim: ts=2 sts=2 sw=2 et
