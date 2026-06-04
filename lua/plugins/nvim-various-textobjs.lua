return {
  'chrisgrieser/nvim-various-textobjs',
  keys = {
    {
      'am',
      '<Cmd>lua require("various-textobjs").multiCommentedLines()<CR>',
      mode = { 'o', 'v' },
      desc = 'Select multiline comment',
    },
    {
      'im',
      '<Cmd>lua require("various-textobjs").multiCommentedLines()<CR>',
      mode = { 'o', 'v' },
      desc = 'Select multiline comment',
    },
  },
  config = function()
    require('various-textobjs').setup {
      useDefaultKeymaps = false,
    }
  end,
}
