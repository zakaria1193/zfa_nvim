local status, null_ls = pcall(require, "none-ls")
if (not status) then return end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == "null-ls"
    end,
    bufnr = bufnr,
  })
end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.cppcheck,
    null_ls.builtins.diagnostics.bashls,
    null_ls.builtins.diagnostics.markdownlint,
    null_ls.builtins.diagnostics.mypy,
    null_ls.builtins.diagnostics.pylint.with({
      diagnostics_postprocess = function(diagnostic)
        diagnostic.code = diagnostic.message_id
      end,
    }),
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
  },
  root_dir = require("null-ls.utils").root_pattern(".null-ls-root"),
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          lsp_formatting(bufnr)
        end,
      })
    end
  end,
})

-- Fix encoding issues with null-ls
-- For some reason this doesn't work in the first setup call
null_ls.setup({
  on_init = function(new_client, _)
    new_client.offset_encoding = 'utf-32'
  end,
})

vim.api.nvim_create_user_command(
  'DisableLspFormatting',
  function()
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
  end,
  { nargs = 0 }
)

-- Ensure formatter are installed using mason-null-ls
require("mason-null-ls").setup({
    ensure_installed = {
    "mypy",
    "bashls",
    "cppcheck",
    "markdownlint",
    "prettierd"
}})
