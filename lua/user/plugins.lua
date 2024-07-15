local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end
-- Use nvim 0.9+ new loader with byte-compilation cache
-- https://neovim.io/doc/user/lua.html#vim.loader
if vim.loader then vim.loader.enable() end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- Plugin manager
	use({ "wbthomason/packer.nvim" })

  -- Lua libraries
	use({ "nvim-lua/plenary.nvim" })

  -- Pretty icons
  use 'nvim-tree/nvim-web-devicons'

  -- Explorer to replace netrw
  -- Press g? for help
	use({ "nvim-tree/nvim-tree.lua" })

  -- Front Page
	use({ "goolord/alpha-nvim" })

  -- Bufferline
	use({ "akinsho/bufferline.nvim" })

  -- Close all buffers but the current one
  use({ "numtostr/BufOnly.nvim", cmd = "BufOnly" })

  -- Status bar
	use({ "nvim-lualine/lualine.nvim" })

  -- Project manager
	use({ "ahmedkhalf/project.nvim" })

  -- Commenting tools
	use({ "numToStr/Comment.nvim" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

  --- Interesting words (see whichkey ,k)
  use{'lfv89/vim-interestingwords'}

  -- Adds good indent to new lines
	use({ "lukas-reineke/indent-blankline.nvim" })

  -- Which key, key helper
	use("folke/which-key.nvim")

	-- Colorschemes
  use { "catppuccin/nvim", as = "catppuccin" }


	-- Completion plugins
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions, requires snipped engine (in snippets section)
	use({ "hrsh7th/cmp-nvim-lua" }) -- nvim lua completions (such as vim.lsp.*...)
  use({ "hrsh7th/cmp-nvim-lsp" }) -- LSP autocomplete

	-- snippets
	use({ "L3MON4D3/LuaSnip" })
	use({ "rafamadriz/friendly-snippets" })

  -- Vim gutentags (Delayed lazy load)
  use({ "ludovicchabant/vim-gutentags", event = "VimEnter" })

  -- Github Copilot (Delayed lazyload)
  use {
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
  }

  -- ChatGPT
  use({
      "robitx/gp.nvim"
  })

  -- LSP servers installer
  use { 'williamboman/mason.nvim', run = function() pcall(vim.cmd, 'MasonUpdate') end }
  use { "williamboman/mason-lspconfig.nvim" }
  -- LSP configurator
  use({ "neovim/nvim-lspconfig" })
  -- LSP signature
  use({ "ray-x/lsp_signature.nvim" })

  -- None LS for linter/formatter configuration
  use({ "nvimtools/none-ls.nvim" }) -- null-ls
  use({"jay-babu/mason-null-ls.nvim"}) -- Ensure linters and formatters are installed


	-- Telescope
  use { "nvim-telescope/telescope.nvim" }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

-- Treesitter
-- treesitter is native to neovim, but this plugin adds a wrapper for auto installing
-- and managing parsers, as well as additional higher level features
-- nvim treesitter parsers the code and genertes a syntax tree for it
-- it creates groups for each syntax element, which can be used to apply colors
-- and other text properties.
-- The plugins use these groups to apply colors and other text properties
  use {
      'nvim-treesitter/nvim-treesitter'
  }

  -- Treesitter context
  use({ "nvim-treesitter/nvim-treesitter-context" })

  -- Treesitter rainbow - make parenthesis in rainbows to tell matching easily
  use({"p00f/nvim-ts-rainbow"})

  -- Highlighter (<f-Enter> to highlight word under cursor in visual mode)`
  use({ 'azabiong/vim-highlighter' })

	-- Git
	use({ "lewis6991/gitsigns.nvim"})
  use({ "iberianpig/tig-explorer.vim" })

  -- Doxygen
  use({ "vim-scripts/DoxygenToolkit.vim" })

  -- Markdown preview
  use({ "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, ft = 'markdown'})

  -- Highlight CSS colors
  use({ "norcalli/nvim-colorizer.lua" })

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)

