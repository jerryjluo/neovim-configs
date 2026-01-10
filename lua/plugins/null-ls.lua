return {
  'nvimtools/none-ls.nvim',
  config = function ()
    local null_ls = require("null-ls")
    null_ls.setup {
      sources = {
        -- Python builtins (flake8, black, isort, autoflake) were removed from none-ls
        -- Consider using conform.nvim for formatting and nvim-lint for linting
      }
    }
  end
}
