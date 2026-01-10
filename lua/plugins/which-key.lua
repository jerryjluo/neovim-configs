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
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>cw", group = "Treesitter: [C]ode S[w]ap" },
			{ "<leader>d", group = "[D]iagnostics" },
			{ "<leader>g", group = "[G]it" },
			{ "<leader>h", group = "Git [H]unk" },
			{ "<leader>s", group = "[S]earch" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>w", group = "[W]orkspace" },
			{ "<leader>y", group = "[Y]ank" },
			{ "<leader>f", group = "[F]ile" },
			{ "<leader>o", group = "[O]bsidian" },
			-- visual mode groups
			{ "<leader>", group = "VISUAL <leader>", mode = "v" },
			{ "<leader>h", group = "Git [H]unk", mode = "v" },
		})
	end,
}
