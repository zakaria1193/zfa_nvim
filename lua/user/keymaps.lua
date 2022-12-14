-- If you DO want the mapping to be recursive, set the "remap" option to "true"
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap comma as leader key
keymap("", "<,>", "<Nop>", opts)
vim.g.maplocalleader = ","
vim.g.mapleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

------------------------------------------------------------------------------------------------
-- Normal --
-- Warning: All <leader> based commands in normal mode should be added in whichkey.lua
-- to make full use of whichkey

-- Navigate buffers
keymap("n", "<C-PageDown>",   ":bnext<CR>", opts)
keymap("n", "<C-PageUp>", ":bprevious<CR>", opts)

-- Clear highlighting
keymap("n", "<leader><space>", ":noh<CR>", opts) -- TODO Move to which key

-- Search for word under cursor on double click
keymap("n", "<2-leftMouse>", "*", opts)

-- Go to tag
keymap("n", "<a-]>",  "<cmd>lua require('telescope').extensions.ctags_plus.jump_to_tag()<cr>", opts)

-- Next and previous tag navigation
keymap("n", "]t", ":tn<CR>", opts)
keymap("n", "[t", ":tp<CR>", opts)

-- Quickfix navigation
keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[q", ":cprevious<CR>", opts)

-- ChatGPT
keymap("n", "<F8>", "<cmd>ChatGPT<CR>", opts)

------------------------------------------------------------------------------------------------
-- Insert --

------------------------------------------------------------------------------------------------
-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- When pasting over a selection in visual mode, replaced the _ registers with what was replace
-- So you can keep replacing. FIXME Is this really the best way for this issue?
keymap("v", "p", '"_dP', opts)

-- Declare function that uses telescope live_grep to search for content of register 0
-- This is used to search for the content of the yank register
function search_yank()
  local register = vim.fn.getreg('"')
  require("telescope.builtin").grep_string({ search = register })
end

keymap("v", "<leader>fw", "y<cmd>lua search_yank()<CR>", opts)

-- Run Chat GPT on the selected chunk
keymap("x", "<f8>", "<cmd>ChatGPTRunCustomCodeAction<CR>", opts);

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

------------------------------------------------------------------------------------------------
-- Terminal --
-- Better terminal navigation
-- FIXME: Review this when started to use terminal mode
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Commands --
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("WQ", "wq", {})
