return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
  keys = {
    { '<leader>gv', '<Cmd>DiffviewOpen<CR>', desc = '[G]it Diff[v]iew' },
    { '<leader>gf', '<Cmd>DiffviewFileHistory %<CR>', desc = '[G]it [F]ile history' },
    { '<leader>gq', '<Cmd>DiffviewClose<CR>', desc = '[G]it diffview [Q]uit' },
  },
  opts = {},
}
