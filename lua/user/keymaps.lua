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

-- Next and previous tag navigation
keymap("n", "]t", ":tn<CR>", opts)
keymap("n", "[t", ":tp<CR>", opts)
keymap("n", "<C-]>", "g<C-]>", opts)

-- Quickfix navigation
keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[q", ":cprevious<CR>", opts)

-- Enable/Disable copilot ]p and [p
keymap("n", "]p", "<cmd>Copilot enable<CR>", opts)
keymap("n", "[p", "<cmd>Copilot disable<CR>", opts)

------------------------------------------------------------------------------------------------
-- Insert --

-- These plugins have some instert mode mappings
-- cmp.lua
-- lsp/init.lua
-- ..

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

keymap("v", "<leader>f", "y<cmd>lua search_yank()<CR>", opts)

-- GPT rewrite https://github.com/Robitx/gp.nvim
keymap("v", "<F1>", "<cmd>'<,'>GpChatPaste<CR>", opts)
keymap("v", "<F2>", "<cmd>'<,'>GpRewrite<CR>", opts)
keymap("v", "<F3>", "<cmd>'<,'>GpImplement<CR>", opts)

------------------------------------------------------------------------------------------------
-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--------------------------------WHICHKEY--------------------------------------------------------
------------------------------------------------------------------------------------------------
-- Functions for whichkkey

function Print_lsp_server_capabilities()
  local client_id = vim.lsp.get_active_clients()
  if next(client_id) == nil then
    print("No active LSP clients")
    return
  end
  local client = client_id[1]
  if client ~= nil then

    local cap = vim.inspect(client.server_capabilities)
    -- Print cap to buffer (it has newline)
    vim.api.nvim_command("new")
    for line in cap:gmatch("[^\r\n]+") do
      vim.api.nvim_buf_set_lines(0, -1, -1, false, { line })
    end
  end
end
------------------------------------------------------------------------------------------------


local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}
local mappings = {
  ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
  ["b"] = {
    "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
    "Buffers",
  },
  c = {
    name = "ChatGPT/Copilot",
    ["c"] = {
      name = "ChatGPT",
      ["n"] = { "<cmd>GpChatNew<CR>", "CGPT new chat"},
      ["g"] = { "<cmd>GpNextAgent<cr>", "Next Agent" },
      ["c"] = { "<cmd>GpAgent<cr>", "Current Agent" },
      ["w"] = { "<cmd>GpWhisper<cr>", "Voice chat" },
      ["x"] = { "<cmd>GpContext<cr>", "Edit repo ctx file"},
      ["a"] = { "<cmd>GpAppend<cr>", "Append to repo ctx file"},
      ["p"] = { "<cmd>GpPrepend<cr>", "Prepend to repo ctx file"},
      ["F1"] = {"", "Visual mode - Paste and chat"},
      ["F2"] = {"", "Visual mode - Rewrite"},
      ["F3"] = {"", "Visual mode - Implement"},
    },
    ["p"] = {
      name = "Copilot",
      ["s"] = { "<cmd>Copilot status<CR>", "CP status" },
      ["p"] = { "<cmd>Copilot panel<CR>", "CP panel" },
      ["d"] = { "<cmd>Copilot disable<CR>", "CP disable" },
      ["e"] = { "<cmd>Copilot enable<CR>", "CP enable" },
    }
  },
  ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  ["q"] = { "<cmd>q!<CR>", "Quit" },
  ["w"] = { "<cmd>bdelete!<CR>", "Close Buffer" },
  ["<S-w>"] = { "<cmd>BufOnly<CR>", "Close other Buffer" },
  ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
  ["r"] = { "<cmd>ProjectRoot<CR>", "cwd to Project root" },
  f =
  {
    ["f"] = {
      "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
      "Find files",
    },

    ["F"] = {
      "<cmd>lua require('telescope.builtin').find_files()<cr>",
      "Find files with preview",
    },
    ["p"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
    ["w"] = { "<cmd>Telescope grep_string word_match=-w theme=ivy<cr>", "Find exact word under cursor" },
    ["l"] = { "<cmd>Telescope live_grep<cr>", "Live Grep <C-space> for fuzzy filtering" },
    ["h"] = { "<cmd>Telescope oldfiles<cr>", "Open Recent File History" },
    ["t"] = { "<cmd>Telescope treesitter <cr>", "Tags in file (using treesitter)" },
    ["T"] = { "<cmd>Telescope tags <cr>", "Tags in file (using treesitter)" }

  },

  p = {
    name = "Packer",
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    s = { "<cmd>PackerSync<cr>", "Sync" },
    S = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },

  g = {
    name = "Git",
    -- g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" }, -- Depends on termtoggle removed plugin
    b = { "<cmd>TigBlame<cr>", "Tig blame" },
    s = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    h = { "<cmd>TigOpenCurrentFile<cr>", "Tig file history" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    d = {
      "<cmd>Gitsigns diffthis HEAD<cr>",
      "Diff",
    },
  },

  l = {
    name = "LSP",
    d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
    t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
    D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
    h = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
    r = { "<cmd>lua vim.lsp.buf.references()<cr>", "References" },
    R = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    n = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help" },
    N = { "<cmd>NullLsInfo<cr>", "NullLs Info" },
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
    i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation" },
    I = { "<cmd>LspInfo<cr>", "Info" },
    c = { "<cmd>lua Print_lsp_server_capabilities()<cr>", "Server Capabilities" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
  },
  d = {
    name = "Diagnostics",
    l = { "<cmd>Trouble document_diagnostics<cr>", "Document Diagnostics (Trouble)" },
    w = { "<cmd>Trouble workspace_diagnostics<cr>", "Workspace Diagnostics (Trouble)" },
    q = { "<cmd>TroubleClose<cr>", "Close Trouble" },
  },
  s = {
    name = "Search with Telescope",
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
  },

}

which_key.setup(setup)
which_key.register(mappings, opts)
