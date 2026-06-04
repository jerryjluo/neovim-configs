return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "|", "<cmd>Neotree toggle reveal<cr>", desc = "Toggle Neotree" },
		{ "<leader>ft", "<Cmd>Neotree toggle left<CR>", desc = "[F]ile [T]ree" },
		{ "<leader>fc", "<Cmd>Neotree position=current<CR>", desc = "[F]iletree [C]urrent position" },
	},
	config = function()
		require("neo-tree").setup({
			window = {
				width = 30,
				mappings = {
					["y"] = "noop",
					["Y"] = "copy_to_clipboard",
					["yr"] = {
						function(state)
							local node = state.tree:get_node()
							local path = vim.fn.fnamemodify(node.path, ":.")
							vim.fn.setreg("+", path)
							vim.notify("Copied: " .. path)
						end,
						desc = "Yank relative path",
					},
					["ya"] = {
						function(state)
							local node = state.tree:get_node()
							vim.fn.setreg("+", node.path)
							vim.notify("Copied: " .. node.path)
						end,
						desc = "Yank absolute path",
					},
				},
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = {
					enabled = true,
				},
			},
		})
	end,
}
