return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = false, lsp_format = 'fallback' }
      end,
      desc = '[C]ode [F]ormat',
    },
  },
  opts = {
    -- Only these filetypes have a dedicated formatter configured, so only they
    -- format on save (scope: well-supported languages). Other filetypes are
    -- left untouched on save; <leader>cf still falls back to the LSP for them.
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'gofmt' },
      rust = { 'rustfmt' },
    },
    -- lsp_format = 'never': don't let format-on-save reach for an LSP formatter
    -- for filetypes not listed above, keeping the scope tight.
    format_on_save = { timeout_ms = 1000, lsp_format = 'never' },
  },
}
