local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

-- Declare variable for max lines
local max_file_lines = 3000

configs.setup({
	ensure_installed = "all", -- one of "all" or a list of languages
	ignore_install = { "" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css" }, -- list of language that will be disabled
    is_supported = function ()
      if vim.fn.strwidth(vim.fn.getline('.')) > max_file_lines
        or vim.fn.getfsize(vim.fn.expand('%')) > 1024 * 1024 then
        return false
      else
        return true
      end
    end
	},
	autopairs = {
		enable = true,
	},
	indent = { enable = true, disable = { "css" } }, -- TODO Test this with python, could be not ok
  rainbow = {
    enable = true,
    -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = max_file_lines, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  }
})

