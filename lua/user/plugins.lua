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
	use({ "kyazdani42/nvim-web-devicons" })

  -- Explorer to replace netrw
  -- Press g? for help
	use({ "kyazdani42/nvim-tree.lua" })

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
	use({ "moll/vim-bbye" })

  -- Profiler -- call :LuaCacheProfile to run
	use({ "lewis6991/impatient.nvim" })

  -- Commenting tools
	use({ "numToStr/Comment.nvim" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

  --  Creates parenthesis pairs
	use({ "windwp/nvim-autopairs" })

  --- Interesting words
  use{'lfv89/vim-interestingwords'}

  -- Adds good indent to new lines
	use({ "lukas-reineke/indent-blankline.nvim" })

  -- Which key, key helper
	use("folke/which-key.nvim")

	-- Colorschemes
  use({ "lunarvim/darkplus.nvim", commit = "cb4340a802e68cb80feb81c5ffbc1c9d2af8494f"}) -- Dark Theme Do not update to version of novembre 2022 (Broken)

	-- Completion plugins
	use({ "hrsh7th/nvim-cmp" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer" }) -- buffer completions
	use({ "hrsh7th/cmp-path" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip" }) -- snippet completions, requires snipped engine (in snippets section)
	use({ "hrsh7th/cmp-nvim-lua" }) -- nvim lua completions
  ---- Add mode completion sources here, then config in cmp.lua
  use { "zbirenbaum/copilot-cmp", after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end }

  use({ "quangnguyen30192/cmp-nvim-tags" })

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
            },
          })
      end, 100)
    end,
  }
  -- ChatGPT
  use({
    "jackMort/ChatGPT.nvim",
      event = "VimEnter",
      config = function()
        require("chatgpt").setup({
          -- optional configuration
          popup_input = {
            submit = "<C-s>",
          },
        })
      end,
      requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
      }
  })

  -- LSP servers installer
  use { 'williamboman/mason.nvim', run = function() pcall(vim.cmd, 'MasonUpdate') end }
  use { "williamboman/mason-lspconfig.nvim" }
  -- LSP configurator
  use({ "neovim/nvim-lspconfig" })
  -- LSP autocomplete
  use({ "hrsh7th/cmp-nvim-lsp" })
  -- LSP snippets
  use({ "jose-elias-alvarez/null-ls.nvim", requires = { "nvim-lua/plenary.nvim" } })
  -- Trouble for diagnostics navigation
  use { "folke/trouble.nvim", requires = "nvim-tree/nvim-web-devicons" }

	-- Telescope
  use { "nvim-telescope/telescope.nvim" }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use {'gnfisher/nvim-telescope-ctags-plus'}

	-- Treesitter
  -- Helps nvim deeper understanding of the code
  -- makes autindent, highlight, autoparing parenthesis ..
	use({
		"nvim-treesitter/nvim-treesitter",
		commit = "v0.8.0",
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
	})
  -- make parenthesis in rainbows to tell matching easily
  use({"p00f/nvim-ts-rainbow"})

	-- Git
	use({ "lewis6991/gitsigns.nvim"})
  use({ "iberianpig/tig-explorer.vim" })

  -- Doxygen
  use({ "vim-scripts/DoxygenToolkit.vim" })

  -- Markdown preview
  use({ "iamcco/markdown-preview.nvim", run = function() vim.fn["mkdp#util#install"]() end, ft = 'markdown'})

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
