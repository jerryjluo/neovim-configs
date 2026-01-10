return
{
	'simrat39/symbols-outline.nvim',
	config = function()
		require('symbols-outline').setup()
		vim.keymap.set('n', '<leader>co', '<Cmd>SymbolsOutline<CR>', { desc = '[C]ode [O]utline' })
	end,
}
