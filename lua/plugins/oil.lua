return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- Load at startup so oil can hijack netrw when opening a directory
	-- (e.g. `nvim .` or following a path to a folder).
	lazy = false,
	opts = {
		default_file_explorer = true, -- replace netrw
		view_options = {
			show_hidden = true, -- matches Neo-tree (hide_dotfiles=false) + Telescope hidden-file convention
		},
		-- Skip the confirmation prompt for simple, safe filesystem edits.
		skip_confirm_for_simple_edits = true,
	},
}
