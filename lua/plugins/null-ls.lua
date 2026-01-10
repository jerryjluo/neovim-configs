return {
  'jose-elias-alvarez/null-ls.nvim',
  config = function ()
    local null_ls = require("null-ls")
    null_ls.setup {
      sources = {
        null_ls.builtins.diagnostics.flake8.with {
          extra_args = {"--max-line-length", "88"},
        },
        null_ls.builtins.formatting.autoflake,
        null_ls.builtins.formatting.black.with {
          extra_args = {"--preview", "--enable-unstable-feature", "string_processing"}
        },
        null_ls.builtins.formatting.isort,
      }
    }
  end
}
