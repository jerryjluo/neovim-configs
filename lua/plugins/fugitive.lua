return {
  'tpope/vim-fugitive', -- Git commands (:Git, :Gvdiffsplit, etc.)
  dependencies = {
    'tpope/vim-rhubarb', -- GitHub integration (:GBrowse)
    'shumphrey/fugitive-gitlab.vim', -- GitLab integration (:GBrowse)
  },
  -- Lazy-load on the commands and keymaps below; dependencies load with it so
  -- :GBrowse resolves GitHub/GitLab URLs.
  cmd = { 'Git', 'G', 'Gvdiffsplit', 'GBrowse' },
  keys = {
    { '<leader>gb', '<Cmd>Git blame<CR>', desc = '[G]it [B]lame' },
    { '<leader>gl', '<Cmd>.GBrowse!<CR>', desc = '[G]it [L]ink' },
    { '<leader>gd', '<Cmd>Gvdiffsplit<CR>', desc = '[G]it [D]iff against staged' },
    { '<leader>gc', '<Cmd>Git commit<CR>', desc = '[G]it [C]ommit' },
  },
}
