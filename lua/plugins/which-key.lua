return
{
	'folke/which-key.nvim',
	event = 'VeryLazy',
	config = function()
		-- document existing key chains
		require('which-key').register {
			['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
			['<leader>cw'] = { name = 'Treesitter: [C]ode S[w]ap', _ = 'which_key_ignore' },
			['<leader>d'] = { name = '[D]iagnostics', _ = 'which_key_ignore' },
			['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
			['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
			['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
			['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
			['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
			['<leader>y'] = { name = '[Y]ank', _ = 'which_key_ignore' },
			['<leader>f'] = { name = '[F]ile', _ = 'which_key_ignore' },
			['<leader>o'] = { name = '[O]bsidian', _ = 'which_key_ignore' },
		}
		-- register which-key VISUAL mode
		-- required for visual <leader>hs (hunk stage) to work
		require('which-key').register({
			['<leader>'] = { name = 'VISUAL <leader>' },
			['<leader>h'] = { 'Git [H]unk' },
		}, { mode = 'v' })

		require("which-key").setup({
			notify = false,  -- disables which-key warnings and notifications
		})
	end,
}
