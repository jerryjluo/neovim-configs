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
		-- Buffer-local yank-path mappings (only active inside Oil buffers).
		keymaps = {
			["<leader>yr"] = {
				desc = "Oil: yank relative path",
				callback = function()
					local oil = require("oil")
					local entry = oil.get_cursor_entry()
					local dir = oil.get_current_dir()
					if not entry or not dir then
						return
					end
					local path = vim.fn.fnamemodify(dir .. entry.name, ":.") -- relative to cwd
					vim.fn.setreg("+", path)
					vim.notify("Yanked: " .. path)
				end,
			},
			["<leader>ya"] = {
				desc = "Oil: yank absolute path",
				callback = function()
					local oil = require("oil")
					local entry = oil.get_cursor_entry()
					local dir = oil.get_current_dir()
					if not entry or not dir then
						return
					end
					local path = dir .. entry.name -- already absolute
					vim.fn.setreg("+", path)
					vim.notify("Yanked: " .. path)
				end,
			},
		},
	},
}
