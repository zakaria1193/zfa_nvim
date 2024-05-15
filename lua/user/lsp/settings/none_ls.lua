local _, null_ls = pcall(require, "null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.cppcheck,
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
})

-- Ensure formatter are installed using mason-null-ls
-- WARNING: must be called after null_ls.setup
require("mason-null-ls").setup({automatic_installation = true})

-- Fix encoding issues with null-ls
-- For some reason this doesn't work in the first setup call
null_ls.setup({
  on_init = function(new_client, _)
    new_client.offset_encoding = 'utf-32'
  end,
})
