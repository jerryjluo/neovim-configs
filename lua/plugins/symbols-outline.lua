return {
	'simrat39/symbols-outline.nvim',
	cmd = 'SymbolsOutline',
	keys = {
		{ '<leader>co', '<Cmd>SymbolsOutline<CR>', desc = '[C]ode [O]utline' },
	},
	config = function()
		require('symbols-outline').setup()
	end,
}
