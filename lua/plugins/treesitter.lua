return
{
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
        -- [[ Configure Treesitter ]]
        -- See `:help nvim-treesitter`
        -- tree-sitter CLI >= 0.26 removed the `--no-bindings` flag from `generate`
        -- (bindings are no longer generated there). nvim-treesitter still passes it
        -- for any CLI > 0.20.2, breaking grammars that build from source (e.g. swift).
        -- Override the generate args to drop the obsolete flag.
        require('nvim-treesitter.install').ts_generate_args =
            { 'generate', '--abi', vim.treesitter.language_version }
        -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
        require('nvim-treesitter.configs').setup {
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'markdown', 'rust', 'swift', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

            -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
            auto_install = false,
            -- Install languages synchronously (only applied to `ensure_installed`)
            sync_install = false,
            -- List of parsers to ignore installing
            ignore_install = {},
            -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
            modules = {},
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
                    scope_incremental = '<c-s>',
                    node_decremental = '<M-space>',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                    selection_modes = {
                        ['@function.outer'] = 'V',
                        ['@class.outer'] = 'V',
                    }
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']f'] = '@function.outer',
                        [']#'] = '@function.outer',
                        [']a'] = '@parameter.inner',
                        [']@'] = '@parameter.inner',
                    },
                    goto_next_end = {
                        [']g'] = '@function.outer',
                        [']|'] = '@function.outer',
                        [']['] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[f'] = '@function.outer',
                        ['[#'] = '@function.outer',
                        ['[a'] = '@parameter.inner',
                        ['[@'] = '@parameter.inner',
                    },
                    goto_previous_end = {
                        ['[g'] = '@function.outer',
                        ['[|'] = '@function.outer',
                        ['[]'] = '@class.outer',
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['<leader>cwn'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<leader>cwp'] = '@parameter.inner',
                    },
                },
            },
        }
    end
}
