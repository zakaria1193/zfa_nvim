-- Configure Mason (LSP Installer)
require("mason").setup()
require("mason-lspconfig").setup(
  {
    -- Use names from https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
    ensure_installed = {
      "bashls",
      "lua_ls",
      "jsonls",
      "clangd",
      "html",
      "cssls",
      "eslint",
      "tsserver",
      "ruff_lsp",
      "rust_analyzer",
    },
  }
)

-- Configure LSP
require "user.lsp.settings.lua_ls" -- lua_ls
require "user.lsp.settings.jsonls" -- jsonls
require "user.lsp.settings.clangd" -- clangd
require "user.lsp.settings.python" -- ruff-lsp (rust implem)
require "user.lsp.settings.webdev" -- html, css, eslint, tsserver
require "user.lsp.settings.shell" -- bashls
require "user.lsp.settings.none_ls" -- null-ls (Special LSP glue for formatting and linting)
require "user.lsp.settings.robot"
require "user.lsp.settings.rust"

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

-- Disable watchfunc for LSP for CPU usage reasons
-- see https://github.com/neovim/neovim/issues/23291#issuecomment-1560742827
require('vim.lsp._watchfiles')._watchfunc = function(_, _, _) return true end
