return {
	"chrisgrieser/nvim-various-textobjs",
	lazy = true,
    config = function()
        require('various-textobjs').setup {
            useDefaultKeymaps = false,
        }
    end,
}
