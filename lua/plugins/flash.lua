return {
    -- Jump anywhere on screen by typing a few chars, then a label
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {
        modes = {
            -- Leave f/t/F/T/;/, as native Vim motions (no flash labels on them).
            -- Set enabled = true (and optionally jump_labels = true) to enhance them.
            char = { enabled = false },
        },
    },
    keys = {
        { 's',     mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,              desc = 'Flash jump' },
        -- Treesitter select only in normal/operator modes; visual-mode `S` is left
        -- to vim-surround (surround the current selection).
        { 'S',     mode = { 'n', 'o' },      function() require('flash').treesitter() end,        desc = 'Flash Treesitter' },
        { 'r',     mode = 'o',               function() require('flash').remote() end,            desc = 'Remote Flash' },
        { 'R',     mode = { 'o', 'x' },      function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
        { '<c-s>', mode = { 'c' },           function() require('flash').toggle() end,            desc = 'Toggle Flash Search' },
    },
}
