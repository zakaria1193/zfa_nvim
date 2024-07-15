local options = {
  backup = false,                          -- creates a backup file
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 1,                           -- more space in the neovim command line for displaying messages
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 100,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  cursorline = true,                       -- highlight the current line
  number = true,                           -- set numbered lines
  relativenumber = false,                  -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = true,                             -- display lines as one long line
  scrolloff = 8,                           -- is one of my fav
  sidescrolloff = 8,
  virtualedit = "block",                   -- Allow the cursor to go anywhere in visual block mode.
  guifont = "monospace:h17",               -- the font used in graphical neovim applications
  colorcolumn = "100",                     -- highlight the 100th character
}

-- Appendings to existing options

vim.opt.cino:append("(0")-- Easy indent arguments on parenthesis with == see help cinoptions-values
-- TODO: Make specific to C Language
-- FIXME Maybe this is needed to be done within indent-blankline.nvim plugin

-- vim.opt.shortmess:append("c") -- Shorten messages given by completion menus

-- Replace characters with others
vim.opt.listchars:append({tab= '--', trail='␠', nbsp= '⎵'}) 
vim.opt.list = true

for k, v in pairs(options) do
vim.opt[k] = v  
end

-- Close terminal after leaving (NO process exited 0 buffer left)
vim.cmd("autocmd TermClose * execute 'bdelete! ' . expand('<abuf>')")

-- Highliht last column
vim.api.nvim_set_option_value("colorcolumn", "100", {})

vim.cmd "set whichwrap+=<,>,[,],h,l" -- TODO Do i need this
vim.cmd [[set iskeyword+=-]] -- TODO Do i need this
