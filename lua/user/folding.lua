-- Enable folding
if vim.fn.has("nvim-0.10") == 1 then
-- Treesitter folding 
  vim.opt.foldmethod = "expr"
  vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
  vim.opt.foldtext = ""
  vim.opt.fillchars = "fold: "
else
  vim.opt.foldmethod = "indent"
end

-- Disable folding in Telescope results
vim.cmd([[
  autocmd FileType TelescopeResults setlocal nofoldenable
]])

-- Disable folding by default
vim.o.foldenable = false
