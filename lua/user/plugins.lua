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
	use({ "wbthomason/packer.nvim", commit = "00ec5adef58c5ff9a07f11f45903b9dbbaa1b422" }) -- Have packer manage itself

  -- Lua libraries
	use({ "nvim-lua/plenary.nvim", commit = "968a4b9afec0c633bc369662e78f8c5db0eba249" }) -- Useful lua functions used by lots of plugins

  -- Pretty icons
	use({ "kyazdani42/nvim-web-devicons", commit = "8d2c5337f0a2d0a17de8e751876eeb192b32310e" })

  -- Explorer to replace netrw
  -- Press g? for help
	use({ "kyazdani42/nvim-tree.lua", commit = "bdb6d4a25410da35bbf7ce0dbdaa8d60432bc243" }) 

  -- Front Page
	use({ "goolord/alpha-nvim", commit = "ef27a59e5b4d7b1c2fe1950da3fe5b1c5f3b4c94" })

  -- Bufferline
	use({ "akinsho/bufferline.nvim", commit = "c78b3ecf9539a719828bca82fc7ddb9b3ba0c353" })

  -- Close all buffers but the current one
  use({ "numtostr/BufOnly.nvim", cmd = "BufOnly" })

  -- Status bar
	use({ "nvim-lualine/lualine.nvim", commit = "3362b28f917acc37538b1047f187ff1b5645ecdd" })

  -- Project manager
	use({ "ahmedkhalf/project.nvim", commit = "541115e762764bc44d7d3bf501b6e367842d3d4f" })
	use({ "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" })

  -- Profiler -- call :LuaCacheProfile to run
	use({ "lewis6991/impatient.nvim", commit = "969f2c5c90457612c09cf2a13fee1adaa986d350" })

  -- Commenting tools
	use({ "numToStr/Comment.nvim", commit = "2c26a00f32b190390b664e56e32fd5347613b9e2" })
	use({ "JoosepAlviste/nvim-ts-context-commentstring", commit = "88343753dbe81c227a1c1fd2c8d764afb8d36269" })

  --  Creates parenthesis pairs
	use({ "windwp/nvim-autopairs", commit = "fa6876f832ea1b71801c4e481d8feca9a36215ec" }) -- Autopairs, integrates with both cmp and treesitter

  -- Adds good indent to new lines
	use({ "lukas-reineke/indent-blankline.nvim", commit = "6177a59552e35dfb69e1493fd68194e673dc3ee2" })

  -- Which key, key helper
	use("folke/which-key.nvim")

	-- Colorschemes
	use({ "folke/tokyonight.nvim", commit = "8223c970677e4d88c9b6b6d81bda23daf11062bb" })
	use({ "lunarvim/darkplus.nvim", commit = "cb4340a802e68cb80feb81c5ffbc1c9d2af8494f"}) -- Dark Theme Do not update to version of novembre 2022 (Broken)

	-- Completion plugins
	use({ "hrsh7th/nvim-cmp", commit = "df6734aa018d6feb4d76ba6bda94b1aeac2b378a" }) -- The completion plugin
	use({ "hrsh7th/cmp-buffer", commit = "62fc67a2b0205136bc3e312664624ba2ab4a9323" }) -- buffer completions
	use({ "hrsh7th/cmp-path", commit = "466b6b8270f7ba89abd59f402c73f63c7331ff6e" }) -- path completions
	use({ "saadparwaiz1/cmp_luasnip", commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" }) -- snippet completions, requires snipped engine (in snippets section)
	use({ "hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" })
  ---- Add mode completion sources here, then config in cmp.lua
  use { "zbirenbaum/copilot-cmp", after = { "copilot.lua" },
    config = function ()
      require("copilot_cmp").setup()
    end }

  use({ "quangnguyen30192/cmp-nvim-tags" })

	-- snippets
	use({ "L3MON4D3/LuaSnip", commit = "79b2019c68a2ff5ae4d732d50746c901dd45603a" }) --snippet engine
	use({ "rafamadriz/friendly-snippets", commit = "d27a83a363e61009278b6598703a763ce9c8e617" }) -- a bunch of snippets to use

  -- Vim gutentags (Delayed lazy load)
  use({ "ludovicchabant/vim-gutentags", event = "VimEnter" })

  -- Github Copilot (Delayed lazyload)
  use {
    "zbirenbaum/copilot.lua",
    event = "VimEnter",
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
        })
      end,
      requires = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
      }
  })

	-- LSP
--	use({ "neovim/nvim-lspconfig", commit = "148c99bd09b44cf3605151a06869f6b4d4c24455" }) -- enable LSP
--	use({ "williamboman/nvim-lsp-installer", commit = "e9f13d7acaa60aff91c58b923002228668c8c9e6" }) -- simple to use language server installer
--	use({ "jose-elias-alvarez/null-ls.nvim", commit = "ff40739e5be6581899b43385997e39eecdbf9465" }) -- for formatters and linters
---	use({ "hrsh7th/cmp-nvim-lsp", commit = "main" })

	-- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end
  }
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
