local lspconfig = require("lspconfig")

lspconfig.clangd.setup {
  cmd = {
    "clangd",
    "--offset-encoding=utf-16",
  },
  filetypes = {'cpp'}
}

-- Disable semantic highlighting for #ifdef blocks
-- see help lsp-semantic-highlighting
-- This was found using Inspect
vim.api.nvim_set_hl(0, '@lsp.type.comment', {sp = ''})
