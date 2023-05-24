-- Configure Mason (LSP Installer)
require("mason").setup()
require("mason-lspconfig").setup(
  {
    -- Use names from https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
    ensure_installed = {
      "lua_ls",
      "pyright",
      "jsonls",
      "clangd",
      "html",
      "cssls",
      "eslint",
      "tsserver"
    },
  }
)

-- Configure LSP
require "user.lsp.settings.pyright"
require "user.lsp.settings.lua_ls"
require "user.lsp.settings.jsonls"
require "user.lsp.settings.clangd"
require "user.lsp.settings.webdev" -- JavaScript, TypeScript, HTML, CSS LSPs
require "user.lsp.settings.null_ls" -- null-ls (Special LSP glue for formatting and linting)

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
