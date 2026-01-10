--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)


-- [[ Configure plugins ]]
require('lazy').setup({
  'tpope/vim-fugitive',            -- git tool
  'tpope/vim-rhubarb',             -- enables fugitive with github
  'shumphrey/fugitive-gitlab.vim', -- enables fugitive with gitlab
  'tpope/vim-surround',
  'jeetsukumaran/vim-indentwise',
  'nvim-neotest/nvim-nio',
  require 'plugins.debug',
  require 'plugins.filetree',
  require 'plugins.gitsigns',
  require 'plugins.lsp-signature',
  require 'plugins.lualine',
  require 'plugins.null-ls',
  require 'plugins.nvim-cmp',
  -- require 'plugins.nvim-lspconfig',
  require 'plugins.symbols-outline',
  require 'plugins.telescope',
  require 'plugins.treesitter',
  require 'plugins.which-key',
  require 'plugins.catppuccin',
  require 'plugins.nvim-various-textobjs',
  require 'plugins.claude-code',
}, {})


-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Automatically reload the file if it has been modified elsewhere.
vim.o.autoread = true

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true
vim.cmd("highlight LineNr guifg=#666729")

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- TAB character will look like 4 spaces
vim.o.tabstop = 4

-- PresssingTAB will insert spaces instead
vim.o.expandtab = true

-- Number of spaces inserted instead of a TAB char
vim.o.softtabstop = 4

-- Number of spaces inserted when indenting
vim.o.shiftwidth = 4


-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
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

-- File key maps
vim.keymap.set('n', '<leader>fl', '<Cmd>b#<CR>', { desc = '[F]ile [L]ast' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = '[F]ile [r]ecents' })
vim.keymap.set('n', '<leader>fo', require('telescope.builtin').buffers, { desc = '[F]ile [o]pened' })
vim.keymap.set('n', '<leader>fe', '<Cmd>Ex<CR>', { desc = '[F]ile [E]xplore' })
vim.keymap.set('n', '<leader>fv', '<Cmd>Vex<CR>', { desc = '[F]ile Explore [V]ertical' })
vim.keymap.set('n', '<leader>fs', require('telescope.builtin').find_files, { desc = '[F]ile [S]earch' })
vim.keymap.set('n', '<leader>ft', '<Cmd>Neotree toggle left<CR>', { desc = '[F]ile [T]ree' })
vim.keymap.set('n', '<leader>fc', '<Cmd>Neotree position=current<CR>', { desc = '[F]iletree [C]urrent position' })
vim.keymap.set('n', '<leader>fd', '<Cmd>w !git diff --no-index -- % -<CR>', { desc = '[F]ile [D]iff buffer edit' })

-- Git key maps
vim.keymap.set('n', '<leader>gb', '<Cmd>Git blame<CR>', { desc = '[G]it [B]lame' })
vim.keymap.set('n', '<leader>gr', '<Cmd>Telescope git_branches<CR>', { desc = '[G]it B[r]anches' })
vim.keymap.set('n', '<leader>gs', '<Cmd>vertical Git<CR>', { desc = '[G]it [S]tatus' })
vim.keymap.set('n', '<leader>gl', '<Cmd>.GBrowse!<CR>', { desc = '[G]it [L]ink' })
vim.keymap.set('n', '<leader>gd', '<Cmd>Gvdiffsplit<CR>', { desc = '[G]it [D]iff against staged' })

-- Code key maps
vim.keymap.set('n', '<leader>cf', '<Cmd>Format<CR>', { desc = '[C]ode [F]ormat' })

-- Yank key maps
vim.keymap.set('n', '<leader>yr', '<Cmd>let @+ = expand("%")<CR>', { desc = '[Y]ank [R]elative path' })
vim.keymap.set('n', '<leader>ya', '<Cmd>let @+ = expand("%:p")<CR>', { desc = '[Y]ank [A]bsolute path' })
vim.keymap.set({ 'n', 'v' }, '<C-p>', '"0p', { desc = 'Paste down from last yank' })
vim.keymap.set({ 'n', 'v' }, '<C-P>', '"0P', { desc = 'Paste up from last yank' })

-- Tab key maps
vim.keymap.set('n', '<leader>tn', '<Cmd>tabnew<CR>', { desc = '[T]ab [N]ew' })
vim.keymap.set('n', '<leader>tu', '<Cmd>tabnew %<CR>', { desc = '[T]ab D[u]plicate current file' })
vim.keymap.set('n', '<leader>tt', '<Cmd>tabnew | set nonu | term<CR>', { desc = '[T]ab new [T]erminal' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Buffer key maps
vim.keymap.set('n', '[b', '<Cmd>bprev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '[\\', '<Cmd>bprev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', '<Cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', ']\\', '<Cmd>bnext<CR>', { desc = 'Next buffer' })

-- Quickfix key maps
vim.keymap.set('n', '[q', '<Cmd>cprev<CR>', { desc = 'Prev quickfix' })
vim.keymap.set('n', ']q', '<Cmd>cnext<CR>', { desc = 'Next quickfix' })
vim.keymap.set('n', '<leader>q', '<Cmd>copen<CR>', { desc = 'Open quickfix' })

-- Settings for various-textobjs
vim.keymap.set({ 'o', 'v' }, 'am', '<Cmd>lua require("various-textobjs").multiCommentedLines()<CR>',
  { desc = 'Select multiline comment' })
vim.keymap.set({ 'o', 'v' }, 'im', '<Cmd>lua require("various-textobjs").multiCommentedLines()<CR>',
  { desc = 'Select multiline comment' })

-- Map ' to ` for jumping to marks better
vim.keymap.set("n", "'", "`")

-- Clear search highlights
vim.keymap.set('n', '<C-_>', '<Cmd>noh<CR>', { desc = 'Clear search' })

-- Copilot keymaps
vim.keymap.set('n', '<leader>pp', '<Cmd>Copilot panel<CR>', { desc = 'Open copilot panel' })
vim.keymap.set('n', '<leader>ps', '<Cmd>Copilot status<CR>', { desc = 'Open copilot status' })
vim.keymap.set({ 'n', 'v' }, '<leader>pc', '<Cmd>CopilotChatToggle<CR>', { desc = 'Toggle copilot chat' })
vim.keymap.set({ 'n', 'v' }, '<leader>pa',
  function()
    local actions = require("CopilotChat.actions")
    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
  end,
  { desc = 'CopilogChat - Prompt actions' }
)
vim.keymap.set({ 'n', 'v' }, '<leader>pq',
  function()
    local input = vim.fn.input("Quick Chat: ")
    if input ~= "" then
      require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
    end
  end,
  { desc = 'CopilotChat - Quick chat' }
)

-- Argument list keymaps
vim.keymap.set('n', '[r', '<Cmd>previous<CR>', { desc = 'Previous argument' })
vim.keymap.set('n', '[`', '<Cmd>previous<CR>', { desc = 'Previous argument' })
vim.keymap.set('n', ']r', '<Cmd>next<CR>', { desc = 'Next argument' })
vim.keymap.set('n', ']`', '<Cmd>next<CR>', { desc = 'Next argument' })
vim.keymap.set('n', '<leader>ra', '<Cmd>arga %<CR>', { desc = 'Add current file to arglist' })
vim.keymap.set('n', '<leader>rr', '<Cmd>argd %<CR>', { desc = 'Remove current file to arglist' })
vim.keymap.set('n', '<leader>rl', '<Cmd>args<CR>', { desc = 'List the arglist' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Load user specific configurations
require('user-settings')

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
