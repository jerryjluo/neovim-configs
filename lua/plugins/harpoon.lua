return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local harpoon = require('harpoon')
		harpoon:setup()

		local function harpoon_telescope(harpoon_files)
			local conf = require('telescope.config').values
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end
			require('telescope.pickers').new({}, {
				prompt_title = 'Harpoon',
				finder = require('telescope.finders').new_table({ results = file_paths }),
				previewer = conf.file_previewer({}),
				sorter = conf.generic_sorter({}),
			}):find()
		end

		vim.keymap.set('n', '<leader>ma', function() harpoon:list():add() end,
			{ desc = '[M]ark [A]dd to harpoon' })
		vim.keymap.set('n', '<leader>mm', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
			{ desc = '[M]ark [M]enu (harpoon)' })
		vim.keymap.set('n', '<leader>ms', function() harpoon_telescope(harpoon:list()) end,
			{ desc = '[M]ark [S]earch (telescope)' })
		vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon 1' })
		vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon 2' })
		vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon 3' })
		vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon 4' })
	end,
}
