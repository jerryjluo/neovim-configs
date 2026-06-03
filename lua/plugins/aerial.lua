return {
	'stevearc/aerial.nvim',
	dependencies = {
		'nvim-treesitter/nvim-treesitter',
		'nvim-tree/nvim-web-devicons',
	},
	cmd = { 'AerialToggle', 'AerialOpen', 'AerialNavToggle' },
	-- Load on file open so the `[s`/`]s` motions (and breadcrumb) work without
	-- having to open the outline first.
	event = { 'BufReadPost', 'BufNewFile' },
	keys = {
		-- `!` keeps focus in the code; the outline just opens on the right.
		{ '<leader>co', '<Cmd>AerialToggle!<CR>', desc = '[C]ode [O]utline' },
		{ '<leader>cs', '<Cmd>Telescope aerial<CR>', desc = '[C]ode [S]ymbols (aerial)' },
	},
	config = function()
		require('aerial').setup {
			-- Always open the outline on the right-hand side.
			layout = { default_direction = 'right' },
			-- Prefer treesitter, fall back to LSP, then markdown.
			backends = { 'treesitter', 'lsp', 'markdown', 'man' },
			on_attach = function(bufnr)
				-- Jump between symbols at the current tree level. These override
				-- Neovim's built-in `[[`/`]]` section motions in buffers aerial
				-- attaches to. The treesitter class-jump that used to live on
				-- `[[`/`]]` was removed from treesitter.lua to avoid a conflict.
				vim.keymap.set('n', '[[', '<Cmd>AerialPrev<CR>',
					{ buffer = bufnr, desc = 'Previous symbol (aerial)' })
				vim.keymap.set('n', ']]', '<Cmd>AerialNext<CR>',
					{ buffer = bufnr, desc = 'Next symbol (aerial)' })
			end,
		}
		-- Register the Telescope picker (`:Telescope aerial`). Safe no-op if
		-- Telescope is unavailable for some reason.
		pcall(require('telescope').load_extension, 'aerial')
	end,
}
