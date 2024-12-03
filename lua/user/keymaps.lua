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
--

------------------------------------------------------------------------------------------------
-- Normal --
-- Warning: All <leader> based commands in normal mode should be added in whichkey.lua
-- to make full use of whichkey

-- Navigate buffers
keymap("n", "<C-PageDown>", ":bnext<CR>", opts)
keymap("n", "<C-PageUp>", ":bprevious<CR>", opts)

-- Clear highlighting
keymap("n", "<leader><space>", ":noh<CR>", opts) -- TODO Move to which key

-- Search for word under cursor on double click
keymap("n", "<2-leftMouse>", "*N", opts)

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

-- LSP Hover (Also present with whichkey but this is for quick access)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)

-- Inlay hints toggler (Also present with whichkey but this is for quick access)
vim.keymap.set('n', 'H', require('user.lsp.keymaps_helpers').toggle_inlay_hints)

-- GPT New chat
vim.keymap.set('n', '<F12>', ":GpChatToggle<CR>")

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
keymap("v", "<F11>", "<cmd>'<,'>GpRewrite<CR>", opts)
keymap("v", "<F12>", "<cmd>'<,'>GpChatPaste<CR>", opts)

------------------------------------------------------------------------------------------------
-- Visual Block --
-- None

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--------------------------------WHICHKEY--------------------------------------------------------
------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------


local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local whichkey_mappings = {
    { "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight", nowait = true, remap = false },
    { "<leader>q", "<cmd>q!<CR>", desc = "Quit", nowait = true, remap = false },
    { "<leader>r", "<cmd>ProjectRoot<CR>", desc = "cwd to Project root", nowait = true, remap = false },
    { "<leader>w", "<cmd>bdelete!<CR>", desc = "Close Buffer", nowait = true, remap = false },
    { "<leader><S-w>", "<cmd>BufOnly<CR>", desc = "Close other Buffer", nowait = true, remap = false },

    { "<leader>L", group = "LSP Setup", nowait = true, remap = false },
    { "<leader>Lc", "<cmd>lua require('user.lsp.keymaps_helpers').print_lsp_server_capabilities()<cr>", desc = "Server Capabilities", nowait = true, remap = false },
    { "<leader>Lh", "<cmd>lua require('user.lsp.keymaps_helpers').toggle_inlay_hints()<cr>", desc = "Inlay Hints toggle", nowait = true, remap = false },
    { "<leader>Li", "<cmd>LspInfo<cr>", desc = "Info", nowait = true, remap = false },
    { "<leader>Ln", "<cmd>NullLsInfo<cr>", desc = "NullLs Info", nowait = true, remap = false },
    { "<leader>a", "<cmd>Alpha<cr>", desc = "Alpha", nowait = true, remap = false },
    { "<leader>b", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>", desc = "Buffers", nowait = true, remap = false },
    { "<leader>c", group = "ChatGPT/Copilot", nowait = true, remap = false },

    { "<leader>cc", group = "ChatGPT", nowait = true, remap = false },
    { "<leader>cca", "<cmd>GpAgent<cr>", desc = "Current Agent", nowait = true, remap = false },
    { "<leader>ccc", "<cmd>GpChatToggle<CR>", desc = "CGPT toggle chat", nowait = true, remap = false },
    { "<leader>ccg", "<cmd>GpNextAgent<cr>", desc = "Next Agent", nowait = true, remap = false },
    { "<leader>ccn", "<cmd>GpChatNew<CR>", desc = "CGPT new chat", nowait = true, remap = false },
    { "<leader>ccx", "<cmd>GpContext<cr>", desc = "Edit repo ctx file", nowait = true, remap = false },

    { "<leader>cp", group = "Copilot", nowait = true, remap = false },
    { "<leader>cpd", "<cmd>Copilot disable<CR>", desc = "CP disable", nowait = true, remap = false },
    { "<leader>cpe", "<cmd>Copilot enable<CR>", desc = "CP enable", nowait = true, remap = false },
    { "<leader>cpp", "<cmd>Copilot panel<CR>", desc = "CP panel", nowait = true, remap = false },
    { "<leader>cps", "<cmd>Copilot status<CR>", desc = "CP status", nowait = true, remap = false },

    { "<leader>d", group = "Diagnostics", nowait = true, remap = false },
    { "<leader>dd", "<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>", desc = "Toggle", nowait = true, remap = false },
    { "<leader>dh", "<cmd>lua vim.diagnostic.hide(nil, 0)<CR>", desc = "Hide", nowait = true, remap = false },
    { "<leader>dq", "<cmd>lua vim.diagnostic.setqflist()<CR>", desc = "as quickfix list", nowait = true, remap = false },
    { "<leader>ds", "<cmd>lua vim.diagnostic.show(nil, 0)<CR>", desc = "Show", nowait = true, remap = false },

    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer", nowait = true, remap = false },

    { "<leader>fF", "<cmd>lua require('telescope.builtin').find_files()<cr>", desc = "Find files with preview", nowait = true, remap = false },
    { "<leader>fT", "<cmd>Telescope tags <cr>", desc = "Tags in file (using treesitter)", nowait = true, remap = false },
    { "<leader>ff", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", desc = "Find files", nowait = true, remap = false },
    { "<leader>fh", "<cmd>Telescope oldfiles<cr>", desc = "Open Recent File History", nowait = true, remap = false },
    { "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Live Grep <C-space> for fuzzy filtering", nowait = true, remap = false },
    { "<leader>fp", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects", nowait = true, remap = false },
    { "<leader>ft", "<cmd>Telescope treesitter <cr>", desc = "Tags in file (using treesitter)", nowait = true, remap = false },
    { "<leader>fw", "<cmd>Telescope grep_string word_match=-w theme=ivy<cr>", desc = "Find exact word under cursor", nowait = true, remap = false },

    { "<leader>g", group = "Git", nowait = true, remap = false },
    { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer", nowait = true, remap = false },
    { "<leader>gb", "<cmd>TigBlame<cr>", desc = "Tig blame", nowait = true, remap = false },
    { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff", nowait = true, remap = false },
    { "<leader>gh", "<cmd>TigOpenCurrentFile<cr>", desc = "Tig file history", nowait = true, remap = false },
    { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk", nowait = true, remap = false },
    { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk", nowait = true, remap = false },
    { "<leader>gl", "<cmd>lua require 'gitsigns'.blame_line()<cr>", desc = "Blame", nowait = true, remap = false },
    { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk", nowait = true, remap = false },
    { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk", nowait = true, remap = false },
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Open changed file", nowait = true, remap = false },
    { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk", nowait = true, remap = false },


    { "<leader>l", group = "LSP", nowait = true, remap = false },
    { "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "Declaration", nowait = true, remap = false },
    { "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename", nowait = true, remap = false },
    { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols", nowait = true, remap = false },
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", nowait = true, remap = false },
    { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Definition", nowait = true, remap = false },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format{async=true}<cr>", desc = "Format", nowait = true, remap = false },
    { "<leader>lg", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "Signature Help", nowait = true, remap = false },
    { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover", nowait = true, remap = false },
    { "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "Implementation", nowait = true, remap = false },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "References", nowait = true, remap = false },
    { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols", nowait = true, remap = false },
    { "<leader>lt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Type Definition", nowait = true, remap = false },

    { "<leader>p", group = "Packer", nowait = true, remap = false },
    { "<leader>pS", "<cmd>PackerStatus<cr>", desc = "Status", nowait = true, remap = false },
    { "<leader>pc", "<cmd>PackerCompile<cr>", desc = "Compile", nowait = true, remap = false },
    { "<leader>pi", "<cmd>PackerInstall<cr>", desc = "Install", nowait = true, remap = false },
    { "<leader>ps", "<cmd>PackerSync<cr>", desc = "Sync", nowait = true, remap = false },
    { "<leader>pu", "<cmd>PackerUpdate<cr>", desc = "Update", nowait = true, remap = false },

    { "<leader>s", group = "Search with Telescope", nowait = true, remap = false },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands", nowait = true, remap = false },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages", nowait = true, remap = false },
    { "<leader>sR", "<cmd>Telescope registers<cr>", desc = "Registers", nowait = true, remap = false },
    { "<leader>sc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme", nowait = true, remap = false },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps", nowait = true, remap = false },
}
local whichkey_config = {
  ---@type false | "classic" | "modern" | "helix"
  preset = "classic",
  -- Delay before showing the popup. Can be a number or a function that returns a number.
  ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
  delay = function(ctx)
    return ctx.plugin and 0 or 200
  end,
  ---@param mapping wk.Mapping
  filter = function(mapping)
    -- example to exclude mappings without a description
    -- return mapping.desc and mapping.desc ~= ""
    return true
  end,
  --- You can add any mappings here, or use `require('which-key').add()` later
  ---@type wk.Spec
  spec = whichkey_mappings,
  -- show a warning when issues were detected with your mappings
  notify = true,
  -- Enable/disable WhichKey for certain mapping modes
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true, -- adds help for operators like d, y, ...
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  ---@type wk.Win.opts
  win = {
    -- don't allow the popup to overlap with the cursor
    no_overlap = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- col = 0,
    -- row = math.huge,
    -- border = "none",
    padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
    title = true,
    title_pos = "center",
    zindex = 1000,
    -- Additional vim.wo and vim.bo options
    bo = {},
    wo = {
      -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    },
  },
  layout = {
    width = { min = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
  keys = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  ---@type (string|wk.Sorter)[]
  --- Mappings are sorted using configured sorters and natural sort of the keys
  --- Available sorters:
  --- * local: buffer-local mappings first
  --- * order: order of the items (Used by plugins like marks / registers)
  --- * group: groups last
  --- * alphanum: alpha-numerical first
  --- * mod: special modifier keys last
  --- * manual: the order the mappings were added
  --- * case: lower-case first
  sort = { "local", "order", "group", "alphanum", "mod" },
  ---@type number|fun(node: wk.Node):boolean?
  expand = 0, -- expand groups when <= n mappings
  -- expand = function(node)
  --   return not node.desc -- expand all nodes without a description
  -- end,
  ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
      -- { "<Space>", "SPC" },
    },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    ellipsis = "…",
    --- See `lua/which-key/icons.lua` for more details
    --- Set to `false` to disable keymap icons
    ---@type wk.IconRule[]|false
    rules = {},
    -- use the highlights from mini.icons
    -- When `false`, it will use `WhichKeyIcon` instead
    colors = false, -- zfa: I don't use mini yet
    -- used by key format
    keys = {
      Up = " ",
      Down = " ",
      Left = " ",
      Right = " ",
      C = "󰘴 ",
      M = "󰘵 ",
      S = "󰘶 ",
      CR = "󰌑 ",
      Esc = "󱊷 ",
      ScrollWheelDown = "󱕐 ",
      ScrollWheelUp = "󱕑 ",
      NL = "󰌑 ",
      BS = "⌫",
      Space = "󱁐 ",
      Tab = "󰌒 ",
      F1 = "󱊫",
      F2 = "󱊬",
      F3 = "󱊭",
      F4 = "󱊮",
      F5 = "󱊯",
      F6 = "󱊰",
      F7 = "󱊱",
      F8 = "󱊲",
      F9 = "󱊳",
      F10 = "󱊴",
      F11 = "󱊵",
    F12 = "󱊶",
    },
  },
  show_help = true, -- show a help message in the command line for using WhichKey
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
  -- Which-key automatically sets up triggers for your mappings.
  -- But you can disable this and setup the triggers yourself.
  -- Be aware, that triggers are not needed for visual and operator pending mode.
  disable = {
    -- disable WhichKey for certain buf types and file types.
    ft = {},
    bt = {},
  },
  debug = false, -- enable wk.log in the current directory
}


which_key.setup(whichkey_config)
