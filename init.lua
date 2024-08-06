require "user.options"
require "user.diagnostics"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
require "user.cmp"
require "user.lsp"
require "user.telescope"
require "user.treesitter"
require "user.folding"
require "user.gitsigns"
require "user.nvim-tree"
require "user.lualine"
require "user.project"
require "user.indentline"
require "user.alpha"
require "user.autocommands"
require "user.gpt"
require "user.colorizer"
require "user.vim-gutentags"

require("hardtime").setup(
{
  disable_mouse = false,
  max_count = 10 -- Only nag if j/k pressed
})
