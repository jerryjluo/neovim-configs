return {
  -- Sticky scroll: pin the enclosing function/class/scope to the top of the window
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    max_lines = 3, -- max sticky lines (0 = unlimited)
    multiline_threshold = 1, -- collapse multiline contexts to a single line
    trim_scope = 'inner', -- when over max_lines, discard innermost contexts first (keep outer scopes like func/class header)
    mode = 'topline', -- derive context from the top visible line (stable while scrolling)
  },
  config = function(_, opts)
    local tsc = require 'treesitter-context'
    tsc.setup(opts)
    vim.keymap.set('n', '<leader>tc', tsc.toggle, { desc = '[T]oggle sticky [C]ontext' })
  end,
}
