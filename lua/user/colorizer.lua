--- Config for colorizer
--- colorizes colors in code

-- Attach to certain Filetypes, add special configuration for `html`
-- Use `background` for everything else.
require 'colorizer'.setup {
  'css';
  'javascript';
  'html';
  'python';
  'lua';
}

