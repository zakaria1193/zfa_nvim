local fn = vim.fn

-- Automatically install lazy.nvim
local install_path = fn.stdpath("data") .. "/site/pack/lazy/start/lazy.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  LAZY_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    install_path,
  })
  print("Installing lazy.nvim, close and reopen Neovim...")
  vim.cmd([[packadd lazy.nvim]])
end

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

-- Use nvim 0.9+ new loader with byte-compilation cache
-- https://neovim.io/doc/user/lua.html#vim.loader
if vim.loader then vim.loader.enable() end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup lazy_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | Lazy sync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  return
end

-- Use nvim 0.9+ new loader with byte-compilation cache
-- https://neovim.io/doc/user/lua.html#vim.loader
if vim.loader then vim.loader.enable() end

-- Install your plugins here
lazy.setup({
  {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require('lspconfig').pyright.setup{}
    end
  },
  -- Profiler -- Run :StartupTime --help
  { "dstein64/vim-startuptime" },

  -- Lua libraries
  { "nvim-lua/plenary.nvim" },

  -- Pretty icons
  { 'nvim-tree/nvim-web-devicons' },

  -- Add brackets quotes easily
  { 'tpope/vim-surround' },

  -- Explorer to replace netrw
  -- Press g? for help
  { "nvim-tree/nvim-tree.lua" },

  -- Front Page
  { "goolord/alpha-nvim" },

  -- Hardtime (Disables arrow keys)
  { "m4xshen/hardtime.nvim" },

  -- Close all buffers but the current one
  { "numtostr/BufOnly.nvim", cmd = "BufOnly" },

  -- Status bar / buffer line
  { "nvim-lualine/lualine.nvim" },

  -- Project manager
  { "ahmedkhalf/project.nvim" },

  --  Commenting 
  --  We use native neovim 10+ commenting, but this is useful for cases
  --  when languages are embedded in other languages.
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  --- Interesting words (see whichkey ,k)
  { 'lfv89/vim-interestingwords' },

  -- Adds good indent to new lines, also adds colors to indent levels (highlight feature)
  { "lukas-reineke/indent-blankline.nvim" },

  -- Which key, key helper
  { "folke/which-key.nvim" },

  -- Colorschemes
  { "catppuccin/nvim", as = "catppuccin" },

  -- Completion plugins
  { "hrsh7th/nvim-cmp" }, -- The completion plugin
  { "hrsh7th/cmp-path" }, -- path completions
  { "hrsh7th/cmp-buffer" }, -- buffer completions
  { "saadparwaiz1/cmp_luasnip" }, -- snippet completions, requires snipped engine (in snippets section)
  { "hrsh7th/cmp-nvim-lua" }, -- nvim lua completions (such as vim.lsp.*...)
  { "hrsh7th/cmp-nvim-lsp" }, -- LSP autocomplete

  -- snippets
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },

  -- Vim gutentags (Delayed lazy load)
  { "mgedmin/vim-gutentags", event = "VimEnter", branch= "altpath" },

  -- Github Copilot (Delayed lazyload)
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup(
          {
            suggestion = {
              enabled = true,
              auto_trigger = true,
              debounce = 75,
              keymap = {
                accept = "<M-a>",
                accept_word = "<M-w>",
                accept_line = "<M-$>",
                next = "<M-n>",
                prev = "<M-p>",
                dismiss = "<C-]>",
              },
            },
            panel = { auto_refresh = true },
            filetypes = {
              markdown = true,
              yaml = true,
            },
          })
      end, 100)
    end,
  },

  -- ChatGPT
  { "robitx/gp.nvim" },

  -- LSP servers installer
  { 'williamboman/mason.nvim', run = function() pcall(vim.cmd, 'MasonUpdate') end },
  { "williamboman/mason-lspconfig.nvim" },
  -- LSP signature
  { "ray-x/lsp_signature.nvim" },

  -- None LS for linter/formatter configuration
  { "nvimtools/none-ls.nvim" }, -- null-ls
  { "jay-babu/mason-null-ls.nvim" }, -- Ensure linters and formatters are installed

  -- Telescope
  { "nvim-telescope/telescope.nvim" },
  { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },

  -- Treesitter
  -- treesitter is native to neovim, but this plugin adds a wrapper for auto installing
  -- and managing parsers, as well as additional higher level features
  -- nvim treesitter parsers the code and genertes a syntax tree for it
  -- it creates groups for each syntax element, which can be used to apply colors
  -- and other text properties.
  -- The plugins use these groups to apply colors and other text properties
  { 'nvim-treesitter/nvim-treesitter' },

  -- Treesitter context
  { "nvim-treesitter/nvim-treesitter-context" },

  -- Treesitter rainbow - make parenthesis in rainbows to tell matching easily
  { "p00f/nvim-ts-rainbow" },

  -- Highlighter (<f-Enter> to highlight word under cursor in visual mode)`
  { 'azabiong/vim-highlighter' },

  -- Git
  { "lewis6991/gitsigns.nvim" },
  { "iberianpig/tig-explorer.vim" },

  -- Doxygen
  { "vim-scripts/DoxygenToolkit.vim" },

  -- Markdown preview
  { "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, ft = 'markdown' },

  -- Highlight CSS colors
  { "norcalli/nvim-colorizer.lua" },
})

