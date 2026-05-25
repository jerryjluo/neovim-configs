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
	},
	config = function()
		require("neo-tree").setup({
			window = {
				width = 30,
				mappings = {
					["Y"] = function(state)
						local node = state.tree:get_node()
						local path = vim.fn.fnamemodify(node.path, ":.")
						vim.fn.setreg("+", path)
						vim.notify("Copied: " .. path)
					end,
					["gy"] = function(state)
						local node = state.tree:get_node()
						vim.fn.setreg("+", node.path)
						vim.notify("Copied: " .. node.path)
					end,
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
