-- Configure Mason (LSP Installer)
require("mason").setup()
require("mason-lspconfig").setup(
  {
    -- Do not use ensure_installed, instead auto install anything configured
    -- through lspconfig.
    automatic_installation = true,
  }
)

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim client doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
Lsp_client_capabilities = vim.lsp.protocol.make_client_capabilities()
lsp_client_capabilities = vim.tbl_deep_extend('force', Lsp_client_capabilities, require('cmp_nvim_lsp').default_capabilities())

-- Warning: Do not use `require("mason-lspconfig").setup_handlers`, it's incompatible with calling
-- `require("lspconfig").<server>.setup` directly which we do below.

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

-- LSP hover styling
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded', focusable = false}
)

-- LSP signature help styling
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'double', focusable = false}
)
