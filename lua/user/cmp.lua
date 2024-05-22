-- Setup of the cmp plugin for autocompletion

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  return
end

require("luasnip/loaders/from_vscode").lazy_load()

--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = ""
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

-- Override default <C-N> and <C-P> autocomplete mappings to nothing
-- so i am obliged to use <c-space> to open the autocomplete menu
vim.api.nvim_set_keymap("i", "<C-n>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-p>", "<Nop>", { noremap = true, silent = true })

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- If select is true
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<CR>"] = cmp.mapping.confirm { select = false },
    ["<Tab>"] = cmp.config.disable
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        buffer = "[Buffer]",
        path = "[Path]",
        nvim_lua = "[nvim config cmp]",
      })[entry.source.name] or entry.source.name
      return vim_item
    end,
  },

  sources = {
    -- Order is important = Order it is shown
    -- Add new sources to this
    { name = "nvim_lsp" },
    { name = "path" }, -- hrsh7th / cmp-path
    { name = "luasnip"  }, -- hrsh7th / cmp-luasnip (for snippets)
    { name = 'nvim_lua' }, -- hrsh7th / cmp-nvim-lua (for nvim API completion, FIXME to replace by lua_lsp ?)
    { name = "cmp-nvim-lsp" }, -- hrsh7th / cmp-nvim-lsp
    { name = "buffer",
      option = {
        get_bufnrs = function()
          -- Consider all open buffers
          return vim.api.nvim_list_bufs()
        end
      },
      max_items_count = 4 -- Only allow few buffer suggestions otherwise it will crowd
    }
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  experimental = {
    ghost_text = false, -- Very bad
    native_menu = false
  },
}

