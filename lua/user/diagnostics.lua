-- Setup Diagnostics
-- And add some global functions used in keymaps

vim.diagnostic.config {
  virtual_text = {
    source = "if_many",
    prefix = '● ',
  },
  underline = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
  },
}

