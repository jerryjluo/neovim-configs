return
{
	'folke/which-key.nvim',
	event = 'VeryLazy',
	config = function()
		local wk = require("which-key")

		wk.setup({
			notify = false,  -- disables which-key warnings and notifications
		})

		-- document existing key chains using new API
		wk.add({
			{ "<leader>a", group = "[A]I/Claude Code" },
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]iagnostics" },
			{ "<leader>f", group = "[F]ile" },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>h", group = "Git [H]unk" },
			{ "<leader>r", group = "A[r]glist" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>t", group = "[T]ab/Toggle" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>y", group = "[Y]ank" },
			-- visual mode groups
			{ "<leader>", group = "VISUAL <leader>", mode = "v" },
			{ "<leader>h", group = "Git [H]unk", mode = "v" },
		})
	end,
}
