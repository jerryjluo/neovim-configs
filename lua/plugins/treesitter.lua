return
{
    -- Highlight, edit, and navigate code
    --
    -- Uses the `main` branch of nvim-treesitter. The old `master` branch is
    -- frozen and does NOT support Neovim 0.12+, which caused the highlighter
    -- crash `treesitter.lua: attempt to call method 'range' (a nil value)`.
    -- The `main` branch removes `nvim-treesitter.configs`: parsers are installed
    -- via `require('nvim-treesitter').install`, highlighting is enabled with a
    -- FileType autocmd, and textobjects are wired up with explicit keymaps.
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
        { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    config = function()
        -- Parsers to keep installed (replaces the old `ensure_installed`).
        -- `install` is async on first run; reopen the buffer if a parser was
        -- just fetched. `markdown_inline` powers fenced code blocks in markdown.
        require('nvim-treesitter').install {
            'c', 'cpp', 'go', 'lua', 'python', 'markdown', 'markdown_inline',
            'rust', 'swift', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash',
        }

        -- Enable treesitter highlighting per buffer. `language.add` returns false
        -- for filetypes without an installed parser, so we skip those quietly.
        vim.api.nvim_create_autocmd('FileType', {
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
                if lang and vim.treesitter.language.add(lang) then
                    vim.treesitter.start(args.buf, lang)
                end
            end,
        })

        -- Indentation and incremental selection intentionally omitted: indent is
        -- experimental on the `main` branch, and incremental selection was dropped
        -- from the plugin entirely.

        -- [[ Textobjects ]]
        require('nvim-treesitter-textobjects').setup {
            select = {
                lookahead = true, -- jump forward to textobj, similar to targets.vim
                selection_modes = {
                    ['@function.outer'] = 'V',
                    ['@class.outer'] = 'V',
                },
            },
            move = {
                set_jumps = true, -- add movements to the jumplist
            },
        }

        -- Select keymaps (visual + operator-pending)
        local select = require 'nvim-treesitter-textobjects.select'
        local select_maps = {
            ['aa'] = { '@parameter.outer', 'a parameter' },
            ['ia'] = { '@parameter.inner', 'inner parameter' },
            ['af'] = { '@function.outer', 'a function' },
            ['if'] = { '@function.inner', 'inner function' },
            ['ac'] = { '@class.outer', 'a class' },
            ['ic'] = { '@class.inner', 'inner class' },
        }
        for key, spec in pairs(select_maps) do
            vim.keymap.set({ 'x', 'o' }, key, function()
                select.select_textobject(spec[1], 'textobjects')
            end, { desc = 'Select ' .. spec[2] })
        end

        -- Move keymaps (normal + visual + operator-pending)
        local move = require 'nvim-treesitter-textobjects.move'
        local move_maps = {
            goto_next_start = {
                [']f'] = { '@function.outer', 'Next function start' },
                [']#'] = { '@function.outer', 'Next function start' },
                [']a'] = { '@parameter.inner', 'Next parameter start' },
                [']@'] = { '@parameter.inner', 'Next parameter start' },
            },
            goto_next_end = {
                [']g'] = { '@function.outer', 'Next function end' },
                [']|'] = { '@function.outer', 'Next function end' },
                [']['] = { '@class.outer', 'Next class end' },
            },
            goto_previous_start = {
                ['[f'] = { '@function.outer', 'Previous function start' },
                ['[#'] = { '@function.outer', 'Previous function start' },
                ['[a'] = { '@parameter.inner', 'Previous parameter start' },
                ['[@'] = { '@parameter.inner', 'Previous parameter start' },
            },
            goto_previous_end = {
                ['[g'] = { '@function.outer', 'Previous function end' },
                ['[|'] = { '@function.outer', 'Previous function end' },
                ['[]'] = { '@class.outer', 'Previous class end' },
            },
        }
        for fn, maps in pairs(move_maps) do
            for key, spec in pairs(maps) do
                vim.keymap.set({ 'n', 'x', 'o' }, key, function()
                    move[fn](spec[1], 'textobjects')
                end, { desc = spec[2] })
            end
        end

        -- Swap keymaps (param swap; keeps the <leader>cw which-key group)
        local swap = require 'nvim-treesitter-textobjects.swap'
        vim.keymap.set('n', '<leader>cwn', function()
            swap.swap_next '@parameter.inner'
        end, { desc = 'Swap next parameter' })
        vim.keymap.set('n', '<leader>cwp', function()
            swap.swap_previous '@parameter.inner'
        end, { desc = 'Swap previous parameter' })
    end,
}
