local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {

    prompt_prefix = "> ",
    selection_caret = " ",
    path_display = { "truncate" },

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,
        ["<esc>"] = actions.close,
        -- WARNING: This will block entering normal mode, it's considered as not useful

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal, -- Send to a horizontal split
        ["<C-v>"] = actions.select_vertical, -- Send to a vertical split
        ["<C-t>"] = actions.select_tab, -- Send to a new tab

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        -- Selection for quickfix
        ["<Tab>"] = actions.toggle_selection, -- Select entry
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
      },


      n = {
        -- ["<esc>"] = actions.close,
        -- ["<c-c>"] = actions.close,
        --
        -- ["<CR>"] = actions.select_default,
        -- ["<C-x>"] = actions.select_horizontal,
        -- ["<C-v>"] = actions.select_vertical,
        -- ["<C-t>"] = actions.select_tab,
        --
        -- ["<Tab>"] = actions.toggle_selection,
        -- ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        --
        -- ["j"] = actions.move_selection_next,
        -- ["k"] = actions.move_selection_previous,
        -- ["<Down>"] = actions.move_selection_next,
        -- ["<Up>"] = actions.move_selection_previous,
        --
        -- ["gg"] = actions.move_to_top,
        -- ["G"] = actions.move_to_bottom,
        --
        -- ["<C-u>"] = actions.preview_scrolling_up,
        -- ["<C-d>"] = actions.preview_scrolling_down,
        --
        -- ["<PageUp>"] = actions.results_scrolling_up,
        -- ["<PageDown>"] = actions.results_scrolling_down,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
  },
}
